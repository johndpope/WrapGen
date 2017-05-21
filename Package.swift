import PackageDescription

let package = Package(
    name: "WrapGen",
    dependencies: [
      .Package(url: "../ClangSwift", majorVersion: 0),
      .Package(url: "https://github.com/harlanhaskins/CommandLine.git", majorVersion: 3),
      .Package(url: "https://github.com/michael-yuji/CKit.git", Version(0,0,8)),
      .Package(url: "https://github.com/hectr/swift-stream-reader.git", majorVersion:0)
    ]
)
