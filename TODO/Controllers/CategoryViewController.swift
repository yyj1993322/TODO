//
//  CategoryViewController.swift
//  TODO
//
//  Created by 南继云 on 2020/12/28.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    var categories = [MyCategory]()
    
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "添加新的类别", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "添加", style: .default, handler: {
            (action) in
            let newCategory = MyCategory(context: self.context)
            newCategory.name = textField.text!
            self.categories.append(newCategory)
            self.saveCategory()
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
        categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel!.text = categories[indexPath.row].name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TODOListViewController
        
        if segue.identifier == "goToItems" {
            if let indexPatch = tableView.indexPathForSelectedRow {
                destinationVC.selectedCategory = categories[indexPatch.row]
            }
        }
    }
    
    func saveCategory() {
        do {
            try context.save()
        } catch{
            print("保存Category错误：\(error)")
        }
    }
    
    func loadCategories() {
        let request :NSFetchRequest<MyCategory> = MyCategory.fetchRequest()
        do {
          categories = try context.fetch(request)
        } catch{
            print("载入Category 错误 \(error)")
        }
    }

}
