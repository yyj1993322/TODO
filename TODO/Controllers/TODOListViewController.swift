//
//  ViewController.swift
//  TODO
//
//  Created by 南继云 on 2020/12/23.
//

import UIKit
import CoreData
import RealmSwift
import SwipeCellKit


class TODOListViewController: UITableViewController {
    
    
    let defaults = UserDefaults.standard
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    let realm = try! Realm()
    
    var todoItems: Results<Item>?
    
    var selectedCategory: Category? {
        didSet {
            loadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
//        if let items = defaults.array(forKey: "ToDoListArray") as? [String] {
//            todoItems = items
//        }
        
//        let newItem = Item()
//        newItem.title = "吃药"
//        todoItems.append(newItem)
//        for index in 4...120{
//            let newItem = Item()
//            newItem.title = "第\(index)条事务"
//            todoItems.append(newItem)
//        }
//        print(dataFilePath!)
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
//        loadData()
        tableView.rowHeight = 80.0
        tableView.separatorStyle = .none
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if let colourHex = selectedCategory?.colour {
            title = selectedCategory!.name
            guard let navBar = navigationController?.navigationBar else {
                fatalError("导航栏不存在！")
            }
            //navBar.barTintColor = UIColor(hexString: colourHex)
            if let navBarColor = UIColor(hexString: colourHex) {
                navBar.barTintColor = navBarColor
                //navBar.tintColor = ContrastColorOf(navBarColor, returnFlat: true)
                //searchBar.barTintColor = navBarColor
                
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath) as! SwipeTableViewCell
        cell.delegate = self
//        cell.textLabel?.text = todoItems[indexPath.row].title
//        if todoItems[indexPath.row].done == false {
//            cell.accessoryType = .none
//        }else {
//            cell.accessoryType = .checkmark
//        }
//        cell.accessoryType = todoItems[indexPath.row].done == true ? .checkmark : .none
        if let item = todoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done == true ? .checkmark : .none
            //设置单元格背景色
            if let colour = UIColor(hexString: selectedCategory!.colour)?
                .darken(byPercentage: CGFloat(indexPath.row) / CGFloat(todoItems!.count)) {
                cell.backgroundColor = colour
                //调整对比度，由于第三方不兼容所以不写
            }
            
        }else {
            cell.textLabel?.text = "没有事项"
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write{
                    item.done = !item.done
                }
            } catch {
                print("保存完成状态失败: \(error)")
            }
        }
        tableView.beginUpdates()
        tableView.reloadRows(at: [indexPath], with: UITableView.RowAnimation.none)
        tableView.endUpdates()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }

    @IBAction func addButtonPressed(_ sender: Any) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "add new ?", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "add", style: .default){
            (action) in
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write{
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.done = false
                        newItem.dateCreated = Date() //返回当前时间
                        currentCategory.items.append(newItem)
                        
                    }
                } catch {
                    print("保存Items错误：\(error)")
                }
            }
        }
        let action2 = UIAlertAction(title: "no", style: .cancel, handler: nil)
        
        alert.addTextField{
            (alertTextField) in
            alertTextField.placeholder = "add one project"
            textField = alertTextField
        }
        
        alert.addAction(action)
        alert.addAction(action2)
        present(alert, animated: true, completion: nil)
        
    }
    
    func saveItems() {
//        let encoder = PropertyListEncoder()
        do{
//            let data = try encoder.encode(todoItems)
//            try data.write(to: dataFilePath!)
//            try context.save()
            
            
        }catch{
//            print("编码错误\(error)")
            print("保存context,错误\(error)")
        }
        tableView.reloadData()
    }
    
    func loadData() {
//    if let data = try? Data(contentsOf: dataFilePath!) {
//            let decoder = PropertyListDecoder()
//        do{
//            todoItems = try decoder.decode([Item].self, from: data)
//        }catch {
//            print("解码item错误")
//        }
//      }
//        let request: NSFetchRequest<Item> = Item.fetchRequest()

//        let predicate = NSPredicate(format: "parentCategory.name MATCHES %@",selectedCategory!.name!)
//        request.predicate = predicate

//        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name)
////        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, predicate])
////        request.predicate = compoundPredicate
//        if let addtionalPredicate = predicate {
//            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, addtionalPredicate])
//        }else {
//            request.predicate = categoryPredicate
//        }
//
//        do {
//        todoItems = try context.fetch(request)
//        }catch {
//            print("context获取数据错误：\(error)")
//        }
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
    
    
    
    
    
}


extension TODOListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        todoItems = todoItems?.filter("title CONTAINS[c] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: false)
        tableView.reloadData()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadData()
            DispatchQueue.main.async {//获取主线程，async指明主线程和后台线程一起并行执行任务
                searchBar.resignFirstResponder()
            }
        }
    }
}

extension TODOListViewController: SwipeTableViewCellDelegate {
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else {
            return nil
        }
        let deleteAction = SwipeAction(style: .destructive, title: "删除") {
            action,indexPath in
            if let itemForDeletion = self.todoItems?[indexPath.row] {
                do {
                    try self.realm.write {
                        self.realm.delete(itemForDeletion)
                    }
                } catch {
                    print("删除TodoItem失败:\(error)")
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
