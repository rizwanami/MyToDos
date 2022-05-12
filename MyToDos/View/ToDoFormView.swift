//
//  ToDoFormView.swift
//  MyToDos
//
//  Created by Rizwana on 5/10/22.
//

import SwiftUI

struct ToDoFormView: View {
   @EnvironmentObject var dataStore : DataStore
   @ObservedObject var formVM : ToDoFormViewModel
   @Environment(\.presentationMode) var presentationMode
    var body: some View {
      NavigationView {
         Form {
            TextField("ToDo", text: $formVM.name)
            Toggle("Completed", isOn: $formVM.completetd)
            
         }
         .navigationTitle("Todo")
         .navigationBarTitleDisplayMode(.inline)
         .navigationBarItems(leading: cancelButton, trailing: updateAndSaveButton)
      }
      
    }
}
extension ToDoFormView {
   func upddateToDo(){
      let toDo = ToDo(id: formVM.id!, name: formVM.name, completed: formVM.completetd)
      dataStore.updateToDo.send(toDo)
      presentationMode.wrappedValue.dismiss()
   }
   func adToDo(){
      let toDo = ToDo(name: formVM.name)
      dataStore.addToDo.send(toDo)
      presentationMode.wrappedValue.dismiss()
   }
   var cancelButton :some View {
      Button("Cancel"){
         presentationMode.wrappedValue.dismiss()
      }
   }
   var updateAndSaveButton : some View {
      Button(formVM.upddating ? "Update" : "Save", action : formVM.upddating ? upddateToDo : adToDo)
         .disabled(formVM.isdisabledd)
   }
}
struct ToDoFormView_Previews: PreviewProvider {
    static var previews: some View {
      ToDoFormView(formVM: ToDoFormViewModel())
         .environmentObject(DataStore())
    }
}
