SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE   FUNCTION [dbo].[fns_CalcularICMS](
    @UnidadeID INT,
    @ParticipanteID INT,
    @ProdutoImportado BIT = 0        -- 1=Importado ou conteúdo importação > 40%
)
RETURNS TABLE
AS
RETURN
(
    WITH
	 -- =====================================================
    -- TABELA 1: Estabelecimento
    -- Fonte: Gilson Almeida
    -- =====================================================
	CTE_Estabelecimento AS (SELECT 
	                          RegimeID,
							  1 SimplesAnexo,-- 1=Comércio, 2=Indústria, 3-5=Serviços
							  UF,
							  ISNULL(SUM(VL_NF), 0.00)Faturamento
	                        FROM dbo.VWS_Unidades
							  JOIN dbo.FIS_Unidade ON FIS_Unidade.UnidadeID = VWS_Unidades.UnidadeID
							  LEFT JOIN dbo.MovNota0 ON MovNota0.UnidadeID = FIS_Unidade.UnidadeID
							  LEFT JOIN dbo.VWS_Movimento_Totais 
							    ON VWS_Movimento_Totais.Chave = MovNota0.Chave
							   AND DtMovimento BETWEEN 
									CONVERT(DATE, DATEADD(MONTH, -12, DATEFROMPARTS(YEAR(GETDATE()), MONTH(GETDATE()), 1)))
									AND CONVERT(DATE, DATEADD(DAY, -1, DATEFROMPARTS(YEAR(GETDATE()), MONTH(GETDATE()), 1)))

	                        WHERE VWS_Unidades.UnidadeID=@UnidadeID 
							GROUP BY RegimeID, UF
							),
    
	-- =====================================================
    -- TABELA 2: Participante Emitente/Destinatario
    -- Fonte: Gilson Almeida
    -- =====================================================
	CTE_Participante AS (SELECT ISNULL(VWS_Pessoas.UF, VWS_Unidades.UF)UF FROM dbo.VWS_Pessoas, dbo.VWS_Unidades WHERE VWS_Pessoas.PessoaID=@ParticipanteID AND UnidadeID=@UnidadeID ),
    
	-- =====================================================
    -- TABELA 1: ALÍQUOTAS INTERNAS POR ESTADO (2025)
    -- Fonte: Legislação estadual de cada UF
    -- =====================================================
    CTE_AliquotasInternas AS (
        SELECT * FROM (VALUES  
            -- NORTE
            ('AC', 19.00, 'Acre'),
            ('AM', 18.00, 'Amazonas'),
            ('AP', 18.00, 'Amapá'),
            ('PA', 19.00, 'Pará'),
            ('RO', 17.50, 'Rondônia'),
            ('RR', 17.00, 'Roraima'),
            ('TO', 18.00, 'Tocantins'),
            
            -- NORDESTE
            ('AL', 19.00, 'Alagoas'),
            ('BA', 20.50, 'Bahia'),      -- Maior alíquota do Brasil
            ('CE', 18.00, 'Ceará'),
            ('MA', 18.00, 'Maranhão'),
            ('PB', 20.00, 'Paraíba'),
            ('PE', 18.00, 'Pernambuco'),
            ('PI', 18.00, 'Piauí'),
            ('RN', 18.00, 'Rio Grande do Norte'),
            ('SE', 19.00, 'Sergipe'),
            
            -- CENTRO-OESTE
            ('DF', 20.00, 'Distrito Federal'),
            ('GO', 19.00, 'Goiás'),
            ('MS', 17.00, 'Mato Grosso do Sul'),
            ('MT', 17.00, 'Mato Grosso'),
            
            -- SUL
            ('PR', 18.00, 'Paraná'),
            ('RS', 17.00, 'Rio Grande do Sul'),
            ('SC', 17.00, 'Santa Catarina'),
            
            -- SUDESTE
            ('ES', 17.00, 'Espírito Santo'), -- ESPECIAL: destino sempre 7%
            ('MG', 18.00, 'Minas Gerais'),
            ('RJ', 20.00, 'Rio de Janeiro'),
            ('SP', 18.00, 'São Paulo')
        ) AS t(UF, AliquotaInterna, NomeEstado)
    ),
    
    -- =====================================================
    -- TABELA 2: CLASSIFICAÇÃO REGIONAL (IBGE)
    -- Parente: 1=Norte, 2=Nordeste, 3=Sul, 4=Sudeste, 5=Centro-Oeste
    -- =====================================================
    CTE_Regioes AS (
        SELECT O.UFID, O.UF, O.Nome, O.Parente,
               CASE O.Parente
                   WHEN 1 THEN 'Norte'
                   WHEN 2 THEN 'Nordeste'
                   WHEN 3 THEN 'Sul'
                   WHEN 4 THEN 'Sudeste'
                   WHEN 5 THEN 'Centro-Oeste'
               END AS NomeRegiao
        FROM dbo.LkpUF0 O
        WHERE O.UFID BETWEEN 6 AND 98
    ),
    
    -- =====================================================
    -- TABELA 3: SIMPLES NACIONAL - FAIXAS 2025
    -- Fonte: Lei Complementar 123/2006 atualizada
    -- =====================================================
    CTE_SimplesNacional AS (
        SELECT * FROM (VALUES
            -- ANEXO I - COMÉRCIO (alíquota ICMS sobre receita bruta)
            (1, 'Comércio', 1, 0.00, 180000.00, 0.00, 'Isento'),
            (1, 'Comércio', 2, 180000.01, 360000.00, 0.86, '0.86%'),
            (1, 'Comércio', 3, 360000.01, 720000.00, 1.16, '1.16%'),
            (1, 'Comércio', 4, 720000.01, 1800000.00, 1.50, '1.50%'),
            (1, 'Comércio', 5, 1800000.01, 3600000.00, 1.86, '1.86%'),
            (1, 'Comércio', 6, 3600000.01, 4800000.00, 2.33, '2.33%'),
            
            -- ANEXO II - INDÚSTRIA (mesmas alíquotas do comércio)
            (2, 'Indústria', 1, 0.00, 180000.00, 0.00, 'Isento'),
            (2, 'Indústria', 2, 180000.01, 360000.00, 0.86, '0.86%'),
            (2, 'Indústria', 3, 360000.01, 720000.00, 1.16, '1.16%'),
            (2, 'Indústria', 4, 720000.01, 1800000.00, 1.50, '1.50%'),
            (2, 'Indústria', 5, 1800000.01, 3600000.00, 1.86, '1.86%'),
            (2, 'Indústria', 6, 3600000.01, 4800000.00, 2.33, '2.33%'),
            
            -- ANEXO III - SERVIÇOS COM ICMS (alíquotas menores)
            (3, 'Serviços c/ ICMS', 1, 0.00, 180000.00, 0.00, 'Isento'),
            (3, 'Serviços c/ ICMS', 2, 180000.01, 360000.00, 0.31, '0.31%'),
            (3, 'Serviços c/ ICMS', 3, 360000.01, 720000.00, 0.40, '0.40%'),
            (3, 'Serviços c/ ICMS', 4, 720000.01, 1800000.00, 0.42, '0.42%'),
            (3, 'Serviços c/ ICMS', 5, 1800000.01, 3600000.00, 0.44, '0.44%'),
            (3, 'Serviços c/ ICMS', 6, 3600000.01, 4800000.00, 0.46, '0.46%'),
            
            -- ANEXOS IV e V - SERVIÇOS SEM ICMS
            (4, 'Serviços s/ ICMS', 1, 0.00, 4800000.00, 0.00, 'Não incide'),
            (5, 'Serviços s/ ICMS', 1, 0.00, 4800000.00, 0.00, 'Não incide')
        ) AS t(Anexo, TipoAnexo, Faixa, FaturamentoMin, FaturamentoMax, AliquotaICMS, Descricao)
    ),
    
    -- =====================================================
    -- TABELA 4: EXCEÇÕES BILATERAIS (Convênios CONFAZ)
    -- Adicionar aqui acordos específicos entre estados
    -- =====================================================
    CTE_ExcecoesEspecificas AS (
        SELECT * FROM (VALUES
            -- Exemplo: Protocolo ICMS específico SP-RJ
            -- ('SP', 'RJ', 18.00, 'Protocolo ICMS XX/2025'),
            -- ('RJ', 'SP', 18.00, 'Protocolo ICMS XX/2025')
            (NULL, NULL, NULL, NULL) -- Placeholder (remover quando adicionar exceções)
        ) AS t(OrigemUF, DestinoUF, Aliquota, Fundamento)
        WHERE OrigemUF IS NOT NULL -- Filtro para ignorar placeholder
    ),
    
    -- =====================================================
    -- BUSCA DOS DADOS DE ORIGEM E DESTINO
    -- =====================================================
    Origem AS (
        SELECT R.*, AI.AliquotaInterna 
        FROM CTE_Regioes R
		JOIN CTE_Estabelecimento ON CTE_Estabelecimento.UF = R.UF
        LEFT JOIN CTE_AliquotasInternas AI ON AI.UF = R.UF
        
    ),
    Destino AS (
        SELECT R.*, AI.AliquotaInterna 
        FROM CTE_Regioes R
		JOIN CTE_Participante ON CTE_Participante.UF = R.UF
        LEFT JOIN CTE_AliquotasInternas AI ON AI.UF = R.UF
       
    )
    
    -- =====================================================
    -- QUERY PRINCIPAL - CÁLCULO DAS ALÍQUOTAS
    -- =====================================================
    SELECT 
        -- IDENTIFICAÇÃO DA OPERAÇÃO
        CTE_Estabelecimento.UF AS OrigemUF,
        CTE_Participante.UF AS DestinoUF,
        O.Nome AS OrigemNome,
        D.Nome AS DestinoNome,
        O.NomeRegiao AS OrigemRegiao,
        D.NomeRegiao AS DestinoRegiao,
        
        -- REGIME TRIBUTÁRIO
        CTE_Estabelecimento.RegimeID AS RegimeTributario,
        CASE CTE_Estabelecimento.RegimeID 
            WHEN 0 THEN 'Simples Nacional'
            WHEN 1 THEN 'Simples Nacional - Excesso Sublimite'
            WHEN 2 THEN 'Lucro Presumido'  
            WHEN 3 THEN 'Lucro Real'
            ELSE 'Regime não identificado'
        END AS RegimeDescricao,
        
        -- =====================================================
        -- CÁLCULO PRINCIPAL DA ALÍQUOTA
        -- =====================================================
        CASE 
            -- >>> SIMPLES NACIONAL <<<
            WHEN CTE_Estabelecimento.RegimeID = 0 THEN
                CASE
                    -- Operação INTERNA no Simples: usa tabela progressiva
                    WHEN CTE_Estabelecimento.UF = CTE_Participante.UF THEN 
                        COALESCE(SN.AliquotaICMS, 0.00)
                    
                    -- Operação INTERESTADUAL no Simples: mesmas regras gerais
                    ELSE 
                        CASE
                            -- 1. PRODUTO IMPORTADO = 4%
                            WHEN @ProdutoImportado = 1 THEN 4.00
                            
                            -- 2. DESTINO ES = 7% (benefício fiscal)
                            WHEN CTE_Participante.UF = 'ES' THEN 7.00
                            
                            -- 3. ORIGEM ES = 12% (não tem benefício)
                            WHEN CTE_Estabelecimento.UF = 'ES' THEN 12.00
                            
                            -- 4. DESENVOLVIDOS → MENOS DESENVOLVIDOS = 7%
                            -- Sul/Sudeste (exceto ES) → Norte/Nordeste/Centro-Oeste
                            WHEN O.Parente IN (3, 4) -- Sul ou Sudeste
                                 AND CTE_Estabelecimento.UF <> 'ES' -- Exceto ES
                                 AND D.Parente IN (1, 2, 5) -- Norte, Nordeste ou Centro-Oeste
                            THEN 7.00
                            
                            -- 5. TODOS OS OUTROS CASOS = 12%
                            ELSE 12.00
                        END
                END
            
            -- >>> DEMAIS REGIMES (Excesso, Presumido, Real) <<<
            ELSE
                CASE
                    -- Operação INTERNA: alíquota do estado
                    WHEN CTE_Estabelecimento.UF = CTE_Participante.UF THEN O.AliquotaInterna
                    
                    -- Operação INTERESTADUAL: aplicar regras
                    ELSE 
                        -- Primeiro verifica exceções bilaterais
                        COALESCE(
                            EX.Aliquota,
                            -- Senão, aplica regras gerais
                            CASE
                                -- 1. PRODUTO IMPORTADO = 4%
                                WHEN @ProdutoImportado = 1 THEN 4.00
                                
                                -- 2. DESTINO ES = 7%
                                WHEN CTE_Participante.UF = 'ES' THEN 7.00
                                
                                -- 3. ORIGEM ES = 12%
                                WHEN CTE_Estabelecimento.UF = 'ES' THEN 12.00
                                
                                -- 4. SUL/SUDESTE → N/NE/CO = 7%
                                WHEN O.Parente IN (3, 4) 
                                     AND CTE_Estabelecimento.UF <> 'ES'
                                     AND D.Parente IN (1, 2, 5) 
                                THEN 7.00
                                
                                -- 5. PADRÃO = 12%
                                ELSE 12.00
                            END
                        )
                END
        END AS AliquotaCalculada,
        
        -- =====================================================
        -- CLASSIFICAÇÃO DO TIPO DE OPERAÇÃO
        -- =====================================================
        CASE 
            WHEN CTE_Estabelecimento.UF = CTE_Participante.UF THEN 
                'OPERAÇÃO INTERNA'
                
            WHEN @ProdutoImportado = 1 THEN 
                'PRODUTO IMPORTADO (4%)'
                
            WHEN EX.Aliquota IS NOT NULL THEN 
                'EXCEÇÃO BILATERAL'
                
            WHEN CTE_Participante.UF = 'ES' THEN 
                'DESTINO ES - BENEFÍCIO (7%)'
                
            WHEN CTE_Estabelecimento.UF = 'ES' THEN 
                'ORIGEM ES - SEM BENEFÍCIO (12%)'
                
            WHEN O.Parente IN (3, 4) 
                 AND CTE_Estabelecimento.UF <> 'ES'
                 AND D.Parente IN (1, 2, 5) 
            THEN 
                'INCENTIVO DESENVOLVIMENTO (7%)'
                
            WHEN O.Parente IN (1, 2, 5) 
                 AND D.Parente IN (3, 4) 
            THEN 
                'MENOS DESENVOLVIDO → DESENVOLVIDO (12%)'
                
            WHEN O.Parente = D.Parente THEN 
                'MESMA REGIÃO (12%)'
                
            ELSE 
                'INTERESTADUAL PADRÃO (12%)'
        END AS TipoOperacao,
        
        -- =====================================================
        -- FUNDAMENTO LEGAL
        -- =====================================================
        CASE 
            WHEN CTE_Estabelecimento.UF = CTE_Participante.UF THEN 
                'Art. 155, §2º, I, CF/88 - Operação Interna'
                
            WHEN @ProdutoImportado = 1 THEN 
                'Resolução Senado 13/2012, Art. 1º, I - Produto Importado'
                
            WHEN EX.Aliquota IS NOT NULL THEN 
                COALESCE(EX.Fundamento, 'Convênio CONFAZ Específico')
                
            WHEN CTE_Participante.UF = 'ES' OR 
                 (O.Parente IN (3, 4) AND CTE_Estabelecimento.UF <> 'ES' AND D.Parente IN (1, 2, 5))
            THEN 
                'Resolução Senado 13/2012, Art. 1º, III - Incentivo Regional'
                
            ELSE 
                'Resolução Senado 13/2012, Art. 1º, II - Alíquota Padrão'
        END AS FundamentoLegal,
        
        -- =====================================================
        -- INFORMAÇÕES DO SIMPLES NACIONAL (se aplicável)
        -- =====================================================
        CASE 
            WHEN CTE_Estabelecimento.RegimeID = 0 AND SN.Anexo IS NOT NULL THEN
                CONCAT('Anexo ', CAST(SN.Anexo AS VARCHAR), ' - ', SN.TipoAnexo, 
                       ' | Faixa ', CAST(SN.Faixa AS VARCHAR), 
                       ' | ', SN.Descricao)
            ELSE NULL
        END AS SimplesDetalhamento,
        
        -- =====================================================
        -- OBSERVAÇÕES E ALERTAS
        -- =====================================================
        CASE
            WHEN CTE_Estabelecimento.RegimeID = 0 AND Faturamento > 4800000.00 THEN
                '⚠️ ATENÇÃO: Faturamento acima do limite do Simples Nacional'
                
            WHEN @ProdutoImportado = 1 AND CTE_Estabelecimento.UF = CTE_Participante.UF THEN
                '⚠️ Produto importado em operação interna - verificar ICMS-ST'
                
            WHEN CTE_Estabelecimento.UF = 'ES' AND D.Parente IN (1, 2, 5) THEN
                '📌 ES não tem benefício de 7% quando é origem'
                
            ELSE NULL
        END AS Observacoes
        
    FROM Origem O
    CROSS JOIN Destino D
	JOIN CTE_Estabelecimento ON CTE_Estabelecimento.UF = O.UF
	JOIN CTE_Participante ON CTE_Participante.UF = D.UF
    LEFT JOIN CTE_SimplesNacional SN 
        ON SN.Anexo = CTE_Estabelecimento.SimplesAnexo 
        AND Faturamento BETWEEN SN.FaturamentoMin AND SN.FaturamentoMax
        AND CTE_Estabelecimento.RegimeID = 0
    LEFT JOIN CTE_ExcecoesEspecificas EX 
        ON EX.OrigemUF = CTE_Estabelecimento.UF 
        AND EX.DestinoUF = CTE_Participante.UF
);

GO
