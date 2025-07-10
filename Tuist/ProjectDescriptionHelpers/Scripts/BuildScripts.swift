import ProjectDescription

public extension TargetScript {
    static let copyGoogleServiceInfo = TargetScript.pre(
        script: """
        case "${CONFIGURATION}" in
        "Debug")
        PLIST_SRC="${SRCROOT}/Resources/Firebase/GoogleService-Debug-Info.plist"
        ;;
        "Release")
        PLIST_SRC="${SRCROOT}/Resources/Firebase/GoogleService-Release-Info.plist"
        ;;
        *)
        echo "Unsupported configuration: ${CONFIGURATION}"
        exit 1
        ;;
        esac

        PLIST_DST="${TARGET_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/GoogleService-Info.plist"

        if [ -f "$PLIST_SRC" ]; then
          cp "$PLIST_SRC" "$PLIST_DST"
          echo "✅ Copied $PLIST_SRC to $PLIST_DST"
        else
          echo "❌ Error: $PLIST_SRC not found"
          exit 1
        fi
        """,
        name: "Copy GoogleService-Info.plist",
        outputPaths: [
            "${TARGET_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/GoogleService-Info.plist",
        ],
        basedOnDependencyAnalysis: true
    )

    static let crashlyticsUpload = TargetScript.post(
        script: """
        "${BUILD_DIR%/Build/*}/SourcePackages/checkouts/firebase-ios-sdk/Crashlytics/run"
        """,
        name: "Crashlytics",
        inputPaths: [
            "${DWARF_DSYM_FOLDER_PATH}/${DWARF_DSYM_FILE_NAME}",
            "${DWARF_DSYM_FOLDER_PATH}/${DWARF_DSYM_FILE_NAME}/Contents/Resources/DWARF/${PRODUCT_NAME}",
            "${DWARF_DSYM_FOLDER_PATH}/${DWARF_DSYM_FILE_NAME}/Contents/Info.plist",
            "$(TARGET_BUILD_DIR)/$(UNLOCALIZED_RESOURCES_FOLDER_PATH)/GoogleService-Info.plist",
            "$(TARGET_BUILD_DIR)/$(EXECUTABLE_PATH)",
        ],
        basedOnDependencyAnalysis: false
    )
}
