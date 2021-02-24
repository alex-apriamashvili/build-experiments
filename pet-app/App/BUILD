load("@build_bazel_rules_apple//apple:ios.bzl", "ios_application")
load("@build_bazel_rules_swift//swift:swift.bzl", "swift_library")

ios_application(
    name = "App",
    bundle_id = "com.uber.UberMockApp",
    families = ["iphone", "ipad"],
    infoplists = ["Info.plist"],
    deps = [":AppBinary"],
    minimum_os_version = "13.0"
)

swift_library(
    name = "AppBinary",
    srcs = glob([ "*.swift" ]),
    deps = [
        '//MockLib0:MockLib0',
        '//MockLib1:MockLib1',
        '//MockLib2:MockLib2'
    ],
)
