import ProjectDescription

public extension Scheme {
    static func makeScheme(
        name: String,
        targetName: String,
        testTargetName: String,
        executable: String,
        configuration: ConfigurationName
    ) -> Scheme {
        return Scheme.scheme(
            name: name,
            shared: true,
            buildAction: .buildAction(
                targets: [TargetReference(stringLiteral: targetName)]
            ),
            testAction: .targets(
                [TestableTarget(stringLiteral: testTargetName)],
                configuration: configuration
            ),
            runAction: .runAction(
                configuration: configuration,
                executable: TargetReference(stringLiteral: executable),
                arguments: commonArguments()
            ),
            archiveAction: .archiveAction(configuration: configuration),
            profileAction: .profileAction(configuration: configuration),
            analyzeAction: .analyzeAction(configuration: configuration)
        )
    }

    static func makeDevScheme() -> Scheme {
        return makeScheme(
            name: "Cube-Dev",
            targetName: "CubeTest",
            testTargetName: "CubeTestTests",
            executable: "CubeTest",
            configuration: .debug
        )
    }

    static func makeReleaseScheme() -> Scheme {
        return makeScheme(
            name: "Cube-Release",
            targetName: "CubeTestr",
            testTargetName: "CubeTestTests",
            executable: "CubeTest",
            configuration: .release
        )
    }

    private static func commonArguments() -> Arguments {
        return Arguments.arguments(
            environmentVariables: [
                "IDEPreferLogStreaming": "YES",
            ],
            launchArguments: [
//                .launchArgument(name: "-FIRAnalyticsDebugEnabled", isEnabled: true),
            ]
        )
    }
}
