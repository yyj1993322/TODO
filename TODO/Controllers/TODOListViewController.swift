//
//  ViewController.swift
//  TODO
//
//  Created by 南继云 on 2020/12/23.
//

import UIKit

class TODOListViewController: UITableViewController {
    
    let defaults = UserDefaults.standard
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    var itemArray = [Item]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
//        if let items = defaults.array(forKey: "ToDoListArray") as? [String] {
//            itemArray = items
//        }
        
//        let newItem = Item()
//        newItem.title = "吃药"
//        itemArray.append(newItem)
//        for index in 4...120{
//            let newItem = Item()
//            newItem.title = "第\(index)条事务"
//            itemArray.append(newItem)
//        }
        print(dataFilePath!)
        loadData()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row].title
//        if itemArray[indexPath.row].done == false {
//            cell.accessoryType = .none
//        }else {
//            cell.accessoryType = .checkmark
//        }
        cell.accessoryType = itemArray[indexPath.row].done == true ? .checkmark : .none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(itemArray[indexPath.row])
//        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
//            tableView.cellForRow(at: indexPath)?.accessoryType = .none
//        }else {
//            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
//        }
        if itemArray[indexPath.row].done == false {
            itemArray[indexPath.row].done = true
        }else {
            itemArray[indexPath.row].done = false
        }
        tableView.beginUpdates()
        tableView.reloadRows(at: [indexPath], with: UITableView.RowAnimation.none)
        tableView.endUpdates()
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        saveItems()
        tableView.deselectRow(at: indexPath, animated: true)
    }

    @IBAction func addButtonPressed(_ sender: Any) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "add new ?", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "add", style: .default){
            (action) in
            //当用户单击添加项目按钮以后要执行的代码
            let newItem = Item()
            newItem.title = textField.text!
            self.itemArray.append(newItem)
            self.saveItems()
            //self.defaults.set(self.itemArray, forKey: "ToDoListArray")
            self.tableView.reloadData()
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
        let encoder = PropertyListEncoder()
        do{
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        }catch{
            print("编码错误\(error)")
        }
    }
    
    func loadData() {
    if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
        do{
            itemArray = try decoder.decode([Item].self, from: data)
        }catch {
            print("解码item错误")
        }
      }
    }
}

