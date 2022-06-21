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
