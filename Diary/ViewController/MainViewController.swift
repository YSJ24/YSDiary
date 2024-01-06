//
//  MainViewController.swift
//  Diary
//
//  Created by Yeseul Jang on 2023/08/30.
//

import UIKit

final class MainViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var sample: [Sample] = []
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private var items: [Item] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerNib()
        tableView.rowHeight = 55
        tableView.dataSource = self
        tableView.delegate = self
        decodeJSON()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(tapAddButton))
        saveSampleData()
        getAllItems()
    }
    

    @objc func tapAddButton() {
        guard let NewDetailViewController = self.storyboard?.instantiateViewController(identifier: "DetailViewController", creator: {coder in DetailViewController(item: nil, coder: coder)}) else { return }
        
        self.navigationController?.pushViewController(NewDetailViewController, animated: true)
    }
    
    private func registerNib() {
        tableView.register(UINib(nibName: "DiaryTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
    }
    
    private func decodeJSON() {
        let jsonDecoder = JSONDecoder()
        guard let dataAsset = NSDataAsset(name: "sample") else { return }

        do {
            self.sample = try jsonDecoder.decode([Sample].self, from: dataAsset.data)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func saveSampleData() {
        for item in sample {
            createItem(itemTitle: item.title, itemBody: item.body)
        }
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? DiaryTableViewCell else {
            return UITableViewCell()
        }
        
        let item = items[indexPath.row]
        cell.configureLabel(item: item)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = self.items[indexPath.row]
        guard let detailViewController = self.storyboard?.instantiateViewController(identifier: "DetailViewController", creator: {coder in DetailViewController(item: item, coder: coder)}) else { return }
        
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }
}

extension MainViewController {
    func getAllItems() {
        do {
            items = try context.fetch(Item.fetchRequest())
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } catch {
            print(error.localizedDescription)
        }
    }

    func createItem(itemTitle: String, itemBody: String) {
        let newItem = Item(context: context)
        newItem.itemTitle = itemTitle
        newItem.itemBody = itemBody
        newItem.itemCreatedDate = Date()
        
        do {
            try context.save()
            getAllItems()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func deleteItem(item: Item) {
        context.delete(item)
        
        do {
            try context.save()
            getAllItems()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func deleteAllItem(items: [Item]) {
        for item in items {
            context.delete(item)
        }
        do {
            try context.save()
            getAllItems()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func updateItem(item: Item, newItemTitle: String, newItemBody: String) {
        item.itemTitle = newItemTitle
        item.itemBody = newItemBody
        
        do {
            try context.save()
            getAllItems()
        } catch {
            print(error.localizedDescription)
        }
    }
}
