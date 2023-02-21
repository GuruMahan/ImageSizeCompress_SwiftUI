//
//  PhotoPicker.swift
//  ImagePacker
//
//  Created by Guru Mahan on 04/01/23.
//

import SwiftUI

struct PhotoPicker: UIViewControllerRepresentable{
    
    @Binding var avatarImage: UIImage
    @Environment (\.presentationMode) var presentationMode
    @State var pickerImage = false
    var sourceTYPE: UIImagePickerController.SourceType = .photoLibrary
    func makeUIViewController(context: Context) ->  UIImagePickerController {
        let picker = UIImagePickerController()
        
        picker.delegate = context.coordinator
        picker.allowsEditing = true
        picker.sourceType = sourceTYPE
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {

    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(photoPicker: self)
    }
    
    final class Coordinator: NSObject, UINavigationControllerDelegate,UIImagePickerControllerDelegate{
       
        let photoPicker: PhotoPicker
        
        init(photoPicker: PhotoPicker) {
            self.photoPicker = photoPicker
        }
        
        
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            
            if let img = info[.editedImage] as? UIImage{
                guard let data = img.jpegData(compressionQuality: 0.1),
                     let compressedImage = UIImage(data: data) else {
                    return

                }
                print("Data====>\(data)")
               // print("compressedImage====>\(compressedImage)")
                photoPicker.avatarImage = compressedImage
            }else{
                
            }
            picker.dismiss(animated: true)
        }
    }
    
    func compress(image: UIImage) {
        let maxWidth: CGFloat = 512.0
        let maxHeight: CGFloat = 512.0
        let compressionQuality: CGFloat = 0.8
        
        var actualWidth: CGFloat = image.size.width
        var actualHeight: CGFloat = image.size.height
        var imgRatio: CGFloat = actualWidth/actualHeight
        let maxRatio: CGFloat = maxWidth/maxHeight
        
        if actualHeight > maxHeight || actualWidth > maxWidth {
            if imgRatio < maxRatio {
                imgRatio = maxHeight / actualHeight
                actualWidth = imgRatio * actualWidth
                actualHeight = maxHeight
            } else if imgRatio > maxRatio {
                imgRatio = maxWidth / actualWidth
                actualHeight = imgRatio * actualHeight
                actualWidth = maxWidth
            } else {
                actualHeight = maxHeight
                actualWidth = maxWidth
            }
        }
        
        let rect = CGRect(x: 0, y: 0, width: actualWidth, height: actualHeight)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        if let data = newImage.jpegData(compressionQuality: compressionQuality) {
//            let oldSize = Double(data.count) / 1024.0
//            print("old Image Size: \(data) KB")
            let newSize = Double(data.count) / 1024.0
            print("New Image Size: \(newSize) KB")
            self.avatarImage = newImage
        }
    }
    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        let newSize = widthRatio > heightRatio ?  CGSize(width: size.width * heightRatio, height: size.height * heightRatio) : CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        
        let rect = CGRect(origin: .zero, size: newSize)
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    func compressImage(image: UIImage, compressionQuality: CGFloat) -> Data? {
        return image.jpegData(compressionQuality: compressionQuality)
    }
    
    func resizeAndCompress(image: UIImage, size: CGSize, compressionQuality: CGFloat) -> Data? {
        let resizedImage = resizeImage(image: image, targetSize: size)
        return compressImage(image: resizedImage, compressionQuality: compressionQuality)
    }
    
    
}
