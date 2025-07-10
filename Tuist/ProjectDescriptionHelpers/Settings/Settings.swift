import ProjectDescription

public extension Project {
    static func projectSettings() -> Settings {
        return Settings.settings(
            configurations: [
                .debug(
                    name: "Debug",
                    xcconfig: .relativeToRoot("xcconfigs/com.johnlin.CubeTest.dev.xcconfig")
                ),
                .release(
                    name: "Release",
                    xcconfig: .relativeToRoot("xcconfigs/com.johnlin.CubeTest.release.xcconfig")
                ),
            ]
        )
    }

    static func targetSettings() -> Settings {
        return .settings(
            base: [
                "CLANG_ENABLE_OBJC_ARC": "YES",
                "ASSETCATALOG_COMPILER_APPICON_NAME": "$(IS_APP_ICON)",
            ],
            configurations: [
                .debug(name: "Debug", xcconfig: "Config/DebugConfig.xcconfig"),
                .release(name: "Release", xcconfig: "Config/ReleaseConfig.xcconfig"),
            ]
        )
    }

    static func moduleBaseSettings() -> Settings {
        .settings(
            base: [
                "CLANG_ENABLE_OBJC_ARC": "YES",
                "SWIFT_OPTIMIZATION_LEVEL": "-Onone",
            ],
            configurations: [
                .debug(name: "Debug"),
                .release(name: "Release"),
            ]
        )
    }
}
