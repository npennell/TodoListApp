//
//  TodoListAppApp.swift
//  TodoListApp
//
//  Created by Nichol Pennell on 2023-05-26.
//

import SwiftUI

@main
struct TodoListAppApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            TabView(selection: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Selection@*/.constant(1)/*@END_MENU_TOKEN@*/) {
            ContentView().environment(\.managedObjectContext, persistenceController.container.viewContext).tabItem {
                Image(systemName: "checklist")
                Text("List View")
            }.tag(1)
            MapView().tabItem {
                Image(systemName: "map")
                Text("Map View")
                
            }.tag(2)
        }
//            ContentView()
//                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
