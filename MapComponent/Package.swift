// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "MapComponent",
    platforms: [
        .iOS(.v14)
    ],
    products: [
        .library(
            name: "MapComponent",
            targets: ["MapComponent"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/Alamofire/Alamofire.git", from: "5.4.0"),
    ],
    targets: [
        .target(
            name: "MapComponent",
            dependencies: ["Alamofire"]
        ),
        .testTarget(
            name: "MapComponentTests",
            dependencies: ["MapComponent"]
        ),
    ]
)
