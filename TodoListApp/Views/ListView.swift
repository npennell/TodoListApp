//
//  ContentView.swift
//  TodoListApp
//
//  Created by Nichol Pennell on 2023-05-26.
//

import SwiftUI
import CoreData
import MapKit

struct ListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var contextHolder: ContextHolder
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.title, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>

    var body: some View {
        NavigationView {
            VStack{
                ZStack{
                    List {
                        ForEach(items) { item in
                            let _ = self.checkLocationData(item: item) // go through and check location data, update when necessary
                            NavigationLink (destination: ItemEditView(passedItem: item)){
                                ItemCell(passedItem: item).environmentObject(contextHolder)
                            }
                        }
                        .onDelete(perform: deleteItems)
                    }
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            EditButton()
                        }
                    }
                    FloatingAddButton() // Other option for add button
                }
            }.navigationTitle("To Do List")
        }
    }

    // Used to fix the data permanence issue on reload app
    private func checkLocationData(item: Item){
        if(item.location != ""){
            if(item.latitude == nil || item.latitude == 0 || item.longitude == nil || item.longitude == 0){
                getLocation(from: item.location!){ location in
                    if(location != nil){
                        item.latitude = location?.latitude ?? 91
                        item.longitude = location?.longitude ?? 181
                        contextHolder.saveContext(viewContext)
                    }
                    else{
                        print("invalid location")
                    }
                }
            }
        }
    }
    
    private func getLocation(from address: String, completion: @escaping (_ location: Location?)-> Void){
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address){ (placemarks, error) in
            guard
                let placemarks = placemarks,
                let location = placemarks.first?.location
            else{
                completion(nil)
                return
            }
            let formattedLocation = Location(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            completion(formattedLocation)
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)

            contextHolder.saveContext(viewContext)
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ListView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
