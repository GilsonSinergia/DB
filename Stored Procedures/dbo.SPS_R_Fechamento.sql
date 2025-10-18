SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE   PROCEDURE [dbo].[SPS_R_Fechamento]
	@UnidadeID INT =10,
	@Data DATETIME = '20250930',
	@Resumo BIT = 0,
	@ValorInformado FLOAT = 0,  
	@Chave CHAR(14) = NULL
AS	
	/* Parâmetros de exibição */
	DECLARE @NivelMaximo INT = NULL;   -- ex.: 3 para cortar no nível 3; NULL = todos
	DECLARE @OcultarZeros BIT = 0;     -- 1 = oculta nós zerados sem movimento; 0 = mostra tudo
	/* Parâmetros existentes */
	
	DECLARE 
	  @Debug INT = 1,
	  @AnoMes INT = YEAR(@Data)*100+MONTH(@Data),
	  @DtIni DATE;


	-- Estrutura estática mínima
	DECLARE @Estrutura TABLE (
		ID            BIGINT        NOT NULL,              -- código da conta sintética
		Conta         VARCHAR(120)  NOT NULL,              -- descrição da conta
		Valor         DECIMAL(18,2) NOT NULL DEFAULT 0.00, -- valor próprio da conta
		Parente       INT           NULL,                  -- id da conta pai
		Multiplicado  INT           NOT NULL DEFAULT 1,    -- +1 soma, -1 abate
		Dedutor       BIT           NOT NULL DEFAULT 0      -- marcação para (-)
	);

	--SELECT Exponente = LOG10(POWER(10, 9));


	INSERT INTO @Estrutura (ID, Conta, Parente, Multiplicado, Dedutor) VALUES
	-- Balanço Patrimonial
	(1 ,'BALANÇO PATRIMONIAL',NULL,1,0),
	
	(11,'ATIVO',1,1,0),
	
	(112,'Contas a Receber',11,1,0),
	(113,'Estoques (custo médio)',11,1,0),
	(114,'Créditos de Impostos',11,1,0),
	(115,'Imobilizado',11,1,0),
	
	(12,'PASSIVO',1,-1,0),
	(121,'Contas a Pagar',12,1,0),
	(122,'Impostos a Recolher',12,1,0),
	(13,'PATRIMÔNIO LÍQUIDO',1,-1,0),
	(131,'Capital Social',13,1,0),

	-- DRE consolidado
	(2,'DRE – Resultado do Exercício',NULL, 1,0),
	
	--Dinâmicos Serão acrescentados somente se houver mais de um 2 regime 
	(21,'Resultado simples nacional',2, 1,0),

	(22,'Resultado simples nacional Exceder o limite ',2, 1,0),
	--Estabelecimentos filiais Dinâmico Será adicionado ao regime caso exista mais de um Mas o contrário adicionado ao grupo Dre 
	--Só será criada Se houver mais de um estabelecimento 
	--Caso regimes subsequentes Tenho mais de uma unidade adotar a mesma lógica 
	(23,'Resultado Lucro presumido ',22, 1,0),
	(24,'Resultado Lupp real',22, 1,0),
	(241,'Unidade de negócio 0001-00 ',24, 1,0),
	(242,'Unidade de negócio 0002-80 ',24, 1,0)


	UPDATE @Estrutura SET ID = ID * POWER(10,9- LEN(ID)), Parente = Parente * POWER(10,9- LEN(Parente))

	/* Chave computada = UUTTMMMMMMMMMM já existe na sua base (MovNota0/MI); aqui só consumimos. */
	SELECT @DtIni = CONVERT(DATETIME, @Data) - DAY(@Data)+1;

	/* Unidades / Regime / (CNPJ se houver) */
	DECLARE @Unidades TABLE (
	  UnidadeID INT,
	  RegimeID  INT,
	  Atividade INT,
	  IRPJ      DECIMAL(6,4),
	  CSLL      DECIMAL(6,4),
	  CNPJ      VARCHAR(18) NULL
	);
	INSERT @Unidades (UnidadeID, RegimeID, Atividade, IRPJ, CSLL, CNPJ)
	SELECT FIS_Unidade.UnidadeID, RegimeID, Atividade, IRPJ, CSLL, Documento /* ajuste se tiver coluna CNPJ */
	FROM dbo.FIS_Unidade
	JOIN dbo.VWS_Unidades ON VWS_Unidades.UnidadeID = FIS_Unidade.UnidadeID;


	;WITH Disponibilidados AS (
	SELECT 
	  FORMAT(C.UnidadeID, '00')+FORMAT(B.OperacaoID+1, '00')+FORMAT(B.MovimentoID, '0000000000')Chave,
	  1 DestinoID,
	  'Saldos' Destino,
	  B.Valor,
	  Multiplicador,
	  C.TipoID + 1 TipoID,
	  Tipo,
	  Banco.PortadorID BancoID,
	  Banco.Portador Banco,
	  Titular.PessoaID TitularID,
	  Titular.Reduzido Titular
	FROM dbo.MovFina2 B
	JOIN dbo.LkpBaix1 ON LkpBaix1.OperacaoID = B.OperacaoID
	JOIN dbo.CadCont0 C ON C.ContaID = B.ContaID
	JOIN dbo.LkpCont0 ON LkpCont0.TipoID = C.TipoID
	JOIN dbo.CadPort0 Banco ON Banco.PortadorID = C.PortadorID
	JOIN dbo.CadPess0 Titular ON Titular.PessoaID = C.PessoaID
	WHERE B.StatusID = 3
	  AND B.DtConciliacao <= @Data
	)
	
	SELECT 
	1 ID,'Disponibilidades' Conta, SUM(D.Valor * D.Multiplicador)Valor  
	FROM Disponibilidados D
	UNION ALL
	SELECT 
    D.TipoID, D.Tipo, SUM(D.Valor * D.Multiplicador)Valor  
	FROM Disponibilidados D 
	GROUP BY D.TipoID, D.Tipo
	UNION ALL
	SELECT 
    D.BancoID, D.Banco, SUM(D.Valor * D.Multiplicador)Valor
	FROM Disponibilidados D 
	GROUP BY D.BancoID, D.Banco




