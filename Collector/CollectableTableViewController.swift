//
//  CollectableTableViewController.swift
//  Collector
//
//  Created by Dianna Carmalt on 5/21/19.
//  Copyright © 2019 Dianna Carmalt. All rights reserved.
//

import UIKit

class CollectableTableViewController: UITableViewController {
    
    var collectables : [Collectable] = []
    
    override func viewWillAppear(_ animated: Bool) {
        getCollectables()
    }
    
    func getCollectables() {
        if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
            if let collectables = try? context.fetch(Collectable.fetchRequest()) {
                if let theCollectables = collectables as? [Collectable] {
                    self.collectables = theCollectables
                    tableView.reloadData()
                }
            }
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return collectables.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        let collectable = collectables[indexPath.row]
        
        cell.textLabel?.text = collectable.title
        if let data = collectable.image  {
            cell.imageView?.image = UIImage(data: data)
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
                let collectable = collectables[indexPath.row]
                context.delete(collectable)
                (UIApplication.shared.delete as? AppDelegate)?.saveContext()
                getCollectables()
            }
        }
    }
}
