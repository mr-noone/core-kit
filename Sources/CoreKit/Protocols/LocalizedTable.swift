import Foundation

public protocol LocalizedTable {
    static var tableName: String { get }
}

public extension LocalizedTable {
    static var tableName: String {
        return String(describing: Self.self)
    }
}
