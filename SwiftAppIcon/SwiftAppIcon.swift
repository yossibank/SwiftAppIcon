import SwiftUI

// MARK: - 画像保存先

// ~/Library/Developer/CoreSimulator/Devices/[DEVICE_ID]/data/Media/DCIM/100APPLE/

// MARK: - DEVICE_ID

// iPhone16 A0D0B835-A4FE-48AF-A653-B2EA853C3C94

@main
struct SwiftAppIcon: App {
    var body: some Scene {
        WindowGroup {
            AppIconSnapshotView(
                iconSystemName: "m.square.fill",
                iconColor: .black
            )
        }
    }
}
