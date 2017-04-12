//
//  ViewController.swift
//  FoodFinder
//
//  Created by Milan on 4/3/17.
//  Copyright © 2017 Milan. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITableViewDataSource {

    @IBOutlet weak var restaurantsTable: UITableView!
    var restaurants = [NSDictionary]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        restaurantsTable.dataSource = self
        
        let url = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=44.1680112%2C-93.9675153&radius=1200&type=restaurant&key=AIzaSyBaqf7fNiIr26U7nWbXz5wblqgvjg-vaiY"
        downloadRestaurants(urlString: url) {(array) ->() in
            self.restaurants = array as! [NSDictionary]
            self.restaurantsTable.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return restaurants.count
    }
    
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel!.text = restaurants[indexPath.row] ["name"] as? String
        return cell
        
    }
    func downloadRestaurants(urlString:String,completionHandler:@escaping (_ array:NSArray)-> ()){
        
        var restaurantsList = [NSDictionary]()
        let url = URL(string: urlString)
        let session = URLSession.shared
        let task = session.dataTask(with:url!) { (data, response, error) -> Void in
            
            do{
                let jsonDictionary = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as! NSDictionary
                //print(jsonDictionary)
                let list = jsonDictionary["results"] as? [[String: AnyObject]]

                for restaurant in list! {
                    
                    let restaurantName = restaurant["name"] as? String
                    restaurantsList.append(restaurant as! NSDictionary)
                                   }
                
                DispatchQueue.main.async(execute: {
                    completionHandler(restaurantsList as NSArray)/// code goes here
                })
                
                
            } catch {
                print("invalid json format")
            }
        } //task
        task.resume()
    }
}

