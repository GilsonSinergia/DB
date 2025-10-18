SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SP_Liberacao_Estoque]
    @Chave CHAR(14),
    @Data DATE = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Validações básicas da chave
    IF @Chave IS NULL OR @Chave = ''
    BEGIN
        RAISERROR('Chave do documento é obrigatória', 16, 1);
        RETURN;
    END
    
    IF LEN(@Chave) <> 14
    BEGIN
        RAISERROR('Chave deve ter exatamente 14 caracteres (formato: UUTTNNNNNNNNNN)', 16, 1);
        RETURN;
    END
    
    -- Tabela de memória com a consulta principal
    DECLARE @Resultado TABLE (
        Chave CHAR(14),
        ItemID INT,
        UnidadeID TINYINT,
        Item VARCHAR(255),
        VL_NF DECIMAL(18,6),
        VL_Creditos DECIMAL(18,6),
        VL_Acresimo DECIMAL(18,6),
        VL_Compra DECIMAL(18,6),
        QT_Compra DECIMAL(18,3),
        QT_Estoque DECIMAL(18,3),
        VL_Estoque DECIMAL(18,6),
        Custo_Anterior DECIMAL(18,10),
        VL_Medio DECIMAL(18,10),
        VL_Sugerido_Anterior MONEY,
        VL_Sugerido_Novo MONEY,
        Status_Custo VARCHAR(10),
        Percentual_Variacao DECIMAL(5,2),
        StatusNota TINYINT
    );
    
    -- Popula tabela de memória
    WITH Calculos AS ( 
    SELECT 
      I.Chave, I.ItemID, I.UnidadeID,
      SUM(I.Quantidade) Quantidade,
      SUM(I.Quantidade * I.VL_Unitario +I.Vl_IPI+I.VL_Frete+I.VL_Seguro+I.VL_Outro
          + IIF(I.Vl_ICMSSUB>0, I.Vl_ICMSSUB-I.Vl_ICMS, 0.00)) VL_NF,
      SUM(IIF(I.CST_ICMS IN (0,20,51,90,101,900) 
         AND RIGHT(CAST(I.CFOP AS VARCHAR), 3) NOT IN (
             '111','116','117','118','119','151','152','153','154','155','156','159',
             '401','403','406','407','408','409','410','411','414','415',
             '556','557','901','902','903','904','905','906','907','908','909','910','911','949'
         ), I.Vl_ICMS, 0.00)
          +IIF(FU.RegimeID=3, I.Vl_PIS + I.Vl_COFINS, 0.00)
          +IIF(POWER(2,0)&FU.Atividade <> 0 , I.Vl_IPI, 0.00)
          ) VL_Creditos,
        SUM(I.VL_Anexo+I.VL_Operacional) VL_Acresimo,
        ISNULL(E.Contabil*P.Valor,0.000) VL_Estoque,
        ISNULL(E.Contabil,0.000) QT_Estoque,
        IIF(M.StatusID = 2 AND I.VL_CustoMedio > 0,
            I.VL_CustoMedio / NULLIF(I.QT_Estoque, 0),
            ISNULL(P.Valor,0.0000000000)) Custo_Anterior,
        ISNULL(IU.VL_Sugerido, 0.00) VL_Sugerido_Anterior,
        M.StatusID
    FROM dbo.MovNota0 M
    JOIN dbo.COM_ITE_MOV I ON I.Chave = M.Chave
    JOIN dbo.COM_ITE_UND IU ON IU.UnidadeID = I.UnidadeID AND IU.ItemID = I.ItemID
    JOIN dbo.FIS_Unidade FU ON FU.UnidadeID = M.UnidadeID
    LEFT JOIN dbo.COM_ITE_PRC P ON P.UnidadeID = IU.UnidadeID AND P.ItemID = IU.ItemID AND P.PrecoID=1
    LEFT JOIN dbo.fns_Estoque(ISNULL(@Data, GETDATE()), NULL) E ON E.UnidadeID = I.UnidadeID AND E.ItemID = I.ItemID 
    WHERE I.Chave = @Chave
      AND I.TipoID = 1
      AND IU.DestinoID < 7
    GROUP BY 
      I.Chave, I.ItemID, I.UnidadeID, E.Contabil, P.Valor, M.StatusID, I.VL_CustoMedio, I.QT_Estoque, IU.VL_Sugerido
    ), CustoCalculado AS (
    SELECT 
      C.*,
      IIF(C.QT_Estoque = 0,
          (C.VL_NF-C.VL_Creditos+C.VL_Acresimo) / C.Quantidade,
          IIF(ABS(((C.VL_NF-C.VL_Creditos+C.VL_Acresimo + C.VL_Estoque) / (C.QT_Estoque + C.Quantidade)) - 
                  C.Custo_Anterior) > 0.01,
              (C.VL_NF-C.VL_Creditos+C.VL_Acresimo + C.VL_Estoque) / (C.QT_Estoque + C.Quantidade),
              C.Custo_Anterior)) AS VL_Medio
    FROM Calculos C
    ), PrecoSugerido AS (
    SELECT 
      CC.*,
      -- Usando a lógica original da SP_LiberaEstoque
      CONVERT(MONEY, CC.VL_Medio / (
        (100 - FU.PIS - FU.COFINS - FU.CSLL - FU.IRPJ 
         - IIF(FU.RegimeID = 0 AND CC.VL_Medio > 0, FU.ICMS, 0) 
         - U.Comercial - IU.Lucro) / 100)) AS VL_Sugerido_Novo
    FROM CustoCalculado CC
    JOIN dbo.FIS_Unidade FU ON FU.UnidadeID = CC.UnidadeID  
    JOIN dbo.CadUnid0 U ON U.UnidadeID = CC.UnidadeID
    JOIN dbo.COM_ITE_UND IU ON IU.UnidadeID = CC.UnidadeID AND IU.ItemID = CC.ItemID
    )
    INSERT INTO @Resultado
    SELECT 
      PS.Chave, PS.ItemID, PS.UnidadeID, I.Item, PS.VL_NF, PS.VL_Creditos, PS.VL_Acresimo,
      PS.VL_NF-PS.VL_Creditos+PS.VL_Acresimo, PS.Quantidade, PS.QT_Estoque, PS.VL_Estoque,
      PS.Custo_Anterior, PS.VL_Medio, PS.VL_Sugerido_Anterior, PS.VL_Sugerido_Novo,
      IIF(PS.QT_Estoque = 0, 'NOVO',
          IIF(ABS(PS.VL_Medio - PS.Custo_Anterior) > 0.01, 'ALTERADO', 'MANTIDO')),
      IIF(PS.Custo_Anterior > 0, 
          ROUND(((PS.VL_Medio - PS.Custo_Anterior) / PS.Custo_Anterior) * 100, 2), 0.00),
      PS.StatusID
    FROM PrecoSugerido PS
      JOIN dbo.COM_ITE_CAD I ON I.ItemID = PS.ItemID;
    
    -- Validação após popular tabela de memória
    IF NOT EXISTS(SELECT 1 FROM @Resultado)
    BEGIN
        RAISERROR('Chave não encontrada ou não possui itens válidos para liberação', 16, 1);
        RETURN;
    END
    
    -- Se @Data informada E nota está conferida, executa liberação
    IF @Data IS NOT NULL AND EXISTS(SELECT 1 FROM @Resultado WHERE StatusNota = 1)
    BEGIN
        BEGIN TRANSACTION;
        
        BEGIN TRY
            -- Atualiza COM_ITE_MOV com valores históricos
            UPDATE COM_ITE_MOV 
            SET VL_CustoMedio = R.VL_Estoque, QT_Estoque = R.QT_Estoque
            FROM COM_ITE_MOV I
            JOIN @Resultado R ON R.Chave = I.Chave AND R.ItemID = I.ItemID
            WHERE I.TipoID = 1;
            
            -- Atualiza VL_Sugerido em COM_ITE_UND
            UPDATE COM_ITE_UND
            SET VL_Sugerido = R.VL_Sugerido_Novo
            FROM COM_ITE_UND IU
            JOIN @Resultado R ON R.UnidadeID = IU.UnidadeID AND R.ItemID = IU.ItemID;
            
            -- Deleta preços básicos (0,1,2) e preços zerados para recriar
            DELETE P FROM COM_ITE_PRC P
            JOIN @Resultado R ON R.UnidadeID = P.UnidadeID AND R.ItemID = P.ItemID
            WHERE P.PrecoID IN (0, 1, 2) OR P.Valor = 0;
            
            -- Insere preços básicos (0,1,2)
            WITH PrecosBasicos AS (
                SELECT DISTINCT R.UnidadeID, R.ItemID,
                    I.VL_Unitario AS P0, R.VL_Medio AS P1,
                    R.VL_Medio + (SUM(I.VL_Operacional) OVER (PARTITION BY I.Chave, I.ItemID) / R.QT_Compra) AS P2
                FROM @Resultado R
                JOIN COM_ITE_MOV I ON I.Chave = R.Chave AND I.ItemID = R.ItemID
                WHERE I.TipoID = 1
            )
            INSERT INTO COM_ITE_PRC (UnidadeID, ItemID, PrecoID, Valor)
            SELECT UnidadeID, ItemID, 0, P0 FROM PrecosBasicos UNION ALL
            SELECT UnidadeID, ItemID, 1, P1 FROM PrecosBasicos UNION ALL
            SELECT UnidadeID, ItemID, 2, P2 FROM PrecosBasicos;
            
            -- Insere TODOS os preços automáticos (incluindo os que foram deletados por estarem zerados)
            INSERT INTO COM_ITE_PRC (UnidadeID, ItemID, PrecoID, Valor)
            SELECT R.UnidadeID, R.ItemID, PC.PrecoID, R.VL_Sugerido_Novo
            FROM @Resultado R
            CROSS JOIN COM_PRC_CAD PC
            WHERE PC.AutoReajuste = 1 AND PC.PrecoID >= 3
              AND NOT EXISTS(SELECT 1 FROM COM_ITE_PRC P2 
                            WHERE P2.UnidadeID = R.UnidadeID 
                              AND P2.ItemID = R.ItemID 
                              AND P2.PrecoID = PC.PrecoID);
            
            -- Atualiza status da nota
            UPDATE MovNota0 SET StatusID = 2 WHERE Chave = @Chave;
            
            COMMIT TRANSACTION;
            
        END TRY
        BEGIN CATCH
            ROLLBACK TRANSACTION;
            DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
            RAISERROR(@ErrorMessage, 16, 1);
            RETURN;
        END CATCH
    END
    
    -- Retorna consulta
    SELECT Chave, ItemID, Item, VL_NF, VL_Creditos, VL_Acresimo, VL_Compra,
           QT_Compra, QT_Estoque, VL_Estoque, Custo_Anterior, VL_Medio,
           VL_Sugerido_Anterior, VL_Sugerido_Novo, Status_Custo, Percentual_Variacao
    FROM @Resultado ORDER BY ItemID;
    
END
GO
