//
//  ItemEditView.swift
//  TodoListApp
//
//  Created by Nichol Pennell on 2023-05-26.
//

import SwiftUI
import PhotosUI
import CoreLocation

struct ItemEditView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var contextHolder: ContextHolder
    @State var selectedItem: Item?
    @State var title: String
    @State var image: Data?
    @State var location: String
    @State var latitude: Double
    @State var longitude: Double
    @State var completed: Bool
    @State var selectedPhoto: [PhotosPickerItem] = []
    @State var photoData: Data?
    
    @State private var showingAlert = false
    @State private var alertMessage = ""
//    @State private var locationCheckResult = false
    
    init(passedItem: Item?){
        if let item = passedItem{
            _selectedItem = State(initialValue: item)
            _title = State(initialValue: item.title ?? "")
            _location = State(initialValue: item.location ?? "")
            _latitude = State(initialValue: item.latitude)
            _longitude = State(initialValue: item.longitude)
            _image = State(initialValue: item.image)
            _completed = State(initialValue: item.completed)
        }
        else{
            _title = State(initialValue: "")
            _location = State(initialValue: "")
            _latitude = State(initialValue: 91)
            _longitude = State(initialValue: 181)
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
                    VStack{
                        HStack{
                            Spacer()
                            VStack{
                                ZStack {
                                    HStack{
                                        Button(action: deleteImage){
                                            Image(systemName: "xmark.circle.fill")
                                                .foregroundColor(.red)
//                                            Text("Delete image").foregroundColor(.red) // Text option for delete
                                        }
                                    }
                                }
                            }
                        }
                        Image(uiImage: uiimage)
                            .resizable()
                            .scaledToFit()
                    }
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
                Button("Save", action: dataCheck)
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .center)
            }
        }
        .alert(alertMessage, isPresented: $showingAlert){
            Button("OK", role: .cancel) {
//                locationCheckResult = false
            }
        }
    }
    
    // Error checking
    func dataCheck(){
        // Title field check
        if(title == ""){
            alertMessage = "Please add a title to todo!"
            showingAlert = true
            return
        }
        
        // Location check: works but requires user to click submit button twice on successful location
//        locationValidCheck(address: location)
//        if(locationCheckResult == false){
//            return
//        }
        saveAction()
    }
    
    // Deletes current image data
    func deleteImage(){
        print("delete image")
        // nil all photo related data
        image = nil
        
    }
    
    // Save current data on page
    func saveAction(){
        withAnimation{
            if selectedItem == nil{
                selectedItem = Item(context: viewContext)
            }
            
            selectedItem?.title = title
            
            if(photoData != nil){
                selectedItem?.image = photoData
            }
            else{
                selectedItem?.image = image
            }
            
            selectedItem?.location = location

            getLocationInfo(from: location)
        
            selectedItem?.completed = completed
            
            contextHolder.saveContext(viewContext)
            
            self.presentationMode.wrappedValue.dismiss()
        }
    }
    
    // Check if location conversion produces valid location (latiude/longitude)
//    func locationValidCheck(address: String){
//        if(address == ""){
//            locationCheckResult = true
//            return
//        }
//        let geocoder = CLGeocoder()
//        geocoder.geocodeAddressString(address){ (placemarks, error) in
//            guard
//                let placemarks = placemarks,
//                let _ = placemarks.first?.location
//            else{
//                locationCheckResult = false
//                alertMessage = "Invalid location!\nPlease adjust before saving"
//                showingAlert = true
//                return
//            }
//            locationCheckResult = true
//        }
//    }
    
    // Gets location from string, saves information to working object
    func getLocationInfo(from address: String){
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address){ (placemarks, error) in
            guard
                let placemarks = placemarks,
                let location = placemarks.first?.location
            else{
                selectedItem?.latitude = 91
                selectedItem?.longitude = 181
                return
            }
            selectedItem?.latitude = location.coordinate.latitude
            selectedItem?.longitude = location.coordinate.longitude
        }
    }
}

struct ItemEditView_Previews: PreviewProvider {
    static var previews: some View {
        ItemEditView(passedItem: Item())
    }
}
