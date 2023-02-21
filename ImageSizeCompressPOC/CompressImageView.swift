//
//  CompressImageView.swift
//  ImageSizeCompressPOC
//
//  Created by Guru Mahan on 20/02/23.
//
import SwiftUI

struct CompressedImageView: View {
    @State private var image: UIImage?
    
    var body: some View {
        VStack {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 200, height: 200)
            }
            Button("Select Image") {
                let picker = UIImagePickerController()
                picker.sourceType = .photoLibrary
              //  picker.delegate = context.coordinator
                UIApplication.shared.windows.first?.rootViewController?.present(picker, animated: true, completion: nil)
            }
        }
    }
    

}

//extension CompressedImageView {
//    func resizeAndCompress(image: UIImage) -> UIImage? {
//        let maxSize: CGFloat = 1024.0 // Maximum size of the image
//        let compressionQuality: CGFloat = 0.8 // Compression quality of the image
//        
//        // Get the current size of the image
//        let currentSize = image.size
//        
//        // Calculate the new size of the image to maintain the aspect ratio
//        var newSize = CGSize(width: maxSize, height: maxSize)
//        let widthRatio = newSize.width / currentSize.width
//        let heightRatio = newSize.height / currentSize.height
//        let scale = min(widthRatio, heightRatio)
//        newSize.width = currentSize.width * scale
//        newSize.height = currentSize.height * scale
//        
//        // Resize the image to the new size
//        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
//        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
//        image.draw(in: rect)
//        let newImage = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//        
//        // Compress the image
//        if let imageData = newImage?.jpegData(compressionQuality: compressionQuality) {
//            let dataSizeKB = Double(imageData.count) / 1024.0
//            print("New Image Size: \(dataSizeKB)")
//     }
//   }
//}


