SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO





CREATE      procedure [dbo].[SP_CustomReport]
  @T Char(1) = Null
AS
if @T = 'T'  
  Select TabelaID, Tabela, Apelido
  from RptTabe0 Where Selecionavel = 1
else if @T = 'C'
  Select RptTabe0.Tabela, RptCamp0.Campo, RptCamp0.Apelido, RptCamp0.DataType,
    Case Visivel     when 1 then 'T' else 'F' end Visivel,
    Case Filtro      when 1 then 'T' else 'F' end Filtro ,
    Case AltoFiltro  when 1 then 'T' else 'F' end AltoFiltro,
    Case Obrigatorio when 1 then 'T' else 'F' end Obrigatorio,
    Case Ordenavel   when 1 then 'T' else 'F' end Ordenavel, OBS
  from RptCamp0
    Inner JOIN RptTabe0
      ON RptTabe0.TabelaID = RptCamp0.TabelaID
  Where RptTabe0.Selecionavel = 1
else 
SELECT o.Name, FK.Name FK_Table, PK.Name PK_Table,
  Convert(VarChar(100), 
  FC1.Name 
  + IsNull(';'+FC2.Name, '')
  + IsNull(';'+FC3.Name, '')
  + IsNull(';'+FC4.Name, '')
  + IsNull(';'+FC5.Name, '')
  + IsNull(';'+FC6.Name, '')
  + IsNull(';'+FC7.Name, '')
  + IsNull(';'+FC8.Name, '')
  + IsNull(';'+FC9.Name, '')
  + IsNull(';'+FC10.Name, ''))
  FK_Campo,
  '='
  + Case when FC2.Name Is Not Null  then ';=' else  '' end
  + Case when FC3.Name Is Not Null  then ';=' else  '' end
  + Case when FC4.Name Is Not Null  then ';=' else  '' end
  + Case when FC5.Name Is Not Null  then ';=' else  '' end
  + Case when FC6.Name Is Not Null  then ':=' else  '' end
  + Case when FC7.Name Is Not Null  then ';=' else  '' end
  + Case when FC8.Name Is Not Null  then ';=' else  '' end
  + Case when FC9.Name Is Not Null  then ';=' else  '' end
  + Case when FC10.Name Is Not Null then ';=' else  '' end
  Operador,
  'jtInner'JoinType,
  Convert(VarChar(100), 
  FC1.Name 
  + IsNull(';'+RC2.Name,'' )
  + IsNull(';'+RC3.Name,'' )
  + IsNull(';'+RC4.Name, '')
  + IsNull(';'+RC5.Name, '')
  + IsNull(';'+RC6.Name, '')
  + IsNull(';'+RC7.Name, '')
  + IsNull(';'+RC8.Name, '')
  + IsNull(';'+RC9.Name, '')
  + IsNull(';'+RC10.Name, ''))
 PK_Campo
FROM sysreferences r
  inner join sysobjects O
     on r.Constid = o.id
  inner join sysobjects FK
     on r.FKeyid = FK.id
  inner join sysobjects PK
     on r.RKeyid = PK.id

  inner join syscolumns FC1
     on r.FKeyid = FC1.id
    AND r.FKey1  = FC1.ColID
  Left Outer join syscolumns FC2
     on r.FKeyid = FC2.id
    AND r.FKey2  = FC2.ColID
  Left Outer join syscolumns FC3
     on r.FKeyid = FC3.id
    AND r.FKey3  = FC3.ColID
  Left Outer join syscolumns FC4
     on r.FKeyid = FC4.id
    AND r.FKey4  = FC4.ColID
  Left Outer join syscolumns FC5
     on r.FKeyid = FC5.id
    AND r.FKey5  = FC5.ColID
  Left Outer join syscolumns FC6
     on r.FKeyid = FC6.id
    AND r.FKey6  = FC6.ColID
  Left Outer join syscolumns FC7
     on r.FKeyid = FC7.id
    AND r.FKey7  = FC7.ColID
  Left Outer join syscolumns FC8
     on r.FKeyid = FC8.id
    AND r.FKey8  = FC8.ColID
  Left Outer join syscolumns FC9
     on r.FKeyid = FC9.id
    AND r.FKey9  = FC9.ColID
  Left Outer join syscolumns FC10
     on r.FKeyid = FC10.id
    AND r.FKey10  = FC10.ColID


  inner join syscolumns RC1
     on r.RKeyid = RC1.id
    AND r.RKey1  = RC1.ColID
  Left Outer join syscolumns RC2
     on r.RKeyid = RC2.id
    AND r.RKey2  = RC2.ColID
  Left Outer join syscolumns RC3
     on r.RKeyid = RC3.id
    AND r.RKey3  = RC3.ColID
  Left Outer join syscolumns RC4
     on r.RKeyid = RC4.id
    AND r.RKey4  = RC4.ColID
  Left Outer join syscolumns RC5
     on r.RKeyid = RC5.id
    AND r.RKey5  = RC5.ColID
  Left Outer join syscolumns RC6
     on r.RKeyid = RC6.id
    AND r.RKey6  = RC6.ColID
  Left Outer join syscolumns RC7
     on r.RKeyid = RC7.id
    AND r.RKey7  = RC7.ColID
  Left Outer join syscolumns RC8
     on r.RKeyid = RC8.id
    AND r.RKey8  = RC8.ColID
  Left Outer join syscolumns RC9
     on r.RKeyid = RC9.id
    AND r.RKey9  = RC9.ColID
  Left Outer join syscolumns RC10
     on r.RKeyid = RC10.id
    AND r.RKey10  = RC10.ColID




GO
