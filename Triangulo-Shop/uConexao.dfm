object dtmConexao: TdtmConexao
  Height = 249
  Width = 466
  PixelsPerInch = 120
  object FDConnection1: TFDConnection
    Params.Strings = (
      'Database=triangulos'
      'Password=#abc123#'
      'Server=localhost'
      'User_Name=postgres'
      'DriverID=PG')
    Connected = True
    Left = 136
    Top = 64
  end
  object FDPhysPgDriverLink1: TFDPhysPgDriverLink
    VendorLib = 'C:\Program Files (x86)\PostgreSQL\psqlODBC\bin\libpq.dll'
    Left = 272
    Top = 64
  end
  object FDQuery1: TFDQuery
    Connection = FDConnection1
    Left = 192
    Top = 144
  end
end
