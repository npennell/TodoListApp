//
//  MapView.swift
//  TodoListApp
//
//  Created by Nichol Pennell on 2023-05-26.
//

import SwiftUI
import CoreData
import MapKit

struct MapView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var contextHolder: ContextHolder
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.title, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>
//    @State private var locations = [Location]()
    
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 57, longitude: -99), span: MKCoordinateSpan(latitudeDelta: 80, longitudeDelta: 80))
    @State private var pinLocations = [PinLocation]()
    // Sample pins array
    @State private var pins = [
        Pin(latitude: 42.9877866, longitude: -81.2459254)
    ]
    
    var body: some View {
//        let _ = self.getLocationsFromItems()
        VStack{
            Text("length of locations array = \(pinLocations.count)")
            Map(coordinateRegion: $region, annotationItems: pinLocations) { item in
                MapMarker(coordinate: item.coordinate)
            }
            
//            Working map sample!
//            Map(coordinateRegion: $region, annotationItems: pins, annotationContent: { location in
//                MapMarker(coordinate: location.coordinate)
//            })
        }.onAppear{self.getLocationsFromItems()}
        
        
    }
    
    func getLocationsFromItems(){
        pinLocations.removeAll()
        for item in items{
//            if(item.latit != nil){
//                print(item.locationCoordinates)
//                locations.append(item.locationCoordinates!)
                pinLocations.append(PinLocation(id: UUID(), title: item.title!, latitude: item.latitude, longitude: item.longitude))
//                print("test")
//            }
//            else{
//                print("no location")
//            }
        }
        print("locations: ", pinLocations)
        print("items count", items.count)
        print("items", items)
//        return locations
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
