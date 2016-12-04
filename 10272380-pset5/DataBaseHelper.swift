//
//  DataBaseHelper.swift
//  10272380-pset4
//
//  Created by Quinten van der Post on 22/11/2016.
//  Copyright © 2016 Quinten van der Post. All rights reserved.
//

import Foundation
import SQLite

class DataBaseHelper {
    
    private let TodoListTable = Table("todolist")
    private let TodoItemsTable = Table("todoitems")
    
    private let id = Expression<Int64>("id")
    private let listId = Expression<Int64>("listid")
    private let title = Expression<String>("title")
    private let completion = Expression<Bool>("completion")

    
    private var db: Connection?
    
    init?() {
        do {
            try setupDatabase()
        } catch {
            print(error)
            return nil
        }
    }
    
    private func setupDatabase() throws {
        
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        
        do {
            db = try Connection("\(path)/db.sqlite3")
            try createTable()
        } catch {
            throw error
        }
    }
    
    private func createTable() throws {
        
        do {
            try db!.run(TodoListTable.create(ifNotExists: true) {
                table in
                
                table.column(id, primaryKey: .autoincrement)
                table.column(title)
                
            })
            try db!.run(TodoItemsTable.create(ifNotExists: true){
                table in
                
                table.column(id, primaryKey: .autoincrement)
                table.column(listId)
                table.column(title)
                table.column(completion)
            })
        } catch {
            throw error
        }
    }
    
    func createList(title: String) throws -> Int64 {
        
        let insert = TodoListTable.insert(self.title <- title)
        
        do {
            let rowId = try db!.run(insert)
            print("Inserted at \(rowId)")
            return rowId
        } catch {
            throw error
        }
    }
    
    func createItem(title: String, completion: Bool, listId: Int64) throws -> Int64 {
        
        let insert = TodoItemsTable.insert(self.title <- title, self.completion <- completion, self.listId <- listId)
        
        do {
            let rowId = try db!.run(insert)
            print("Inserted at \(rowId)")
            return rowId
        } catch {
            throw error
        }
    }
    
    func readList() throws -> [[String: Any]]? {
        
        do {
            var result = [[String: Any]]()
            
            for list in try db!.prepare(TodoListTable) {
                let itemList = [
                    "title" : list[title],
                    "id" : list[id]
                ] as [String: Any]
                result.append(itemList)
            }
            return result
        } catch {
            throw error
        }
    }
    
    func readItems(listIndex: Int64) throws -> [[String: Any]]? {
        do {
            let query = TodoItemsTable.filter(listId == listIndex)
            var result = [[String: Any]]()
            
            for item in try db!.prepare(query) {
                let details = [
                    "title" : item[title],
                    "completion" : item[completion],
                    "id" : item[id],
                    "listid" : item[listId]
                ] as [String: Any]
                result.append(details)
            }
            return result
        } catch  {
            throw error
        }
    }
    
    func countRows(table: Table) throws -> Int? {
        let count = try db?.scalar(table.count)
        
        return count
    }
    
    func deleteItem(index: Int64) throws {
        
        do {
            let deletion = TodoItemsTable.filter(id == index)
            
            if try db!.run(deletion.delete()) > 0 {
                print("Deletion successfull")
            }
        } catch {
            throw error
        }
    }
    
    func deleteList(listIndex: Int64) throws {
        
        do {
            let itemDeletion = TodoItemsTable.filter(listId == listIndex)
            if try db!.run(itemDeletion.delete()) > 0 {
                print("Deletion of items successfull")
            }
            let listDeletion = TodoListTable.filter(id == listIndex)
            if try db!.run(listDeletion.delete()) > 0 {
                print("Deletion of list successfull")
            }
        } catch {
            throw error
        }
    }

    func updateCompletion(itemId: Int64) throws {
        do {
            let todoItem = TodoItemsTable.filter(id == itemId)
            
            for completionCheck in try db!.prepare(todoItem) {
                if completionCheck[completion] == false {
                    if try db!.run(todoItem.update(self.completion <- true)) > 0 {
                        print("Updated completion to true")
                    }
                }
                else {
                    if try db!.run(todoItem.update(self.completion <- false)) > 0 {
                        print("Updated completion to false")
                    }
                }
            }
        } catch{
            throw error
        }
    }
    
}







