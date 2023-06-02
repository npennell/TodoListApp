//
//  Locations.swift
//  TodoListApp
//
//  Created by Nichol Pennell on 2023-05-27.
//

import Foundation
import MapKit

struct PinLocation: Identifiable,  Equatable {
    let id: UUID
    var title: String
    let latitude: Double
    let longitude: Double
    var coordinate: CLLocationCoordinate2D{
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    let item: Item
}
