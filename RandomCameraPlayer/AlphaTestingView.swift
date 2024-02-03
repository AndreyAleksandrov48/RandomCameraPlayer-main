//
//  AlphaTestingView.swift
//  RandomCameraPlayer
//
//  Created by Andrew on 29.12.2023.
//

import SwiftUI
import AVKit
import Vision
import CoreML

struct AlphaTestingView: View {
    
    @State var videoPlayerRepresentable = VideoPlayerRepresentable(videoURL: URL(string: "https://camera.lipetsk.ru/ms-27.camera.lipetsk.ru/live/0bfa54c1-72e3-464f-8e18-7b6ca5d95dde/playlist.m3u8")!)
    
    @State private var rectangles: [CGRect] = []
    @State var snapshotImage: UIImage?
    @State var testImage: UIImage? = UIImage(named: "night")!
    
    
    var body: some View {
        VStack {
            // Ваш VideoPlayerRepresentable
            videoPlayerRepresentable
                .frame(width: 410, height: 230)
                .overlay(RectangleOverlayAlpha(rectangles: $rectangles))
            
            // Кнопка для захвата скриншота
            Button("Capture Screenshot") {
                self.snapshotImage = self.videoPlayerRepresentable.getSnapshotImage(from: self.videoPlayerRepresentable.currentlyPresentedViewController()); countPeople(in: snapshotImage!, detectWholeBody: true)
            }

            // Отображение захваченного изображения
            if let image: UIImage = snapshotImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                .overlay(RectangleOverlayAlpha(rectangles: $rectangles))
            }
        }
    }
    
    func countPeople(in image: UIImage, detectWholeBody: Bool) {
        
        guard let ciImage = CIImage(image: image) else { return }

        let request = VNDetectHumanRectanglesRequest { request, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Ошибка обработки изображения: \(error.localizedDescription)")
                    return
                }

                guard let observations = request.results as? [VNHumanObservation] else {
                    print("Нет результатов")
                    return
                }

                self.rectangles = observations.map { observation in
                    let boundingBox = observation.boundingBox
                    return CGRect(x: boundingBox.minX, y: 1 - boundingBox.minY - boundingBox.height,
                                  width: boundingBox.width, height: boundingBox.height)
                }
            }
        }

        request.usesCPUOnly = true
        
        request.upperBodyOnly = !detectWholeBody

        let handler = VNImageRequestHandler(ciImage: ciImage, options: [:])
        do {
            try handler.perform([request])
        } catch {
            print("Ошибка выполнения запроса Vision: \(error.localizedDescription)")
        }
    }
    
    
}

struct VideoPlayerRepresentable: UIViewControllerRepresentable {
    var videoURL: URL
     var viewController = AVPlayerViewController()

    func makeUIViewController(context: Context) -> AVPlayerViewController {
        viewController.player = AVPlayer(url: videoURL)
        return viewController
    }

    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {
    }

    func getSnapshotImage(from uiViewController: AVPlayerViewController) -> UIImage? {
        return uiViewController.view.getSnapshotImage()
    }

    func currentlyPresentedViewController() -> AVPlayerViewController {
        return viewController
    }
}

extension UIView {
    public func getSnapshotImage() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.isOpaque, 0)
        self.drawHierarchy(in: self.bounds, afterScreenUpdates: false)
        let snapshotImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return snapshotImage
    }
}



struct RectangleOverlayAlpha: View {
    @Binding var rectangles: [CGRect]

    var body: some View {
        GeometryReader { geometry in
            ForEach(rectangles.indices, id: \.self) { index in
                Rectangle()
                    .stroke(Color.red, lineWidth: 2)
                    .frame(width: rectangles[index].width * geometry.size.width,
                           height: rectangles[index].height * geometry.size.height)
                    .offset(x: rectangles[index].minX * geometry.size.width,
                            y: rectangles[index].minY * geometry.size.height)
            }
        }
    }
}






#Preview{
    AlphaTestingView()
}








