//
//  TodoManager.swift
//  10272380-pset5
//
//  Created by Quinten van der Post on 29/11/2016.
//  Copyright © 2016 Quinten van der Post. All rights reserved.
//

import Foundation

class TodoManager {
    
    static let sharedInstance = TodoManager()
    private var TodoListList = Array<TodoList>()
    private let db = DataBaseHelper()
    
    private init () {
        do {
            try readDBList()
            try readDBItems()
        } catch  {
            print(error)
        }
    }
    
    func readDBList() throws {
        
        do {
            let listDict = try db?.readList()
            for list in listDict! {
                let title = list["title"] as! String
                let id = list["id"] as! Int64
                let todoList = TodoList(title: title, id: id)
                TodoListList.append(todoList)
            }

        } catch  {
            throw error
        }
    }
    
    func readDBItems() throws {
        do {
             for list in TodoListList {
                let id = list.getListId()
                let itemDict = try db?.readItems(listIndex: id)
                for item in itemDict! {
                    let title = item["title"] as! String
                    let completion = item["completion"] as! Bool
                    let listId = item["listid"] as! Int64
                    let itemId = item["id"] as! Int64
                    
                    let todoItem = TodoItem(title: title, completion: completion, listId: listId, itemId: itemId)
                    list.addItem(element: todoItem)
                }
            }
        } catch  {
            throw error
        }

    }
    
    func createList(title: String) {
        
        do {
            let id = try db?.createList(title: title)
            let list = TodoList(title: title, id: id!)
            self.TodoListList.append(list)
            
        } catch  {
            print(error)
        }
    }
    
    func createItem(listId: Int64, title: String, index: Int) {
        
        do {
            let id = try db?.createItem(title: title, completion: false, listId: listId)
            let item = TodoItem(title: title, completion: false, listId: listId, itemId: id!)
            self.TodoListList[index].addItem(element: item)
        } catch  {
            print(error)
        }
    }
    
    func deleteItem(itemId: Int64, index: Int, listIndex: Int) {
    
        do {
            try db?.deleteItem(index: itemId)
            self.TodoListList[listIndex].deleteItem(index: index)
            
        } catch  {
            print(error)
        }
    }
    
    func deleteList(listId: Int64, index: Int) {
        
        do {
            try db?.deleteList(listIndex: listId)
            self.TodoListList.remove(at: index)
            
        } catch  {
            print(error)
        }
    }
    
    func getList() -> [[String: Any]] {
    
        var listList = [[String: Any]]()
        for list in TodoListList {
            let title = list.getTitle()
            let listId = list.getListId()
            let listDict = [
                "title" : title,
                "listId" : listId
            ] as [String : Any]
            listList.append(listDict)
        }
        return listList
    }
    
    func getItems(listIndex: Int) -> [[String: Any]] {
    
        var listItems = [[String: Any]]()
        for item in self.TodoListList[listIndex].getList() {
            
            let title = item.getTitle()
            let completion = item.getCompletion()
            let itemId = item.getItemId()
            let listId = item.getListId()
            let itemDict = [
                "title" : title,
                "completion" : completion,
                "itemid" : itemId,
                "listid" : listId
            ] as [String : Any]
            listItems.append(itemDict)
        }
        return listItems
    }
    
    func getItemList(listIndex: Int) -> TodoList {
        
        return self.TodoListList[listIndex]
    }
    
    func setCompletion(itemId: Int64) throws {
        do {
            try db?.updateCompletion(itemId: itemId)
            print("tried to set completion")
        } catch  {
            throw error
        }
        
    }
}












