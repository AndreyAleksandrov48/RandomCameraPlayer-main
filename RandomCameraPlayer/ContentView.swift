//
//  ContentView.swift
//  RandomCameraPlayer
//
//  Created by Andrey Aleksandrov on 31/07/2023.
//
import SwiftUI
import AVKit
import SwiftData
import CoreML


struct VideoPlayerViewController: UIViewControllerRepresentable{
    @Binding var camera: URL
    
    
    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let controller  = AVPlayerViewController()
        let player = AVPlayer(url: camera)
        let layer = AVPlayerLayer()
        controller.player = player
        controller.videoGravity = AVLayerVideoGravity(rawValue: "25")
        player.play()
        
        return controller
    }
    
    
    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {
       
    }
    
}





struct ContentView: View{
    @Query var links: [DataModel]
    @Environment (\.modelContext) private var context
    @State var camera = arrayLink.randomElement()!
    @State private var selectplayer: Bool = false
    @State private var date: Date = Date(timeInterval: Double(), since: .now)
    @State private var insertLinkWindow: Bool = false
    @State var urlInput: URL?
    @State var floatWindow: Bool = false
    var body: some View{
        NavigationStack{
            ZStack{
                Image("natural-green-leafy-wall-background-vertical-free-photo")
                    .resizable()
                
                
                if selectplayer {
                    
                    VideoPlayerViewController(camera: $camera)
                        .frame(width: 410, height: 230, alignment: .center)
                        .padding(.bottom, 250)
                        
                } else {
                    
                    VideoPlayerViewController(camera: $camera)
                            .frame(width: 410, height: 230, alignment: .center)
                            .padding(.bottom, 240)
                    
                }
                
                NavigationLink(destination: SaveDataModel()){
                    Text("Saved Link")}
                .padding()
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(10)
                .shadow(radius: 10)
                .frame(width: 130, height: 40, alignment: .center)
                .padding(.leading, 200)
                .padding(.top, 150)
                
                
                
                ShareLink(item: camera)
                    .padding()
                    .background(Color.pink)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .shadow(radius: 10)
                    .padding(.trailing, 200)
                    .padding(.top, 150)
                
                
                
                Button(action: {self.selectplayer.toggle(); camera = arrayLink.randomElement()!; let generator = UIImpactFeedbackGenerator(style: .heavy);
                    generator.impactOccurred()}){
                    Text("Push")}
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
                .shadow(radius: 10)
                .frame(width: 100, height: 40, alignment: .center)
                .padding(.top, 150)
                
                
                
                
                Button(action: {saveDataModel()}){
                    Text("Save")}
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
                .shadow(radius: 10)
                .frame(width: 100, height: 40, alignment: .center)
                .padding(.top, 350)
                
               
                
                
                NavigationLink(destination: WebViewMap()){
                    Text("Web View")}
                .padding()
                .frame(width: 130, height: 55, alignment: .center)
                .background(Color.black)
                .foregroundColor(.white)
                .shadow(radius: 10)
                .cornerRadius(10)
                .padding(.top, 350)
                .padding(.leading, 250)
                
                Button("Add Link"){
                    floatWindow.toggle()
                }.padding()
                    .background(Color.indigo)
                    .foregroundColor(.white)
                    .shadow(radius: 10)
                    .cornerRadius(10)
                    .padding(.top, 700)
                    
                
                Rectangle()
                    .background(Color.white)
                    .foregroundColor(.cyan)
                    .shadow(radius: 10)
                    .cornerRadius(10)
                    .frame(width: 300, height: 200, alignment: .center)
                    .offset(y: floatWindow ? 0 : 380)
                    .overlay{
                        OverlayView(urlInput: $urlInput)
                        .offset(y: floatWindow ? 0 : 380)
                    }.animation(.easeInOut(duration: 1))
                    
                    .padding(.top, 400)
                
            }.ignoresSafeArea(.all)
        }
    }
    
    func saveDataModel(){
        let datamodel = DataModel(savedLink: camera, id: UUID(), date: date)
        context.insert(datamodel)
    }
}

struct ContentView_Previews: PreviewProvider{
    static var previews: some View{
        ContentView()
            .modelContainer(for: DataModel.self, inMemory: true, isAutosaveEnabled: false, isUndoEnabled: false)
    }
}



struct OverlayView: View{
    @Query var links: [DataModel]
    @Environment (\.modelContext) private var context
    @Binding var urlInput: URL?
    @State private var date: Date = Date(timeInterval: Double(), since: .now)
    var body: some View{
        ZStack{
            VStack{
                Text("Insert Link")
                TextField("Введите URL", text: Binding(
                    get: { urlInput?.absoluteString ?? "" },
                    set: {
                        // При изменении текста в TextField, пытаемся создать URL
                        if let newURL = URL(string: $0) {
                            urlInput = newURL
                        }
                    }
                )).padding()
                    .background(Color.blue)
                    .foregroundColor(.black)
                    .frame(width: 200, height: 50, alignment: .center)
                    .shadow(radius: 10)
                    .cornerRadius(10)
                
                Button("Save"){
                   
                        let datamodel = DataModel(savedLink: urlInput!, id: UUID(), date: date)
                        context.insert(datamodel)
                    
                }.padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding(.top, 50)
            }
        }
    }
}
