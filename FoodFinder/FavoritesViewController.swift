//
//  FavoritesViewController.swift
//  FoodFinder
//
//  Created by Dillon on 4/12/17.
//  Copyright © 2017 Milan. All rights reserved.
//

import UIKit

class FavoritesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var table: UITableView!
    
    var data:[String] = []
    var backButton:UIBarButtonItem? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Favorites"
        
        backButton = self.navigationItem.leftBarButtonItem
        self.navigationItem.rightBarButtonItem = editButtonItem
        
        load()
    }
    
    func addToFavorite(t: String) {
        if let loadedData = UserDefaults.standard.value(forKey: "notes") as? [String] {
            data = loadedData
        }
        data.append(t)
        save()
    }
    
    
    func addFavorite() {
        let name:String = "Food \(data.count + 1)"
        data.insert(name, at: 0)
        let indexPath:IndexPath = IndexPath(row: 0, section: 0)
        table.insertRows(at: [indexPath], with: .automatic)
        save()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        cell.textLabel?.text = data[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        data.remove(at: indexPath.row)
        table.deleteRows(at: [indexPath], with: .fade)
        save()
    }
    
    // Runs when Edit button is pushed
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        table.setEditing(editing, animated: animated)
        
        // change the left navigation button to + or < back
        if(editing){
            let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addFavorite))
            self.navigationItem.leftBarButtonItem = addButton
        }
        else{
            self.navigationItem.leftBarButtonItem = backButton
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("\(data[indexPath.row])")
    }
    
    
    func save() {
        UserDefaults.standard.setValue(data, forKey: "notes")
        UserDefaults.standard.synchronize()
    }
    
    func load() {
        if let loadedData = UserDefaults.standard.value(forKey: "notes") as? [String] {
            data = loadedData
            table.reloadData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // Takes an array of Restauraunts and returns a random restaurant name.
    func getRandomRestaurant(restaurantList: Array<Any>) -> String {
        let randomName : String = {
            let randomIndex = Int(arc4random_uniform(UInt32(restaurantList.count)))
            return restaurantList[randomIndex] as! String
        }()
        return randomName
    }
}
