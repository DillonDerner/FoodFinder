//
//  HomeViewController.swift
//  FoodFinder
//
//  Created by Macbook  on 4/24/17.
//  Copyright © 2017 Milan. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var NearMeButton: UIButton!
    
    @IBOutlet weak var FavoritesButton: UIButton!
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NearMeButton.center.x -= view.bounds.width
        FavoritesButton.center.x += view.bounds.width
        
        UIView.animate(withDuration: 0.5, delay: 0.0, options: [],
                       animations: {
                        self.NearMeButton.center.x += self.view.bounds.width
        }, 
                       completion: nil
        )
        
        UIView.animate(withDuration: 0.5, delay: 0.2, options: [],
                       animations: {
                        self.FavoritesButton.center.x -= self.view.bounds.width
        }, 
                       completion: nil
        )

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
