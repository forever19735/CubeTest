import ProjectDescription
import ProjectDescriptionHelpers

let schemes: [Scheme] = [.makeDevScheme(), .makeReleaseScheme()]

let packages: [Package] = Project.examplelPackages()

let settings = Project.projectSettings()

let targets: [Target] = Target.makeAppTargets(name: "CubeTest")

let project = Project(
    name: "CubeTest",
    options: .options(
        developmentRegion: "zh-Hant"
    ),
    packages: packages,
    settings: settings,
    targets: targets,
    schemes: schemes
)

