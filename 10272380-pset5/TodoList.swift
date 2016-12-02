//
//  TodoList.swift
//  10272380-pset5
//
//  Created by Quinten van der Post on 29/11/2016.
//  Copyright © 2016 Quinten van der Post. All rights reserved.
//

import Foundation

class TodoList {
    
    private var list = Array<TodoItem>()
    private let title: String?
    private let id: Int64?
    
    init(title: String, id: Int64) {
        self.title = title
        self.id = id
    }
    
    // Add Todo to itemlist
    func addItem(element: TodoItem) {
        
        self.list.append(element)
    }
    
    func deleteItem(index: Int) {
        
        self.list.remove(at: index)
    }
    
    func getListId() -> Int64 {
        
        return self.id!
    }
    
    func getTitle() -> String {
        
        return self.title!
    }
    
    func getList() -> Array<TodoItem> {
        
        return self.list
    }
    
}
