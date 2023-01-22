import Foundation

public extension String {
    var fileExtension: String {
        (try? substringMatches(regex: "(?<=.\\.)\\w+$"))?.first ?? ""
    }
    
    var filename: String {
        (try? substringMatches(regex: "^.+(?=\\.\\w+$)|^\\.*.+"))?.first ?? ""
    }
    
    func separate(every: Int, with separator: String) -> String {
        return String(stride(from: 0, to: Array(self).count, by: every).map {
            Array(Array(self)[$0..<min($0 + every, Array(self).count)])
        }.joined(separator: separator))
    }
    
    func substringMatches(regex: String) throws -> [String] {
        let regex = try NSRegularExpression(pattern: regex, options: [])
        let range = NSMakeRange(0, (self as NSString).length)
        return regex.matches(in: self, options: [], range: range).map {
            (self as NSString).substring(with: $0.range) as String
        }
    }
}
