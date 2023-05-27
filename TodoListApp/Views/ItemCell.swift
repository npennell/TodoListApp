//
//  ItemCell.swift
//  TodoListApp
//
//  Created by Nichol Pennell on 2023-05-26.
//

import SwiftUI

struct ItemCell: View {
    
    @EnvironmentObject var dateHolder: DateHolder
    @ObservedObject var passedItem: Item
    
    var body: some View {
        CheckBoxView(passedItem: passedItem)
            .environmentObject(dateHolder)
        Text(passedItem.title ?? "")
            .padding(.horizontal)
    }
}

struct ItemCell_Previews: PreviewProvider {
    static var previews: some View {
        ItemCell(passedItem: Item())
    }
}
