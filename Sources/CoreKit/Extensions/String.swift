import Foundation

public extension String {
  func separate(every: Int, with separator: String) -> String {
    return String(stride(from: 0, to: Array(self).count, by: every).map {
      Array(Array(self)[$0..<min($0 + every, Array(self).count)])
    }.joined(separator: separator))
  }
  
  func substringMatches(regex: String) throws -> [String] {
    let regex = try NSRegularExpression(pattern: regex, options: [])
    let range = NSMakeRange(0, (self as NSString).length)
    let matches = regex.matches(in: self, options: [], range: range)
    
    let string = self as NSString
    var substrings = [String]()
    for match in matches {
      substrings.append(string.substring(with: match.range) as String)
    }
    
    return substrings
  }
}
