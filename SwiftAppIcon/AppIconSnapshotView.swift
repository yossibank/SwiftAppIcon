import Photos
import SwiftUI

struct AppIconSnapshotView: View {
    @State private var isPresented = false
    @State private var message = ""

    private let iconSystemName: String
    private let iconColor: Color

    init(
        iconSystemName: String,
        iconColor: Color
    ) {
        self.iconSystemName = iconSystemName
        self.iconColor = iconColor
    }

    var body: some View {
        VStack {
            Spacer()

            AppIconView(iconSystemName: iconSystemName, iconColor: iconColor)
                .frame(width: 300, height: 300)

            Text(iconSystemName)
                .font(.headline)

            Spacer()

            Button("save icon photo library") {
                saveAppIcon()
            }
        }
        .alert("", isPresented: $isPresented) {} message: {
            Text(message)
        }
    }
}

private extension AppIconSnapshotView {
    func saveAppIcon() {
        Task { @MainActor in
            let viewSize = CGSize(
                width: 1024,
                height: 1024
            )

            let rootView = AppIconView(
                iconSystemName: iconSystemName,
                iconColor: iconColor
            )

            let hostingController = UIHostingController(
                rootView: rootView
                    .frame(width: viewSize.width, height: viewSize.height)
                    .offset(.init(width: .zero, height: -12))
                    .background(iconColor)
            )

            hostingController.view.frame = .init(
                origin: .zero,
                size: viewSize
            )

            hostingController.view.backgroundColor = .clear

            let image = hostingController.snapshot(viewSize: viewSize)

            guard let data = image.pngData() else {
                return
            }

            do {
                try await PHPhotoLibrary.shared().performChanges {
                    let request = PHAssetCreationRequest.forAsset()

                    request.addResource(
                        with: .photo,
                        data: data,
                        options: nil
                    )
                }

                message = "success save photo library"
            } catch {
                message = "failure save photo library"
            }

            isPresented = true
        }
    }
}

private extension UIViewController {
    func snapshot(viewSize: CGSize) -> UIImage {
        let format: UIGraphicsImageRendererFormat = {
            $0.scale = 1.0
            return $0
        }(UIGraphicsImageRendererFormat.default())

        let renderer = UIGraphicsImageRenderer(
            size: viewSize,
            format: format
        )

        let image = renderer.image { _ in
            view.drawHierarchy(
                in: .init(
                    origin: .zero,
                    size: viewSize
                ),
                afterScreenUpdates: true
            )
        }

        return image
    }
}

#Preview {
    AppIconSnapshotView(iconSystemName: "m.square.fill", iconColor: .black)
}
