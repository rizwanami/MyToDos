//
//  DataStore.swift
//  MyToDos
//
//  Created by Rizwana on 5/10/22.
//

import Foundation
import SwiftUI
import Combine
class DataStore : ObservableObject {
   
   @Published var toDos : [ToDo] = []
   @Published var appError : ErrorType? = nil
   var addToDo = PassthroughSubject<ToDo, Never>()
   var updateToDo = PassthroughSubject<ToDo, Never>()
   var deleteToDo = PassthroughSubject<IndexSet, Never>()
   
   var subscriptions = Set<AnyCancellable>()
   init(){
      print(FileManager.docrDirURL.path)
      addSubscriptions()
      if FileManager().docExist(named : fileName){
         loadToDo()
      }
     
   }
   func addSubscriptions(){
      $toDos
         .subscribe(on: DispatchQueue(label: "background queue"))
         .receive(on: DispatchQueue.main)
         .encode(encoder: JSONEncoder())
         .tryMap { (data)  in
            try data.write(to: FileManager.docrDirURL.appendingPathComponent(fileName))
         }
         .sink { [unowned self] (completion) in
            switch completion {
            case .finished:
               print("Saving completed")
            case .failure(let error):
               if error is ToDoError {
                  self.appError = ErrorType(error: error as! ToDoError)
               } else {
                  self.appError = ErrorType(error: ToDoError.decodingError)
               }
            }
         } receiveValue: {
         print("Saving file was sucessfull")
         }
         .store(in: &subscriptions)

      addToDo.sink { [unowned self] toDo in
         toDos.append(toDo)
         //saveToDo()
      }
      .store(in: &subscriptions)
      
      updateToDo.sink { [unowned self] (toDo) in
         guard let index = toDos.firstIndex(where: { $0.id == toDo.id
         }) else {
            return
         }
         toDos[index] = toDo
        // saveToDo()
      }
      .store(in: &subscriptions)
      
      deleteToDo.sink { [unowned self] (index) in
         toDos.remove(atOffsets: index)
         //saveToDo()
      }
      .store(in: &subscriptions)


      
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
      
  /* func saveToDo(){
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
      
      }*/
   }
