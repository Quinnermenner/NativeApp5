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
        self.list = todoManager.getItemList(listIndex: listIndex!)
        self.configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func insertNewObject(_ sender: Any) {
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
    
    func todoCompletionTapped(cell: ItemCell) {
        //Get the indexpath of cell where button was tapped
        let indexPath = self.tableView.indexPath(for: cell)
        let itemId = cell.itemId
        do {
            try todoManager.setCompletion(itemId: itemId!, listIndex: listIndex!, index: (indexPath?.row)!)
            tableView.reloadData()
            
            tableView.reloadRows(at: [indexPath!], with: .none)
        } catch  {
            print(error)
        }
    }


}

extension DetailViewController: UITableViewDelegate, UITableViewDataSource, ItemCellDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return todoManager.getItemList(listIndex: listIndex!).getItemCount()

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell") as! ItemCell
        let itemList = todoManager.getItemList(listIndex: listIndex!).getList()
        let item = itemList[indexPath.row]
        let title = item.getTitle()
        let completion = item.getCompletion()
        let itemId = item.getItemId()
        let listId = item.getListId()
        
        cell.title.text = title
        cell.completion = completion
        cell.itemId = itemId
        cell.listId = listId
        cell.delegate = self
        
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









