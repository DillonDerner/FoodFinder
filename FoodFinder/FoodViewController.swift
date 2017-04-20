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
    @IBAction func addToFavoritesButton(_ sender: Any) {
        let favorites = FavoritesViewController()
        favorites.addToFavorite(t: name)
    }
    
    @IBAction func copyLocationButton(_ sender: Any) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        foodName.text = name
        locationTextView.text = location
        
        let url = URL(string:"https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=\(photo)&key=AIzaSyBaqf7fNiIr26U7nWbXz5wblqgvjg-vaiY")
    
        
        let task = URLSession.shared.dataTask(with: url!) {(data,response,error) in
            
            if(error != nil)
            {
                print("Error")
            }
            else
            {
              
                //var documentsDirectory:String?
               // var paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
            let documentsDirectory = NSTemporaryDirectory() as 	String
               // print(temppath)
            
                //    documentsDirectory = paths[0]
                let randomNum:UInt32 = arc4random_uniform(100)
                let someInt:Int = Int(randomNum)
                let imagename = someInt
                let savePath = documentsDirectory + "/" + "\(imagename)" + ".jpg"
                
                FileManager.default.createFile(atPath: savePath, contents:data,attributes:nil) // save downloaded data
                print("path :::\(savePath)")
                DispatchQueue.main.async{
                self.foodImageView.image = UIImage(named:savePath)
                    
                
            }
            }
        }
        
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
    
    func setPhoto(t:String){
        photo = t  // photo ref to use in url download
        
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
