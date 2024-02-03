//
//  SaveLinkView.swift
//  RandomCameraPlayer
//
//  Created by Andrew on 04.11.2023.
//

import Foundation
import SwiftUI
import SwiftData
import AVKit



struct VideoController: UIViewControllerRepresentable{
    
    @Environment(\.modelContext) var modelcontext
    @Query var links: [DataModel]
    
    var videoURL: [URL]
    
    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let controller = AVPlayerViewController()
        let player = AVPlayer()
        controller.player = player
        player.play()
        
        
        return controller
    }
    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {
        
    }
}








struct SaveDataModel: View{
    @Environment(\.modelContext) var modelcontext
    @Query var links: [DataModel]
    
    
    var body: some View{
        NavigationSplitView{
            List{
                ForEach(links){link in
                    NavigationLink{
                        VideoPlayer(player: AVPlayer(url: link.savedLink))
                            .frame(width: 400, height: 300, alignment: .center)
                    
                        
                    } label: {
                        Text("Saved camera")
                    }
                }
                .onDelete(perform: deleteItems)
            }
        } detail: {
            Text("Select item")
        }
    }
    
    private func deleteItems(offsets: IndexSet){
        withAnimation{
            for index in offsets{
                modelcontext.delete(links[index])
            }
        }
    }
    
    
    
    
    
    
    
    
}

