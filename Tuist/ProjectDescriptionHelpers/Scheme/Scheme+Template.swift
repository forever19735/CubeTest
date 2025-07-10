import ProjectDescription

public extension Scheme {
    static func makeDevScheme() -> Scheme {
        return Scheme.scheme(
            name: "Cube-Dev",
            shared: true,
            buildAction: .buildAction(targets: ["CubeTest"]),
            testAction: .targets(
                ["CubeTestTests"],
                configuration: .debug
            ),
            runAction: .runAction(
                configuration: .debug,
                executable: "CubeTest",
                arguments: .arguments(
                    environmentVariables: [
                        "IDEPreferLogStreaming": "YES",
                    ],
                    launchArguments: [
//                        .launchArgument(name: "-FIRAnalyticsDebugEnabled", isEnabled: true),
                    ]
                )
            ),
            archiveAction: .archiveAction(configuration: .debug),
            profileAction: .profileAction(configuration: .debug),
            analyzeAction: .analyzeAction(configuration: .debug)
        )
    }

    static func makeReleaseScheme() -> Scheme {
        return Scheme.scheme(
            name: "Cube-Release",
            shared: true,
            buildAction: .buildAction(targets: ["CubeTest"]),
            testAction: .targets(
                ["CubeTestTests"],
                configuration: .debug
            ),
            runAction: .runAction(
                configuration: .release,
                executable: "CubeTest",
                arguments: .arguments(
                    environmentVariables: [
                        "IDEPreferLogStreaming": "YES",
                    ],
                    launchArguments: [
//                        .launchArgument(name: "-FIRAnalyticsDebugEnabled", isEnabled: true),
                    ]
                )
            ),
            archiveAction: .archiveAction(configuration: .release),
            profileAction: .profileAction(configuration: .release),
            analyzeAction: .analyzeAction(configuration: .release)
        )
    }
}
