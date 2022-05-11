//
//  DataStore.swift
//  MyToDos
//
//  Created by Rizwana on 5/10/22.
//

import Foundation
import SwiftUI
class DataStore : ObservableObject {
   
   @Published var toDos : [ToDo] = []
   @Published var appError : ErrorType? = nil
   init(){
      print(FileManager.docrDirURL.path)
      if FileManager().docExist(named : fileName){
         loadToDo()
      }
     
   }
   
   func addToDo(toDo : ToDo){
      toDos.append(toDo)
      saveToDo()
   }
   func updateToDo(toDo : ToDo){
      guard let index = toDos.firstIndex(where: { $0.id == toDo.id
         
      })  else {
         return
      }
      toDos[index] = toDo
      saveToDo()
   }
   func deleteToDo(at indexSet : IndexSet){
      toDos.remove(atOffsets: indexSet)
      saveToDo()
   }
   func loadToDo(){
      FileManager().readDocument(docName: fileName) { (result) in
         switch result {
         case .success(let data):
            let decoder = JSONDecoder()
            do {
               toDos = try decoder.decode([ToDo].self, from: data)
            } catch {
               print(error.localizedDescription)
               appError = ErrorType(error: .decodingError)
            }
         case .failure(let error):
            
            print(error.localizedDescription)
            appError = ErrorType(error: .readError)
            
         }
         
         
   }
   }
      
   func saveToDo(){
        print("Save Data successfully")
      let enccoder = JSONEncoder()
      do {
         let data = try enccoder.encode(toDos)
         let jsonString = String(decoding: data, as: UTF8.self )
         FileManager().saveDocument(content: jsonString, docName: fileName) { (error) in
            if let error = error {
               print(error.localizedDescription)
               appError = ErrorType(error: .encodingError)
               
            }
         }
         
         
      } catch {
         print(error.localizedDescription)
         appError = ErrorType(error: .saveError)
      }
      
      }
   }
