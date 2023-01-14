import Foundation

@propertyWrapper public struct Localizable {
    // MARK: - Properties
    
    private let key: String
    private let table: String?
    private let bundle: Bundle
    
    public var wrappedValue: String {
        NSLocalizedString(key, tableName: table, bundle: bundle, comment: "")
    }
    
    public var projectedValue: Self {
        self
    }
    
    // MARK: - Inits
    
    public init(_ key: String, _ table: String? = nil, _ bundle: Bundle = .main) {
        self.key = key
        self.table = table
        self.bundle = bundle
    }
    
    public init(_ key: String, _ table: LocalizedTable.Type, _ bundle: Bundle = .main) {
        self.init(key, table.tableName, bundle)
    }
    
    // MARK: - Methods
    
    public func localizedStringWith(_ arguments: CVarArg...) -> String {
        String.localizedStringWithFormat(wrappedValue, arguments)
    }
}
