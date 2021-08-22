// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "CoreKit",
  defaultLocalization: "en",
  products: [
    .library(name: "CoreKit", targets: ["CoreKit"])
  ],
  dependencies: [],
  targets: [
    .target(name: "CoreKit", dependencies: [])
  ]
)
