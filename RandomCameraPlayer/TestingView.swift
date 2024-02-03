//
//  TestingView.swift
//  RandomCameraPlayer
//
//  Created by Andrew on 06.11.2023.
//

import SwiftUI
import AVKit
import Vision



struct VideoPlayerController: UIViewControllerRepresentable {
    var videoURL: URL
    var captureInterval: TimeInterval = 2
    var onCapture: (UIImage?) -> Void

    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let controller = AVPlayerViewController()
        let player = AVPlayer(url: videoURL)
        controller.player = player
        player.play()

        Timer.scheduledTimer(withTimeInterval: captureInterval, repeats: true) { _ in
            let screenshot = captureScreenshot(from: controller)
            DispatchQueue.global().async {
                
            
                DispatchQueue.main.async {
                    onCapture(screenshot)
                }
            }
            
        }

        return controller
    }

    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {
        // Обновление логики контроллера при необходимости
    }

    private func captureScreenshot(from playerViewController: AVPlayerViewController) -> UIImage? {
        guard let view = playerViewController.view else {
            return nil
        }

        let renderer = UIGraphicsImageRenderer(size: view.bounds.size)
        return renderer.image { ctx in
            view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        }
    }
}




struct TestingView: View {
    var videoURL: URL = URL(string: "https://camera.lipetsk.ru/ms-27.camera.lipetsk.ru/live/0bfa54c1-72e3-464f-8e18-7b6ca5d95dde/playlist.m3u8")!
    @State var screenshot: UIImage?
    @State var detectedRectangles: [CGRect] = []
    @State var detectWholeBody: Bool = false
   //   @State var image: UIImage? = UIImage(named: "field_image_dsc_0007-scaled-1536x1020")!
    
    var body: some View {
        VStack {
            
            
            if let screenshot = screenshot {
                Image(uiImage: screenshot)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .overlay(RectangleOverlay(rectangles: $detectedRectangles))
            }
            
            Button("Detect People") {
                if let screenshot = screenshot {
                    countPeople(in: screenshot, detectWholeBody: false)
                }
            }
            
            
             VideoPlayerController(videoURL: videoURL) { capturedImage in
             self.screenshot = capturedImage
             
                 if let image = capturedImage {
             countPeople(in: image, detectWholeBody: detectWholeBody)
             }
             
             
             }.overlay(RectangleOverlay(rectangles: $detectedRectangles))
             .frame(width: 400, height: 300, alignment: .center)
             
             
            
            
            
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

                self.detectedRectangles = observations.map { observation in
                    let boundingBox = observation.boundingBox
                    return CGRect(x: boundingBox.minX, y: 1 - boundingBox.minY - boundingBox.height,
                                  width: boundingBox.width, height: boundingBox.height)
                }
            }
        }

    //    request.usesCPUOnly = true
        request.upperBodyOnly = !detectWholeBody

        let handler = VNImageRequestHandler(ciImage: ciImage, options: [:])
        do {
            try handler.perform([request])
        } catch {
            print("Ошибка выполнения запроса Vision: \(error.localizedDescription)")
        }
    }
}

struct RectangleOverlay: View {
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
   TestingView()
}

