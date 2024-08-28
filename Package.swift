// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "VoidCasePathBug",
  platforms: [
    .macOS(.v10_15),
    .iOS(.v13)
  ],
  products: [
    .library(
      name: "VoidCasePathBug",
      targets: ["VoidCasePathBug"]
    ),
  ],
  dependencies: [
    // CasePaths
    .package(url: "https://github.com/pointfreeco/swift-case-paths.git", from: "1.0.0")
  ],
  targets: [
    .target(
      name: "VoidCasePathBug",
      dependencies: [
        .product(name: "CasePaths", package: "swift-case-paths")
      ]
    ),
  ]
)
