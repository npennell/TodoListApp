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
            let context = persistenceController.container.viewContext
            let contextHolder = ContextHolder(context )
            
            TabView(selection: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Selection@*/.constant(1)/*@END_MENU_TOKEN@*/) {
                ListView().environment(\.managedObjectContext, persistenceController.container.viewContext).environmentObject(contextHolder).tabItem {
                    Image(systemName: "checklist")
                    Text("List View")
                }.tag(1)
                MapView().environment(\.managedObjectContext, persistenceController.container.viewContext).environmentObject(contextHolder).tabItem {
                    Image(systemName: "map")
                    Text("Map View")
                }.tag(2)
            }
        }
    }
}
