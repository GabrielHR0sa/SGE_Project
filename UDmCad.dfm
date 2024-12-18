object DmCad: TDmCad
  Height = 600
  Width = 800
  object TbPro: TFDQuery
    CachedUpdates = True
    Connection = Main.BancoDados
    SQL.Strings = (
      'Select * From TbProduto Where 1 = 2')
    Left = 32
    Top = 6
    object TbProID: TIntegerField
      FieldName = 'ID'
      Origin = 'ID'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object TbProDESCRICAO: TStringField
      FieldName = 'DESCRICAO'
      Origin = 'DESCRICAO'
      Size = 30
    end
    object TbProQUANTIDADE: TSingleField
      FieldName = 'QUANTIDADE'
      Origin = 'QUANTIDADE'
    end
    object TbProPESO: TFMTBCDField
      FieldName = 'PESO'
      Origin = 'PESO'
      Precision = 18
      Size = 2
    end
    object TbProCODBARRAS: TStringField
      FieldName = 'CODBARRAS'
      Origin = 'CODBARRAS'
      Size = 13
    end
    object TbProPRECUSTO: TFMTBCDField
      FieldName = 'PRECUSTO'
      Origin = 'PRECUSTO'
      Precision = 18
      Size = 2
    end
    object TbProPREVENDA: TFMTBCDField
      FieldName = 'PREVENDA'
      Origin = 'PREVENDA'
      Precision = 18
      Size = 2
    end
  end
  object DsPro: TDataSource
    DataSet = TbPro
    Left = 32
    Top = 64
  end
  object TbVarPro: TFDQuery
    BeforePost = TbVarProBeforePost
    CachedUpdates = True
    MasterSource = DsPro
    MasterFields = 'ID'
    Connection = Main.BancoDados
    SQL.Strings = (
      'Select * From TbVarProduto'
      ' Where IDPro = :ID ')
    Left = 88
    Top = 6
    ParamData = <
      item
        Name = 'ID'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end>
    object TbVarProIDPRO: TIntegerField
      FieldName = 'IDPRO'
      Origin = 'IDPRO'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object TbVarProNUMLAN: TIntegerField
      FieldName = 'NUMLAN'
      Origin = 'NUMLAN'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object TbVarProVARDES: TStringField
      FieldName = 'VARDES'
      Origin = 'VARDES'
      Size = 60
    end
    object TbVarProVARQTD: TFMTBCDField
      FieldName = 'VARQTD'
      Origin = 'VARQTD'
      Precision = 18
      Size = 2
    end
    object TbVarProSKU: TStringField
      FieldName = 'SKU'
      Origin = 'SKU'
    end
    object TbVarProEAN: TStringField
      FieldName = 'EAN'
      Origin = 'EAN'
    end
  end
  object DsVarPro: TDataSource
    DataSet = TbVarPro
    Left = 88
    Top = 64
  end
  object TbProducao: TFDQuery
    OnCalcFields = TbProducaoCalcFields
    CachedUpdates = True
    Connection = Main.BancoDados
    SQL.Strings = (
      'Select * From TbProducao'
      '  Where 1 = 1'
      '  Order By NumLote'
      '  '
      '')
    Left = 256
    Top = 8
    object TbProducaoNUMLOTE: TIntegerField
      FieldName = 'NUMLOTE'
      Origin = 'NUMLOTE'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object TbProducaoDESCRICAO: TStringField
      FieldName = 'DESCRICAO'
      Origin = 'DESCRICAO'
      Size = 100
    end
    object TbProducaoDATALOTE: TDateField
      FieldName = 'DATALOTE'
      Origin = 'DATALOTE'
    end
    object TbProducaoSTATUS: TStringField
      FieldName = 'STATUS'
      Origin = 'STATUS'
      Size = 2
    end
    object TbProducaoDesStatus: TStringField
      FieldKind = fkCalculated
      FieldName = 'DesStatus'
      Size = 50
      Calculated = True
    end
  end
  object DsProducao: TDataSource
    DataSet = TbProducao
    Left = 256
    Top = 64
  end
  object TbItemProducao: TFDQuery
    OnCalcFields = TbItemProducaoCalcFields
    CachedUpdates = True
    MasterSource = DsProducao
    MasterFields = 'NUMLOTE'
    Connection = Main.BancoDados
    SQL.Strings = (
      'Select * From TbItemProducao'
      ' Where 1 = 1'
      ' And NumLote = :NumLote'
      ' Order By NumLote')
    Left = 352
    Top = 8
    ParamData = <
      item
        Name = 'NUMLOTE'
        DataType = ftInteger
        ParamType = ptInput
      end>
    object TbItemProducaoNUMLOTE: TIntegerField
      FieldName = 'NUMLOTE'
      Origin = 'NUMLOTE'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object TbItemProducaoSEQLAN: TIntegerField
      FieldName = 'SEQLAN'
      Origin = 'SEQLAN'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object TbItemProducaoCODPRO: TIntegerField
      FieldName = 'CODPRO'
      Origin = 'CODPRO'
    end
    object TbItemProducaoCODVARIACAO: TIntegerField
      FieldName = 'CODVARIACAO'
      Origin = 'CODVARIACAO'
    end
    object TbItemProducaoQUANTIDADE: TFMTBCDField
      FieldName = 'QUANTIDADE'
      Origin = 'QUANTIDADE'
      Precision = 18
      Size = 2
    end
    object TbItemProducaoDesPro: TStringField
      FieldKind = fkCalculated
      FieldName = 'DesPro'
      Size = 50
      Calculated = True
    end
    object TbItemProducaoDesVar: TStringField
      FieldKind = fkCalculated
      FieldName = 'DesVar'
      Size = 50
      Calculated = True
    end
  end
  object DsItemProducao: TDataSource
    DataSet = TbItemProducao
    Left = 352
    Top = 64
  end
  object TbAux: TFDQuery
    Connection = Main.BancoDados
    Left = 723
    Top = 462
  end
  object TbAux2: TFDQuery
    Connection = Main.BancoDados
    Left = 723
    Top = 520
  end
  object TbVenda: TFDQuery
    CachedUpdates = True
    Connection = Main.BancoDados
    SQL.Strings = (
      'Select * From TbVenda'
      ' Order By NumPed')
    Left = 520
    Top = 8
    object TbVendaNUMPED: TIntegerField
      FieldName = 'NUMPED'
      Origin = 'NUMPED'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object TbVendaDATPED: TDateField
      FieldName = 'DATPED'
      Origin = 'DATPED'
    end
    object TbVendaOBSPED: TStringField
      FieldName = 'OBSPED'
      Origin = 'OBSPED'
      Size = 150
    end
    object TbVendaQUANTIDADE: TFMTBCDField
      FieldName = 'QUANTIDADE'
      Origin = 'QUANTIDADE'
      Precision = 18
      Size = 2
    end
    object TbVendaTOTBRU: TFMTBCDField
      FieldName = 'TOTBRU'
      Origin = 'TOTBRU'
      Precision = 18
      Size = 2
    end
  end
  object DsVenda: TDataSource
    DataSet = TbVenda
    Left = 520
    Top = 64
  end
  object DsItemVenda: TDataSource
    DataSet = TbItemVenda
    Left = 608
    Top = 64
  end
  object TbItemVenda: TFDQuery
    BeforePost = TbItemVendaBeforePost
    CachedUpdates = True
    MasterSource = DsVenda
    MasterFields = 'NUMPED'
    Connection = Main.BancoDados
    SQL.Strings = (
      'Select * From TbItemVenda'
      ' Where NumPed = :NumPed'
      ' Order By NumPed')
    Left = 608
    Top = 8
    ParamData = <
      item
        Name = 'NUMPED'
        DataType = ftInteger
        ParamType = ptInput
      end>
    object TbItemVendaNUMPED: TIntegerField
      FieldName = 'NUMPED'
      Origin = 'NUMPED'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object TbItemVendaNUMLAN: TIntegerField
      FieldName = 'NUMLAN'
      Origin = 'NUMLAN'
    end
    object TbItemVendaCODPRO: TIntegerField
      FieldName = 'CODPRO'
      Origin = 'CODPRO'
    end
    object TbItemVendaCODVAR: TIntegerField
      FieldName = 'CODVAR'
      Origin = 'CODVAR'
    end
    object TbItemVendaQUANTIDADE: TFMTBCDField
      FieldName = 'QUANTIDADE'
      Origin = 'QUANTIDADE'
      Precision = 18
      Size = 2
    end
    object TbItemVendaVLRBRU: TFMTBCDField
      FieldName = 'VLRBRU'
      Origin = 'VLRBRU'
      Precision = 18
      Size = 2
    end
    object TbItemVendaDESPRO: TStringField
      FieldName = 'DESPRO'
      Origin = 'DESPRO'
      Size = 100
    end
    object TbItemVendaDESVAR: TStringField
      FieldName = 'DESVAR'
      Origin = 'DESVAR'
      Size = 100
    end
  end
end
