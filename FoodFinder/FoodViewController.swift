//
//  FoodViewController.swift
//  FoodFinder
//
//  Created by Dillon on 4/14/17.
//  Copyright © 2017 Milan. All rights reserved.
//

import UIKit

class FoodViewController: UIViewController {

    @IBOutlet weak var foodName: UITextField!
    var name:String = ""
    
    @IBOutlet weak var locationTextView: UITextView!
    var location:String = ""
    
    @IBOutlet weak var foodImageView: UIImageView!
    var photo:String = ""
    
    @IBOutlet weak var addToFavoritesButton: UIButton!
    @IBAction func     addToFavoritesButton(_ sender: Any) {
        let favorites = FavoritesViewController()
        favorites.addToFavorite(t: name)
        showFavoritesAlert(addToFavoritesButton)
    }
    
    @IBOutlet weak var copyLocationButton: UIButton!
    @IBAction func     copyLocationButton(_ sender: Any) {
        UIPasteboard.general.string = location
        showLocationAlert(copyLocationButton)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        foodName.text = name
        locationTextView.text = location
        
        let task = loadPhoto()
        task.resume()
        
        
    }

    func setName(t:String) {
        name = t
        
        if isViewLoaded {
            foodName.text = t
        }
    }
    
    func setLocation(t:String) {
        location = t
        
        if isViewLoaded {
            locationTextView.text = t
        }
    }
    
    // photo ref to use in url download
    func setPhoto(t:String) {
        photo = t
        
    }
    
    // Loads the UIImageView withe passes photo
    func loadPhoto() -> URLSessionDataTask{
        
        let url = URL(string:"https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=\(photo)&key=AIzaSyBaqf7fNiIr26U7nWbXz5wblqgvjg-vaiY")
        
        
        let task = URLSession.shared.dataTask(with: url!) {(data,response,error) in
            
            if(error != nil) {
                
                print("Error: \(error!)")
                
            } else {
                
                let documentsDirectory = NSTemporaryDirectory() as String
                // print(temppath)
                
                let randomNum:UInt32 = arc4random_uniform(100)
                let someInt:Int = Int(randomNum)
                let imagename = someInt
                let savePath = documentsDirectory + "/" + "\(imagename)" + ".jpg"
                
                // save downloaded data
                FileManager.default.createFile(atPath: savePath, contents:data,attributes:nil)
                
                // print("path :::\(savePath)")
                
                DispatchQueue.main.async{ self.foodImageView.image = UIImage(named:savePath) }
            }
        }
        return task
    }
    
    @IBAction func showLocationAlert(_ sender: UIButton) {
        
        // create the alert
        let alert = UIAlertController(title: "Copied To Clipboard!", message: location, preferredStyle: UIAlertControllerStyle.alert)
        
        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func showFavoritesAlert(_ sender: UIButton) {
        
        // create the alert
        let alert = UIAlertController(title: "Added To Favorites!", message: name, preferredStyle: UIAlertControllerStyle.alert)
        
        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
