// swift-tools-version:4.0
import PackageDescription

let package = Package(
    name: "SnapshotServerDemo",
    products: [
        .library(name: "SnapshotServerDemo", targets: ["App"]),
    ],
    dependencies: [
        // 💧 A server-side Swift web framework
        .package(url: "https://github.com/vapor/vapor.git", from: "3.3.0"),
        
        // 🖋🐘 Swift ORM (queries, models, relations, etc) built on PostgreSQL
        .package(url: "https://github.com/vapor/fluent-postgresql", from: "1.0.0"),
        
        // 🍃 An expressive, performant, and extensible templating language built for Swift
        .package(url: "https://github.com/vapor/leaf.git", from: "3.0.2")
    ],
    targets: [
        .target(name: "App", dependencies: ["Vapor", "FluentPostgreSQL", "Leaf"]),
        .target(name: "Run", dependencies: ["App"]),
        .testTarget(name: "AppTests", dependencies: ["App"])
    ]
)

