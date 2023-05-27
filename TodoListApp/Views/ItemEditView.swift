//
//  ItemEditView.swift
//  TodoListApp
//
//  Created by Nichol Pennell on 2023-05-26.
//

import SwiftUI

struct ItemEditView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var dateHolder: DateHolder
    @State var selectedItem: Item?
    @State var title: String
    @State var image: String
    @State var location: String
    @State var completed: Bool
    
    init(passedItem: Item?){
        if let item = passedItem{
            _selectedItem = State(initialValue: item)
            _title = State(initialValue: item.title ?? "")
            _location = State(initialValue: item.location ?? "")
            _image = State(initialValue: item.image ?? "")
            _completed = State(initialValue: item.completed)
        }
        else{
            _title = State(initialValue: "")
            _location = State(initialValue: "")
            _image = State(initialValue: "")
            _completed = State(initialValue: false)
        }
    }
    
    var body: some View {
        Form{
            Section(header: Text("Task")){
                TextField("Task Name", text: $title)
                
            }
            Section(header: Text("Image")){
                TextField("Image Name", text: $image)
            }
            Section(header: Text("Location")){
                TextField("Location", text: $location)
            }
            Section(){
                Button("Save", action: saveAction)
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .center)
            }
        }
    }
    func saveAction(){
        withAnimation{
            if selectedItem == nil{
                selectedItem = Item(context: viewContext)
            }
            selectedItem?.title = title
            selectedItem?.image = image
            selectedItem?.location = location
            selectedItem?.completed = completed
            
            dateHolder.saveContext(viewContext)
            self.presentationMode.wrappedValue.dismiss()
        }
    }
}

struct ItemEditView_Previews: PreviewProvider {
    static var previews: some View {
        ItemEditView(passedItem: Item())
    }
}
