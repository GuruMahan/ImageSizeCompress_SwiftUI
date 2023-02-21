//
//  ContentView.swift
//  ImageSizeCompressPOC
//
//  Created by Guru Mahan on 20/02/23.
//


import SwiftUI
import PhotosUI



struct ContentView: View {
    @State var selectedItems: [PhotosPickerItem] = []
    @State var data: Data?
@Environment (\.presentationMode) var presentationMode
@State var avatarImage = UIImage(systemName: "person.crop.circle")!
@State var showPhotoPicker = false
@State var popUpViewShow = false
@State var cameraShow = false
@State var fileShow = false
@State var fileName = ""

var body: some View {
    
    
    NavigationView{
        VStack{
            ZStack(alignment: .bottomTrailing){
                Button {
                    showPhotoPicker = true
                } label: {
                    
                    
                    Image(uiImage: avatarImage )
                        .resizable()
                        .frame(width: 150,height: 150)
                        .clipShape(Circle())
                    
                    
                }
                Image(systemName: "plus")
                    .frame(width: 30,height: 30)
                    .foregroundColor(.white)
                    .background(Color.gray)
                    .clipShape(Circle())
                
                
            }
            
            Spacer()
            Text("Image Size: \(imageSizeInMB(image: avatarImage))")
            
//            Text("CompressImage Size:\(CompressImage(image: avatarImage))")
            
            Button {
             CompressImage(image: avatarImage)
               
            } label: {
             Text("Compress")
            }

        }
        .onAppear {
         //   guard let image = avatarImage else { return }
            PhotoPicker(avatarImage: $avatarImage).compress(image: avatarImage)
            let sizekb = avatarImage.jpegData(compressionQuality: 0.1)
            print("\((sizekb?.count ?? 0) / 1024)")
        }
        .navigationTitle("profile")
                    .sheet(isPresented: $showPhotoPicker) {
                        PopUpView
                            .presentationDetents([.fraction(0.40)])
                            .colorScheme(.dark)
                    }
        .sheet(isPresented: $cameraShow){
            //                PopUpView
            //                    .frame(width: 250,height: 300)
            //                    .background(Color.clear)
            PhotoPicker(avatarImage: $avatarImage,sourceTYPE: .savedPhotosAlbum)
        }
    }
    .fileImporter(isPresented: $fileShow, allowedContentTypes: [.image,.audio,.data]) { result in
        
        do {
            
            let furl = try result.get()
            if furl.startAccessingSecurityScopedResource(){
                let data = try Data(contentsOf: furl)
                if let img = UIImage(data: data) {
                    print(furl)
                    avatarImage = img
                    
                    self.fileName = furl.lastPathComponent
                    
                }
                furl.stopAccessingSecurityScopedResource()
            }
            
            
        } catch {
            print("error: \(error)") // todo
        }
        
    }
       // .frame(maxWidth: .infinity,maxHeight: 300)

   
//        let popupView = PopUpView
//            if showPhotoPicker == true{
//                withAnimation(.easeIn(duration: 1)) {
//                    popupView
//                  .frame(maxWidth: .infinity,maxHeight: 300)
//                    .background(Color.red).opacity(0.3)
//                    .cornerRadius(10)
//                    .frame(height: 300)
//                    .padding()
//                }
//
//            }
    
  
}


@ViewBuilder var PopUpView: some View{

           // LinearGradient(colors: [Color.gray], startPoint: .leading, endPoint: .trailing)
        HStack(spacing: 10){
                    Button{
                        cameraShow = true
                        showPhotoPicker = false
                    } label: {
                        Image(systemName: "camera.fill")
                            .frame(width: 80,height: 80)
                            .foregroundColor(Color.black)
                            .background(Color.red)
                            .cornerRadius(40)
                           
                    }
                    
                    Button{
               showPhotoPicker = false
                        DispatchQueue.main.asyncAfter(deadline: .now()+0.1, execute: {
                            
                                fileShow = true
                        })
                    } label: {
                        Image(systemName: "filemenu.and.cursorarrow")
                            .frame(width: 80,height: 80)
                            .foregroundColor(Color.black)
                            .background(Color.red)
                            .cornerRadius(40)
                    }

                    
                }
               
                .padding(.top)
                

    }
    
    func CompressImage(image: UIImage) -> String {
        guard let imageData = image.jpegData(compressionQuality: 1.0) else {
            return "Unknown"
        }
       PhotoPicker(avatarImage: $avatarImage).compress(image: imageData)
              //  let sizekb = image.jpegData(compressionQuality: 0.1)
            print("imagecompress==>\(Double(imageData.count) / 1024)")
        
        return ""
 }
    
       
    
    
    func imageSizeInMB(image: UIImage) -> String {
            guard let imageData = image.jpegData(compressionQuality: 1.0) else {
                return "Unknown"
            }
            
            let sizeInBytes = imageData.count
            let sizeInMB = ByteCountFormatter.string(fromByteCount: Int64(sizeInBytes), countStyle: .file)
            
            return sizeInMB
        }
    
}

struct ContentView_Previews: PreviewProvider {
   
    static var previews: some View {
    
            ContentView()
      
    }
}


