//
//  DetailViewController.swift
//  10272380-pset5
//
//  Created by Quinten van der Post on 29/11/2016.
//  Copyright © 2016 Quinten van der Post. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    let todoManager = TodoManager.sharedInstance
    var listIndex: Int?
    var listId: Int64?
    var list: TodoList? {
        didSet {
            self.configureView()
        }
    }

    func configureView() {
        // Update the user interface for the detail item.
//        if let detail = self.detailItem {
//            if let label = self.detailDescriptionLabel {
//                label.text = detail.description
//            }
//        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(insertNewObject(_:)))
        self.navigationItem.rightBarButtonItem = addButton
        self.configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func insertNewObject(_ sender: Any) {
        if list != nil {
            let alertController = UIAlertController(title: "New item", message: "Please provide a title for the item:", preferredStyle: .alert)
            var title = String()
            let confirmAction = UIAlertAction(title: "Confirm", style: .default) { (_) in
                if let field = alertController.textFields![0] as? UITextField {
                    // store your data
                    title = field.text!
                    self.todoManager.createItem(listId: self.listId!, title:    title, index: self.listIndex!)
                    self.tableView.reloadData()
                } else {
                    // user did not fill field
                    print("No input given!")
                }
            }
        
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)   { (_) in }
        
            alertController.addTextField { (textField) in
                textField.placeholder = "Title"
            }
        
            alertController.addAction(confirmAction)
            alertController.addAction(cancelAction)
        
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func todoCompletionTapped(cell: ItemCell) {
        //Get the indexpath of cell where button was tapped
        let itemId = cell.itemId
        do {
            try todoManager.setCompletion(itemId: itemId!)
            print("tried updating completion")
            tableView.reloadData()
        } catch  {
            print(error)
        }
    }


}

extension DetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let rows = list?.getList().count {
            return rows
        }
        else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell") as! ItemCell
        let itemList = list!.getList()
        let item = itemList[indexPath.row]
        let title = item.getTitle()
        let completion = item.getCompletion()
        let itemId = item.getItemId()
        let listId = item.getListId()
        
        cell.title.text = title
        cell.completion = completion
        cell.itemId = itemId
        cell.listId = listId
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let cell = tableView.cellForRow(at: indexPath) as! ItemCell
            let itemId = cell.itemId
            todoManager.deleteItem(itemId: itemId!, index: indexPath.row, listIndex: self.listIndex!)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
    
}









