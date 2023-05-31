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
    @State private var locationCheckResult = false
    
    init(passedItem: Item?){
        if let item = passedItem{
//            print(item.latitude, item.longitude)
            _selectedItem = State(initialValue: item)
            _title = State(initialValue: item.title ?? "")
            _location = State(initialValue: item.location ?? "")
            _latitude = State(initialValue: item.latitude)
            _longitude = State(initialValue: item.longitude)
            _image = State(initialValue: item.image)
            _completed = State(initialValue: item.completed)
            
            // Trying to fix data permanance issue
//            if(location != "" && (latitude == nil || longitude == nil)){
//                getLocationInfo(from: location)
//            }
//            print(latitude, longitude)
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
//                                            Text("Delete image").foregroundColor(.red)
                                        }
                                        
                                    }
                                }
    //                            Spacer()
                            }
                           
                        }
                        Image(uiImage: uiimage)
                            .resizable()
                            .scaledToFit()
//                            .overlay(Group {
//                                HStack{
//                                    Spacer()
//                                    VStack{
//                                        ZStack {
//                                            Button(action: deleteImage){
//                                                Image(systemName: "xmark.circle.fill")
//                                                    .cornerRadius(10)
//                                                    .foregroundColor(.red)
//                                            }
//                                        }
//                                        Spacer()
//                                    }
//                                }
//                            })
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
//                Text("longitude:", String($longitude))
                
            }
            Section(){
                Button("Save", action: dataCheck)
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .center)
            }
        }
        .alert(alertMessage, isPresented: $showingAlert){
            Button("OK", role: .cancel) {
                locationCheckResult = false // NEEDED?
            }
        }
    }
    func dataCheck(){
        // Title field check
        if(title == ""){
            alertMessage = "Please add a title to todo!"
            showingAlert = true
            return
        }
        locationValidCheck(address: location)
        if(locationCheckResult == false){
//            alertMessage = "Invalid loc!"
//            showingAlert = true
            return
        }
        saveAction()
    }
    
    func deleteImage(){
        print("delete image")
        // nil all photo related data
        image = nil
        
    }
    
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
//            Test getLocation
//            getLocation(from: location) { location in
//                if (location != nil) {
////                    selectedItem?.latitude = location!.latitude
////                    selectedItem?.longitude = location!.longitude
//                    print(location!.latitude)
//                    print(location!.longitude)
//                }
//                else{
////                    selectedItem?.latitude = 91 // maximum latitude is 90 - used to set value for default
////                    selectedItem?.longitude = 181 // maximum longitude is 180 - used to set value for default
//                    print("error occurred")
//                }
//            }
            getLocationInfo(from: location)
        
            selectedItem?.completed = completed
            
            contextHolder.saveContext(viewContext)
            
            self.presentationMode.wrappedValue.dismiss()
        }
    }
    
    func locationValidCheck(address: String){
//        locationCheckResult = nil
        if(address == ""){
            locationCheckResult = true
            return
        }
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address){ (placemarks, error) in
            guard
                let placemarks = placemarks,
                let _ = placemarks.first?.location
            else{
                locationCheckResult = false
                alertMessage = "Invalid location!\nPlease adjust before saving"
                showingAlert = true
                return
            }
            locationCheckResult = true
        }
    }
    
    func getLocation(from address: String, completion: @escaping (_ location: Location?)-> Void){
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address){ (placemarks, error) in
            guard
                let placemarks = placemarks,
                let location = placemarks.first?.location
            else{
                completion(nil)
                selectedItem?.latitude = 91
                selectedItem?.longitude = 181
                return
            }
            selectedItem?.latitude = location.coordinate.latitude
            selectedItem?.longitude = location.coordinate.longitude
            let formattedLocation = Location(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            completion(formattedLocation)
        }
        
//        geocoder.geocodeAddressString(address) {(placemarks, error) in
//            guard let placemarks = placemarks,
//                let location = placemarks.first?.location?.coordinate else {
//                completion(nil)
//                return
//            }
//            completion(location)
//        }
    }
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
