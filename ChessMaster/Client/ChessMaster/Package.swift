import PackageDescription

let package = package(
    name: "PythonKit",
    dependencies: [
        .package(url: "https://github.com/pvieito/PythonKit.git", from "0.0.1")
    ],
    targets: [
        .target(
            name: "PythonKit",
            dependencies: ["PythonKit"]
        ),
        .testTarget(
            name: "PythonKitTests",
            dependencies: ["PythonKit"]
        ),
    ]
)