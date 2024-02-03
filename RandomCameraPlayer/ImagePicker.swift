//
//  ImagePicker.swift
//  RandomCameraPlayer
//
//  Created by Andrew on 08.11.2023.
//

import Foundation
import UIKit
import SwiftUI





struct ImagePicker: UIViewControllerRepresentable{
    
    @Binding var selectImage: UIImage?
    @Binding var isPickerShowing: Bool
    
    func makeUIViewController(context: Context) -> some UIViewController {
        
        
        
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = context.coordinator
        
        
        return imagePicker
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    
    
}


class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    var parent: ImagePicker
    
    init(_ picker: ImagePicker) {
        self.parent = picker
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
      print ("Image selected")  //Запускаем код при выборе изображения
        if let image =  info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
        
            
            
            
            DispatchQueue.main.async{
                self.parent.selectImage = image
            }
        }
        
        parent.isPickerShowing = false
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
   print ("cancelled")     // Запускаем код при отмене выбора изображения
        
        
        parent.isPickerShowing = false
    }
}












struct ResizableImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    @Environment(\.presentationMode) private var presentationMode

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        var parent: ResizableImagePicker

        init(parent: ResizableImagePicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                // Измените размер изображения здесь
                let resizedImage = resizeImage(uiImage, targetSize: CGSize(width: 200.0, height: 200.0))
                parent.selectedImage = resizedImage
            }

            parent.presentationMode.wrappedValue.dismiss()
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.presentationMode.wrappedValue.dismiss()
        }

        // Метод для изменения размера изображения
        private func resizeImage(_ image: UIImage, targetSize: CGSize) -> UIImage {
            let renderer = UIGraphicsImageRenderer(size: targetSize)
            return renderer.image { (context) in
                image.draw(in: CGRect(origin: .zero, size: targetSize))
            }
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }

    func makeUIViewController(context: UIViewControllerRepresentableContext<ResizableImagePicker>) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = context.coordinator
        return imagePicker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ResizableImagePicker>) {
        // Update the UIViewController if needed
    }
}


