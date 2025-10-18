SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE   VIEW [dbo].[VWS_Extrato_Conta]
AS
WITH Movimentos AS (
    -- Apenas movimentos reais
    SELECT 
        B.ContaID,
        CAST(B.DtConciliacao AS DATE) Data,
        YEAR(B.DtConciliacao) * 100 + MONTH(B.DtConciliacao) Competencia,
        B.OperacaoID + 2 RegistroID,
        LK.Operacao Registro,
        LK.Multiplicador,
        B.Valor,
        B.OperacaoID,
        B.MovimentoID
    FROM dbo.MovFina2 B
    JOIN dbo.LkpBaix1 LK ON LK.OperacaoID = B.OperacaoID
    WHERE B.StatusID = 3
),
MovimentosComSaldoTemp AS (
    -- Calcula saldo temporário só para extrair saldos finais
    SELECT 
        M.*,
        SUM(M.Valor * M.Multiplicador) OVER (
            PARTITION BY M.ContaID 
            ORDER BY M.Data, M.RegistroID, M.Multiplicador DESC, ISNULL(M.MovimentoID, 999999999)
            ROWS UNBOUNDED PRECEDING
        ) SaldoTemp
    FROM Movimentos M
),
SaldosFinaisPorMes AS (
    -- Último saldo de cada mês por conta
    SELECT 
        ContaID,
        Competencia,
        MAX(SaldoTemp) SaldoFinal
    FROM MovimentosComSaldoTemp
    GROUP BY ContaID, Competencia
),
SaldosAnteriores AS (
    -- Saldo anterior = saldo final do mês anterior
    SELECT 
        ContaID,
        Competencia,
        COALESCE(
            LAG(SaldoFinal) OVER (PARTITION BY ContaID ORDER BY Competencia),
            0
        ) SaldoAnterior
    FROM SaldosFinaisPorMes
),
PrimeiraDataMes AS (
    -- Primeira data de movimento de cada mês
    SELECT 
        ContaID,
        Competencia,
        MIN(Data) PrimeiraData
    FROM Movimentos
    GROUP BY ContaID, Competencia
),
LinhasSaldoAnterior AS (
    -- Cria linhas de saldo anterior com valor preenchido
    SELECT 
        SA.ContaID,
        PD.PrimeiraData Data,
        SA.Competencia,
        1 RegistroID,
        'Saldo Anterior' Registro,
        1 Multiplicador,
        SA.SaldoAnterior Valor,
        CAST(NULL AS INT) OperacaoID,
        CAST(NULL AS INT) MovimentoID
    FROM SaldosAnteriores SA
    JOIN PrimeiraDataMes PD ON PD.ContaID = SA.ContaID AND PD.Competencia = SA.Competencia
),
SaldoAtual AS (
    -- Linha de saldo atual (data de hoje, valor zero)
    SELECT DISTINCT
        M.ContaID,
        CAST(GETDATE() AS DATE) Data,
        YEAR(GETDATE()) * 100 + MONTH(GETDATE()) Competencia,
        5 RegistroID,
        'Saldo Atual' Registro,
        1 Multiplicador,
        CAST(0.00 AS DECIMAL(18,2)) Valor,
        CAST(NULL AS INT) OperacaoID,
        CAST(NULL AS INT) MovimentoID
    FROM Movimentos M
),
TodosRegistros AS (
    -- União de tudo (sem saldo ainda)
    SELECT 
        ContaID, Data, Competencia, RegistroID, Registro, 
        Multiplicador, Valor, OperacaoID, MovimentoID
    FROM LinhasSaldoAnterior
    
    UNION ALL
    
    SELECT 
        ContaID, Data, Competencia, RegistroID, Registro,
        Multiplicador, Valor, OperacaoID, MovimentoID
    FROM Movimentos
    
    UNION ALL
    
    SELECT 
        ContaID, Data, Competencia, RegistroID, Registro,
        Multiplicador, Valor, OperacaoID, MovimentoID
    FROM SaldoAtual
)
SELECT
    TR.Competencia,
    ROW_NUMBER() OVER (
        PARTITION BY TR.ContaID, TR.Competencia 
        ORDER BY TR.Data, TR.RegistroID, TR.Multiplicador DESC, ISNULL(TR.MovimentoID, 999999999)
    ) ID,
    TR.ContaID,
    TR.Data,
    TR.RegistroID,
    TR.Registro,
    TR.Multiplicador,
    TR.Valor,
    TR.OperacaoID,
    TR.MovimentoID,
    SUM(TR.Valor * TR.Multiplicador) OVER (
        PARTITION BY TR.ContaID 
        ORDER BY TR.Data, TR.RegistroID, TR.Multiplicador DESC, ISNULL(TR.MovimentoID, 999999999)
        ROWS UNBOUNDED PRECEDING
    ) Saldo
FROM TodosRegistros TR;
GO
