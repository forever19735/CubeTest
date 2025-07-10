import ProjectDescription
import ProjectDescriptionHelpers

public extension Target {
    public static func makeAppTargets(name: String) -> [Target] {
        let appTarget = Target.target(
            name: name,
            destinations: [.iPhone],
            product: .app,
            bundleId: "$(PRODUCT_BUNDLE_IDENTIFIER)",
            infoPlist: .file(path: "Sources/CubeTest/Info.plist"),
            sources: [
                "Sources/CubeTest/**/*.swift"
            ],
            resources: [
                "Resources/**"
            ],
            scripts: Project.exampleScripts(),
            dependencies: [
//                .project(target: "Core", path: "../Core"),
//                .project(target: "Shared", path: "../Shared"),
            ] + Project.exampleDependencies(),
            settings: Project.targetSettings()
        )

        let testTarget = Target.target(
            name: "CubeTestTests",
            destinations: [.iPhone],
            product: .unitTests,
            bundleId: "com.johnlin.CubeTestTests",
            deploymentTargets: .iOS("16.0"),
            infoPlist: .default,
            sources: ["Tests/CubeTestTests/**"],
            dependencies: [.target(name: name)]
        )
        return [
            appTarget,
            testTarget,
        ]
    }
}
