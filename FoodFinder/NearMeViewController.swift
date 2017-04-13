//
//  NearMeViewController.swift
//  FoodFinder
//
//  Created by Milan on 4/3/17.
//  Copyright © 2017 Milan. All rights reserved.

import UIKit
import CoreLocation
import MapKit

class NearMeViewController: UIViewController,UITableViewDataSource,CLLocationManagerDelegate{

    @IBOutlet weak var restaurantsTable: UITableView!
    var restaurants = [NSDictionary]()
    var userLocation:CLLocation?
    
    let locationManager = CLLocationManager() // create instance of .
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        restaurantsTable.dataSource = self
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()

        
        
        
        
        let url = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=44.1680112%2C-93.9675153&radius=1200&type=restaurant&key=AIzaSyBaqf7fNiIr26U7nWbXz5wblqgvjg-vaiY"
        
        downloadRestaurants(urlString: url) {(array) ->() in
            self.restaurants = array as! [NSDictionary]
            self.restaurantsTable.reloadData()
        }
    }
    
    
    // geolocation of user
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return restaurants.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        
        // each restaurant's lat and long
        let geometry = restaurants[indexPath.row]["geometry"] as? [String: Any]
        let location = geometry?["location"] as? [String: Any]
        let restaurantLat = location?["lat"] as? Double
        let restaurantLong = location?["lng"] as? Double
        
        cell.textLabel!.text = restaurants[indexPath.row] ["name"] as? String
        cell.detailTextLabel!.text = getRestaurantDistance(lat: restaurantLat!, long: restaurantLong!)
        
        
        // cell.distanceLabel!.text = "distances"       create a label in prototype cell called distanceLabel
        
        
        
        return cell
    }
    
    func downloadRestaurants(urlString:String,completionHandler:@escaping (_ array:NSArray)-> ()){
        var restaurantsList = [NSDictionary]()
        let url = URL(string: urlString)
        let session = URLSession.shared
        let task = session.dataTask(with:url!) { (data, response, error) -> Void in
            
            do{
                let jsonDictionary = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as! NSDictionary
                let list = jsonDictionary["results"] as? [[String: AnyObject]]

                for restaurant in list! {
                    //let restaurantName = restaurant["name"] as? String
                    restaurantsList.append(restaurant as! NSDictionary)
                }
                
                DispatchQueue.main.async(execute: {
                    completionHandler(restaurantsList as NSArray)/// code goes here
                })
                
            }
            catch{
                print("invalid json format")
            }
        }
        task.resume()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {  // user's current location
    
        userLocation = locations[0]
    }
    
    
    func getRestaurantDistance(lat:Double,long:Double) -> String{  //returns distance between restaurant and user
        
        var distanceinkm:String?
        
        let restaurantLocation = CLLocation(latitude: lat, longitude: long)
        print(lat)
        print(long)
        var distance:CLLocationDistance?
        
        distance = userLocation?.distance(from: restaurantLocation)
        distanceinkm = String(describing: lat)     // just for test , put describing:distance later
        print(distance)
        return distanceinkm!
        
    }
    
    // Takes an array of Restauraunts and returns a random restaurant name.
    func getRandomRestaurant(restaurantList: Array<Any>) -> String{
        let randomName : String = {
            let randomIndex = Int(arc4random_uniform(UInt32(restaurantList.count)))
            return restaurantList[randomIndex] as! String
        }()
        return randomName
    }
}

