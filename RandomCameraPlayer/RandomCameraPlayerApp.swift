//
//  RandomCameraPlayerApp.swift
//  RandomCameraPlayer
//
//  Created by Anonymous on 31/07/2023.
//

import SwiftUI
import SwiftData
import CoreML

@main
struct RandomCameraPlayerApp: App {

    var body: some Scene {
        WindowGroup {
            ContentView()
                
        }.modelContainer(for: DataModel.self)
    }
}
