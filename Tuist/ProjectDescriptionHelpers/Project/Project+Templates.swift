import ProjectDescription
import ProjectDescriptionHelpers

public extension Project {
    public static func makeModule(
        name: String,
        product: Product,
        bundleId: String,
        deploymentTarget: DeploymentTargets = .iOS("16.0"),
        sources: SourceFilesList = ["Sources/**"],
        resources: ResourceFileElements? = nil,
        packages: [Package] = [],
        dependencies: [TargetDependency] = [],
        hasTests: Bool = false
    ) -> Project {
        let baseSettings = Project.moduleBaseSettings()
        var targets: [Target] = [
            Target.target(
                name: name,
                destinations: [.iPhone],
                product: product,
                bundleId: bundleId,
                deploymentTargets: deploymentTarget,
                infoPlist: .default,
                sources: sources,
                resources: resources,
                dependencies: dependencies,
                settings: baseSettings
            ),
        ]

        if hasTests {
            targets.append(
                Target.target(
                    name: "\(name)Tests",
                    destinations: [.iPhone],
                    product: .unitTests,
                    bundleId: "\(bundleId).Tests",
                    deploymentTargets: deploymentTarget,
                    infoPlist: .default,
                    sources: ["Tests/**"],
                    dependencies: [.target(name: name)],
                    settings: baseSettings
                )
            )
        }
        return Project(
            name: name,
            packages: packages,
            targets: targets
        )
    }
}
