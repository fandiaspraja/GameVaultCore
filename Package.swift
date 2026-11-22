// swift-tools-version: 5.9
import PackageDescription

let package = Package(
  name: "GameVaultCore",
  platforms: [
    .iOS(.v16),
    .macOS(.v13)
  ],
  products: [
    .library(name: "GameVaultCore", targets: ["GameVaultCore"])
  ],
  targets: [
    .target(name: "GameVaultCore"),
    .testTarget(name: "GameVaultCoreTests", dependencies: ["GameVaultCore"])
  ]
)
