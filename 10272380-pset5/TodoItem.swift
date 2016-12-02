//
//  TodoItem.swift
//  10272380-pset5
//
//  Created by Quinten van der Post on 29/11/2016.
//  Copyright © 2016 Quinten van der Post. All rights reserved.
//

import Foundation

class TodoItem {
    
    private let title: String?
    private let completion: Bool?
    private let listId: Int64?
    private let itemId: Int64?
    
    init(title: String, completion: Bool, listId: Int64, itemId: Int64) {
        self.title = title
        self.completion = completion
        self.listId = listId
        self.itemId = itemId
    }
    
    func getTitle() -> String {
        
        return self.title!
    }
    
    func getCompletion() -> Bool {
        
        return self.completion!
    }
    
    func getItemId() -> Int64 {
        
        return self.itemId!
    }
    
    func getListId() -> Int64 {
        
        return self.listId!
    }
    
}