/* =========================
   1) ÁRVORE (hierarquia)
   ========================= */
;WITH H AS (
    -- Raízes
    SELECT
        e.ID,
        e.Parente,
        e.Conta,
		CONVERT(NVARCHAR(400), e.Conta)ContaCompleta,
        e.Valor,            -- valor próprio (analítico ou sintético, se você popular)
        e.Multiplicado,     -- +1 / -1 (sinal do elo para o pai)
        e.Dedutor,          -- só apresentação ("(-)")
        1 AS Nivel,
        CAST(CAST(ROW_NUMBER() OVER (ORDER BY e.ID) AS VARCHAR(10)) AS VARCHAR(100)) AS Codigo
    FROM @Estrutura e
    WHERE e.Parente IS NULL

    UNION ALL

    -- Filhos (cada elo gera um segmento; a partir do 4º nível, fixa 2 dígitos com zero à esquerda)
    SELECT
        e.ID,
        e.Parente,
        e.Conta,
		CONVERT(NVARCHAR(400),H.Conta +NCHAR(8594)+ e.Conta)ContaCompleta,
        e.Valor,
        e.Multiplicado,
        e.Dedutor,
        h.Nivel + 1 AS Nivel,
        CAST(
            h.Codigo + '.' +
            CASE WHEN h.Nivel + 1 >= 3
                 THEN RIGHT('00' + CAST(ROW_NUMBER() OVER (PARTITION BY e.Parente ORDER BY e.ID) AS VARCHAR(2)), 2)
                 ELSE CAST(ROW_NUMBER() OVER (PARTITION BY e.Parente ORDER BY e.ID) AS VARCHAR(1))
            END
            AS VARCHAR(100)
        ) AS Codigo
    FROM @Estrutura e
    JOIN H ON H.ID = e.Parente
),

/* =========================
   2) FECHO (ancestor → descendant) com peso do caminho
   ========================= */
Edges AS (
    -- Elos diretos: pai -> filho, peso = Multiplicado do filho
    SELECT
        p.ID  AS AncestorID,
        c.ID  AS DescID,
        c.Multiplicado AS weight
    FROM H p
    JOIN H c ON c.Parente = p.ID

    UNION ALL
    -- Caminhos mais profundos: multiplica os sinais ao descer
    SELECT
        e.AncestorID,
        d.ID        AS DescID,
        e.weight * d.Multiplicado AS weight
    FROM Edges e
    JOIN H d ON d.Parente = e.DescID
),

/* =========================
   3) ACUMULADO bottom-up
   ========================= */
Agg AS (
    SELECT
        h.ID,
        IIF(h.Dedutor=1, '(-) ','')+h.Conta Conta,
		h.Codigo,
		IIF(h.Dedutor=1, '(-) ','')+h.ContaCompleta ContaCompleta,
        h.Nivel,
        h.Dedutor,
        h.Valor AS valor_proprio,
        -- Tem movimento? (próprio ≠ 0 ou algum descendente com valor ≠ 0)
        CASE
           WHEN h.Valor <> 0
                OR EXISTS (
                    SELECT 1
                    FROM Edges x
                    JOIN H d ON d.ID = x.DescID
                    WHERE x.AncestorID = h.ID
                      AND d.Valor <> 0
                )
           THEN 1 ELSE 0
        END AS HasMov,
        -- próprio + soma(descendentes ponderados pelo peso do caminho)
        h.Valor
        + ISNULL((
            SELECT SUM(d.Valor * x.weight)
            FROM Edges x
            JOIN H d ON d.ID = x.DescID
            WHERE x.AncestorID = h.ID
        ), 0) AS valor_cumulativo
    FROM H h
)

SELECT
    ID,
    Agg.Conta,
	Agg.Nivel,
	Agg.Codigo,
	SPACE(LEN(Agg.Codigo))+Agg.Conta ContaIdentada,
    Agg.valor_cumulativo Valor,
	Agg.ContaCompleta
FROM Agg
WHERE (@NivelMaximo IS NULL OR Nivel <= @NivelMaximo)
  AND (@OcultarZeros = 0 OR valor_cumulativo <> 0 OR HasMov = 1)
ORDER BY codigo
OPTION (MAXRECURSION 32767);



GO
