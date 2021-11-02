import Foundation

private extension BinaryInteger {
  func digits(_ value: Self) -> [Self] {
    let divider: Self = 10
    var value = value
    var result = [value % divider]
    while value >= divider {
      value = value / divider
      result.append(value % divider)
    }
    return result.reversed()
  }
}

public extension SignedInteger {
  var digits: [Self] {
    digits(abs(self))
  }
}

public extension UnsignedInteger {
  var digits: [Self] {
    digits(self)
  }
}
