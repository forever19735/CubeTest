import ProjectDescription

public extension Project {
    static func exampleScripts() -> [TargetScript] {
        return [
//            .copyGoogleServiceInfo,
//            .crashlyticsUpload,
        ]
    }

    static func examplelPackages() -> [Package] {
        return [
            .package(url: "https://github.com/pujiaxin33/JXSegmentedView.git", from: "1.4.1"),
            .package(url: "https://github.com/onevcat/Kingfisher.git", from: "8.1.0"),
            .package(url: "https://github.com/jdg/MBProgressHUD.git", from: "1.2.0"),
            .package(url: "https://github.com/CoderMJLee/MJRefresh.git", from: "3.7.9"),
            .package(url: "https://github.com/Moya/Moya.git", from: "15.0.3"),
            .package(url: "https://github.com/SnapKit/SnapKit.git", from: "5.7.1"),
        ]
    }

    static func exampleDependencies() -> [TargetDependency] {
        return [
            .package(product: "JXSegmentedView"),
            .package(product: "Kingfisher"),
            .package(product: "MBProgressHUD"),
            .package(product: "MJRefresh"),
            .package(product: "Moya"),
            .package(product: "SnapKit"),
        ]
    }
}
