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
