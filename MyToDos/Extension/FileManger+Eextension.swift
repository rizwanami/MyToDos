//
//  FileManger+Eextension.swift
//  MyToDos
//
//  Created by Rizwana on 5/10/22.
//

import Foundation
let fileName = "ToDos.json"

extension FileManager {
   static var docrDirURL : URL {
      return self.default.urls(for: .documentDirectory, in: .userDomainMask).first!
   }
   func saveDocument(content : String, docName: String, completion : (ToDoError?)-> Void){
      let url = Self.docrDirURL.appendingPathComponent(docName)
      do {
         try content.write(to: url, atomically: true, encoding: .utf8)
      } catch {
         completion(.saveError)
      }
      
   }
   func readDocument(docName : String , completion : (Result<Data, ToDoError>)-> Void) {
      let url = Self.docrDirURL.appendingPathComponent(docName)
      do {
       let data = try Data(contentsOf: url)
         completion(.success(data))
      } catch {
         completion(.failure(.readError))
      }
      
   }
   func docExist(named docName: String)-> Bool {
      return fileExists(atPath: Self.docrDirURL.appendingPathComponent(docName).path)
   }
}
