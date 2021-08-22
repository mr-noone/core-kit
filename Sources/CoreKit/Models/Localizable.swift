import Foundation

public protocol LocalizedTable {
  static var tableName: String { get }
}

public extension LocalizedTable {
  static var tableName: String {
    return String(describing: Self.self)
  }
}

public enum LS {
  @propertyWrapper public struct Localizable {
    private let key: String
    private let table: String?
    private let bundle: Bundle
    
    public var wrappedValue: String {
      NSLocalizedString(key, tableName: table, bundle: bundle, comment: "")
    }
    
    public init(_ key: String, _ table: String? = nil, _ bundle: Bundle = .main) {
      self.key = key
      self.table = table
      self.bundle = bundle
    }
    
    public init(_ key: String, _ table: LocalizedTable.Type, _ bundle: Bundle = .main) {
      self.key = key
      self.table = table.tableName
      self.bundle = bundle
    }
  }
  
  public enum Common: LocalizedTable {
    @Localizable("LS.Common.warningTitle", Self.self, .module)    public static var warningTitle
    @Localizable("LS.Common.errorTitle", Self.self, .module)      public static var errorTitle
    @Localizable("LS.Common.unexpectedError", Self.self, .module) public static var unexpectedError
    
    @Localizable("LS.Common.ok", Self.self, .module)              public static var ok
    @Localizable("LS.Common.cancel", Self.self, .module)          public static var cancel
    @Localizable("LS.Common.done", Self.self, .module)            public static var done
  }
}
