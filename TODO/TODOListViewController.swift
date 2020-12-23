//
//  ViewController.swift
//  TODO
//
//  Created by 南继云 on 2020/12/23.
//

import UIKit

class TODOListViewController: UITableViewController {
    
    var itemArray = ["购买水杯","吃药","修改密码"]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(itemArray[indexPath.row])
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }

    @IBAction func addButtonPressed(_ sender: Any) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "add new ?", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "add", style: .default){
            (action) in
            //当用户单击添加项目按钮以后要执行的代码
            self.itemArray.append(textField.text!)
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
}

