//
//  Pin.swift
//  TodoListApp
//
//  Created by Nichol Pennell on 2023-05-29.
//

import UIKit
import MapKit

struct Pin: Identifiable {
    let id = UUID()
    let latitude: Double
    let longitude: Double
    var coordinate: CLLocationCoordinate2D{
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
