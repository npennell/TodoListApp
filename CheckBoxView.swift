//
//  CheckBoxView.swift
//  TodoListApp
//
//  Created by Nichol Pennell on 2023-05-26.
//

import SwiftUI

struct CheckBoxView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var dateHolder: DateHolder
    @ObservedObject var passedItem: Item
    
    var body: some View {
        Image(systemName: passedItem.completed == true ? "checkmark.circle.fill" : "circle")
            .foregroundColor(passedItem.completed ? .green : .secondary)
            .onTapGesture {
                withAnimation{
                    passedItem.completed = !passedItem.completed
                    dateHolder.saveContext(viewContext)
                }
            }
    }
}

struct CheckBoxView_Previews: PreviewProvider {
    static var previews: some View {
        CheckBoxView(passedItem: Item())
    }
}
