//
//  ItemEditView.swift
//  TodoListApp
//
//  Created by Nichol Pennell on 2023-05-26.
//

import SwiftUI
import PhotosUI

struct ItemEditView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var contextHolder: ContextHolder
    @State var selectedItem: Item?
    @State var title: String
    @State var image: Data?
    @State var location: String
    @State var completed: Bool
    
    @State var selectedPhoto: [PhotosPickerItem] = []
    @State var photoData: Data?
    
    init(passedItem: Item?){
        if let item = passedItem{
            _selectedItem = State(initialValue: item)
            _title = State(initialValue: item.title ?? "")
            _location = State(initialValue: item.location ?? "")
            _image = State(initialValue: item.image)
//            if(_image?){
//                _photoData = State(initialValue: image)
//            }
            _completed = State(initialValue: item.completed)
        }
        else{
            _title = State(initialValue: "")
            _location = State(initialValue: "")
//            _image = State(initialValue: "")
            _completed = State(initialValue: false)
        }
    }
    
    var body: some View {
        Form{
            Section(header: Text("Task")){
                TextField("Task Name", text: $title)
                
            }
            Section(header: Text("Image")){
                if let data = image, let uiimage = UIImage(data: data){
                    Image(uiImage: uiimage)
                        .resizable()
                        .scaledToFit()
                }
                PhotosPicker(selection: $selectedPhoto, maxSelectionCount: 1, matching: .images){
                    Text("Pick Image")
                }
                .onChange(of: selectedPhoto){ newValue in
                    guard let item = selectedPhoto.first else{
                        return
                    }
                    item.loadTransferable(type: Data.self) {result in
                        switch result{
                        case.success(let data):
                            if let data = data {
                                self.photoData = data
                                self.image = data
                            }
                            else{
                                print("Data is nil")
                            }
                        case.failure(let failure):
                            fatalError("\(failure)")
                        }
                    
                    }
                }
            
            }
            Section(header: Text("Location")){
                TextField("Location", text: $location)
            }
            Section(){
                Button("Save", action: saveAction)
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .center)
            }
        }
    }
    func saveAction(){
        withAnimation{
            if selectedItem == nil{
                selectedItem = Item(context: viewContext)
            }
            selectedItem?.title = title
//            selectedItem?.image = image
            if(photoData != nil){
                selectedItem?.image = photoData
            }
            else{
                selectedItem?.image = image
            }
            selectedItem?.location = location
            selectedItem?.completed = completed
            
            contextHolder.saveContext(viewContext)
            self.presentationMode.wrappedValue.dismiss()
        }
    }
}

struct ItemEditView_Previews: PreviewProvider {
    static var previews: some View {
        ItemEditView(passedItem: Item())
    }
}
