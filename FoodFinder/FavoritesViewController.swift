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
    
    @IBOutlet weak var colorWheelImage: UIImageView!
    
    
    var data:[String] = []
    
    var foodMessage:[String] = [
        "Spin Again?",
        "Yumm!",
        "YES!",
        "Maybe next time..",
        "That's a restaurant!",
        "Ewww",
        "What is that?",
        "Ice Cream Anyone?",
        "I'm Buying!",
        "Hot Dog!",
        "...",
        "Not today...",
        "Spin Again Please!",
        "Spin! Spin! Spin!",
        "Tastes like chicken",
        "WOW!"
    ]
    
    var backButton:UIBarButtonItem? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Favorites"
        chooseForMeButton.center.y += self.view.bounds.width
        
        backButton = self.navigationItem.leftBarButtonItem
        self.navigationItem.rightBarButtonItem = editButtonItem
        
        load()
        
        UIView.animate(withDuration: 0.5, delay: 0.0, options: [],
                       animations: {
                        self.chooseForMeButton.center.y -= self.view.bounds.width
        },
                       completion: nil
        )
        
    }
    
    @IBOutlet weak var chooseForMeButton: UIButton!
    
    @IBAction func chooseForMeButton(_ sender: Any) {
        self.colorWheelImage.isHidden = false
        self.chooseForMeButton.isEnabled = false
        
        UIView.animate(
            withDuration: 2,
            delay: 0,
            animations: ({
                let diceRoll = Int(arc4random_uniform(6) + 1)
                
                for _ in 1...diceRoll {
                    self.colorWheelImage.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
                    self.colorWheelImage.transform = CGAffineTransform(rotationAngle: CGFloat.pi * 2)
                }
            }),
            completion: { (finished:Bool) in
                self.colorWheelImage.isHidden = true
                self.chooseForMeButton.isEnabled = true
                self.showRandomAlert(self.chooseForMeButton)
            }
        )
    }
    
    // Presets the user with a popup showing the random restaurant we selected for them
    @IBAction func showRandomAlert(_ sender: UIButton) {
        
        // choose a randome restaurant and display message
        let randomFoodNumber    = Int(arc4random_uniform(UInt32(data.count)))
        let randomMessageNumber = Int(arc4random_uniform(UInt32(self.foodMessage.count)))
        
        // create the alert
        let alert = UIAlertController(title: data[randomFoodNumber], message: "", preferredStyle: UIAlertControllerStyle.alert)
        
        // add an action (button)
        alert.addAction(UIAlertAction(title: self.foodMessage[randomMessageNumber], style: UIAlertActionStyle.default, handler: nil))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
    
    
    // Presents the user with a popup to add a new Favorite
    func showAddButtonAlert() {
        var response:String = ""
        
        let alertController = UIAlertController(title: "Add New Favorite", message: "", preferredStyle: UIAlertControllerStyle.alert)
        
        let saveAction = UIAlertAction(title: "Save", style: UIAlertActionStyle.default, handler: {
            alert -> Void in
            
            let firstTextField = alertController.textFields![0] as UITextField
            
            if(firstTextField.text != nil) {
                response = firstTextField.text!
            }
            
            self.data.insert(response, at: 0)
            let indexPath:IndexPath = IndexPath(row: 0, section: 0)
            self.table.insertRows(at: [indexPath], with: .automatic)
            self.save()
            
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: {
            (action : UIAlertAction!) -> Void in
            
        })
        
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Enter First Name"
        }
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
        
    }

    
    // !Used by external Views to Add to the Favorites list!
    func addToFavorite(t: String) {
        if let loadedData = UserDefaults.standard.value(forKey: "notes") as? [String] {
            data = loadedData
        }
        data.append(t)
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
    
    // animation for the UITableView
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.alpha = 0
        let transform = CATransform3DTranslate(CATransform3DIdentity, -100, 20, 0)
        cell.layer.transform = transform
            
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseOut,
                       animations: {
                        cell.alpha = 1.0
                        cell.layer.transform = CATransform3DIdentity
        },
                       completion: nil
        )
        
    }
    
    
    // Runs when Edit button is pushed
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        table.setEditing(editing, animated: animated)
        
        // change the left navigation button to + or < back
        if(editing){
            let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showAddButtonAlert))
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
    
    // Deletes the whole favorites list
    func clearFavorites() {
        if let loadedData = UserDefaults.standard.value(forKey: "notes") as? [String] {
            data = loadedData
            data = []
            save()
        }
    }
}
