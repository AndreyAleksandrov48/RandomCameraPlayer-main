//
//  RectangleView.swift
//  RandomCameraPlayer
//
//  Created by Andrew on 03.02.2024.
//

import SwiftUI
import CoreML
import Vision


struct RectangleView: View{
    
    @State var observation: VNRecognizedObjectObservation
    @State var imageSize: CGSize
    
    var body: some View{
        let boundingBox = observation.boundingBox
        let frame = CGRect(x: boundingBox.minX*imageSize.width, y: (1 - boundingBox.minY - boundingBox.height) * imageSize.height,
                           width: boundingBox.width * imageSize.width,
                           height: boundingBox.height * imageSize.height)
        
        return Rectangle()
            .frame(width: frame.width, height: frame.height)
            .foregroundColor(.clear)
            .border(Color.green, width: 1)
            .position(x: frame.midX, y: frame.midY)
        

    }
}
