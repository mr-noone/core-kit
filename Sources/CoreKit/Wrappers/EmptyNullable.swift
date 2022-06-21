import Foundation

@propertyWrapper
public struct EmptyNullable<V: Collection> {
  // MARK: - Properties
  
  private var value: V?
  public var wrappedValue: V? {
    get { value?.isEmpty ?? true ? nil : value }
    set { value = newValue }
  }
  
  // MARK: - Inits
  
  public init(wrappedValue value: V?) {
    self.wrappedValue = value
  }
}

// MARK: - Codable

extension EmptyNullable: Codable where V: Codable {}

// MARK: - Equatable

extension EmptyNullable: Equatable where V: Equatable {}
