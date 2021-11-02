import Foundation

public extension UserDefaults {
  func date(forKey key: String) -> Date? {
    guard let value = string(forKey: key) else { return nil }
    let dateFormatter = DateFormatter.iso8601
    return dateFormatter.date(from: value)
  }
  
  func set(_ value: Date, forKey key: String) {
    let dateFormatter = DateFormatter.iso8601
    set(dateFormatter.string(from: value), forKey: key)
  }
}
