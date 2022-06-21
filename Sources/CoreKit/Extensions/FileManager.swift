import Foundation

public extension FileManager {
  var applicationSupportDirectory: URL {
    return try! url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
  }
  
  func fileExists(at url: URL) -> Bool {
    return fileExists(atPath: url.path)
  }
  
  func createDirectory(at url: URL) throws {
    try createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
  }
}
