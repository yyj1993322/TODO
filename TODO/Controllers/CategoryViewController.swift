//
//  CategoryViewController.swift
//  TODO
//
//  Created by 南继云 on 2020/12/28.
//

import UIKit
import CoreData
import RealmSwift
import SwipeCellKit

class CategoryViewController: UITableViewController {

    let realm = try! Realm()
    
    var categories: Results<Category>?
    
//    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 80.0
        loadCategories()
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "添加新的类别", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "添加", style: .default, handler: {
            (action) in
//            let newCategory = MyCategory(context: self.context)
            let newCategory = Category()
            newCategory.name = textField.text!
//            self.categories.append(newCategory)
            self.save(category: newCategory)
        })
        alert.addAction(action)
        alert.addTextField {
            (field) in
            textField = field
            textField.placeholder = "添加一个新类别"
        }
        present(alert, animated: true, completion: nil)
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as! SwipeTableViewCell
        cell.delegate = self
        cell.textLabel!.text = categories?[indexPath.row].name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TODOListViewController
        
        if segue.identifier == "goToItems" {
            if let indexPatch = tableView.indexPathForSelectedRow {
                destinationVC.selectedCategory = categories?[indexPatch.row]
            }
        }
    }
    
    func save(category: Category) {
        do {
//            try context.save()
                try realm.write{
                realm.add(category)
            }
        } catch{
            print("保存Category错误：\(error)")
        }
    }
    
    func loadCategories() {
//        let request :NSFetchRequest<MyCategory> = MyCategory.fetchRequest()
//        do {
//          categories = try context.fetch(request)
//        } catch{
//            print("载入Category 错误 \(error)")
//        }
        
        categories = realm.objects(Category.self)
        tableView.reloadData()
    }

}

extension CategoryViewController: SwipeTableViewCellDelegate {
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else {
            return nil
        }
        let deleteAction = SwipeAction(style: .destructive, title: "删除"){
            action,index in
            if let categoryForDeletion = self.categories?[indexPath.row] {
                do {
                    try self.realm.write {
                        self.realm.delete(categoryForDeletion)
                    }
                } catch {
                    print("删除类别失败: \(error)")
                }
            }
        }
        deleteAction.image = UIImage(named: "Trash-Icon")
        return [deleteAction] 
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
            options.expansionStyle = .destructive
            options.transitionStyle = .border
            return options
    }
}
