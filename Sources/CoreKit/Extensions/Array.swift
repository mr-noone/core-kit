import Foundation

public extension Array {
  mutating func removeFirst(_ k: Int) -> ArraySlice<Element> {
    let result = self[0..<k]
    removeFirst(k) as Void
    return result
  }
  
  func chunked(into size: Int) -> [[Element]] {
    return stride(from: 0, to: count, by: size).map {
      Array(self[$0 ..< Swift.min($0 + size, count)])
    }
  }
}
