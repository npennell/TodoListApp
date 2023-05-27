//
//  FloatingAddButton.swift
//  TodoListApp
//
//  Created by Nichol Pennell on 2023-05-26.
//

import SwiftUI

struct FloatingAddButton: View {
    @EnvironmentObject var DateHolder: DateHolder
    
    var body: some View {
        Spacer()
        HStack{
            NavigationLink(destination: ItemEditView(passedItem: nil)) {
                Text("New Task").font(.headline)
            }
            .padding(15)
            .foregroundColor(.white)
            .background(Color.accentColor)
            .cornerRadius(30)
            .padding(30)
            .shadow(color: .black.opacity(0.3), radius: 3, x: 3, y: 3)
        }
    }
}

struct FloatingAddButton_Previews: PreviewProvider {
    static var previews: some View {
        FloatingAddButton()
    }
}
