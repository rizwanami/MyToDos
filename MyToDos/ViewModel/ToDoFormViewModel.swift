//
//  ToDoFormViewModel.swift
//  MyToDos
//
//  Created by Rizwana on 5/10/22.
//

import Foundation
import SwiftUI
class ToDoFormViewModel : ObservableObject {
   @Published var name : String = ""
   @Published var completetd : Bool = false
   var id : String?
   var upddating : Bool {
      id != nil
   }
   var isdisabledd : Bool {
      name.isEmpty
   }
   init(){}
      
   init(_ currentToDo : ToDo){
      self.name = currentToDo.name
      self.completetd = currentToDo.completed
      id = currentToDo.id
   }
}
