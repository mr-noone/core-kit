import Foundation

public extension Date {
  var day: Int {
    Calendar.current.component(.day, from: self)
  }
  
  var month: Int {
    Calendar.current.component(.month, from: self)
  }
  
  var year: Int {
    Calendar.current.component(.year, from: self)
  }
}

extension Date: LosslessStringConvertible {
  var description: String {
    let formatter = DateFormatter.iso8601
    return formatter.string(from: self)
  }
  
  public init?(_ description: String) {
    let formatter = DateFormatter.iso8601
    let date = formatter.date(from: description)
    
    if let date = date {
      self = date
    } else {
      return nil
    }
  }
}
