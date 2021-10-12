import Foundation

public extension Bundle {
  var name: String? {
    localizedInfoDictionary?["CFBundleDisplayName"] as? String ?? infoDictionary?["CFBundleDisplayName"] as? String
  }
}
