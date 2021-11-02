import Foundation
import Then

public extension DateFormatter {
  static let iso8601 = DateFormatter().then {
    $0.locale = Locale(identifier: "en_US_POSIX")
    $0.timeZone = TimeZone(secondsFromGMT: 0)
    $0.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
  }
}
