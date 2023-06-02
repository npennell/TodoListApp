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
    
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 57, longitude: -99), span: MKCoordinateSpan(latitudeDelta: 80, longitudeDelta: 80))
    @State private var pinLocations = [PinLocation]()
    
    var body: some View {
        NavigationView{
            VStack{
                Map(coordinateRegion: $region, annotationItems: pinLocations) { item in
                    MapAnnotation(coordinate: item.coordinate){
                        NavigationLink(destination: ItemEditView(passedItem: item.item)){
                            Image(systemName: "pin.circle.fill").foregroundColor(.red)
                        }
                    }
                }
            }.onAppear{self.getLocationsFromItems()}
        }
    }
    
    func getLocationsFromItems(){
        pinLocations.removeAll()
        for item in items{
            pinLocations.append(PinLocation(id: UUID(), title: item.title!, latitude: item.latitude, longitude: item.longitude, item: item))
        }
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
