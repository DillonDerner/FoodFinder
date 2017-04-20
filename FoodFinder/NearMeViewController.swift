//
//  NearMeViewController.swift
//  FoodFinder
//
//  Created by Milan on 4/3/17.
//  Copyright © 2017 Milan. All rights reserved.

import UIKit
import CoreLocation
import MapKit

class NearMeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate{

    @IBOutlet weak var restaurantsTable: UITableView!
    
    @IBOutlet weak var distanceTextBox: UITextField!
    @IBOutlet weak var distanceDropdown: UIPickerView!
    
    @IBOutlet weak var distanceImage: UIImageView!
    
    // Distance in Meters
    var distanceList = ["1200", "2400", "3600", "4800", "6000", "12000", "24000", "36000", "48000", "60000"]
    
    // Distance in Miles
    var distanceListMiles = ["1","2","3","4","5","10","20","30","40","50"]
    
    var miles:Bool? = false
    
    var selectedRow = -1
    
    var restaurants = [NSDictionary]()
    let locationManager = CLLocationManager()
    var userLocation:CLLocation?
    
    // Loads ViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        
        load()
        switchDistance()
        
    
    }
    
    // Handles what has been set in the Settings View
    func switchDistance() {

        // Miles
        if(miles!) {
            self.distanceImage.image = #imageLiteral(resourceName: "Miles")
            loadRestaurants(radius: "1200")
            self.distanceTextBox.text = "1"

        // Kilometers
        } else {
            self.distanceImage.image = #imageLiteral(resourceName: "Km")
            loadRestaurants(radius: "1200")
            self.distanceTextBox.text = "1200"
        }
    }

    // assigns distance type from memory to miles:Bool
    func load() {
        
        if let loadedData = UserDefaults.standard.value(forKey: "distanceType") as? Bool {
            miles = loadedData
        }
    }
    
    // Built-in function
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // Returns a count of nearby restaurants
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return restaurants.count
    }
    
    // Populates data about each restaurant
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        // Each restaurant's lat and long
        let geometry = restaurants[indexPath.row]["geometry"] as? [String: Any]
        let location = geometry?["location"] as? [String: Any]
        let restaurantLat = location?["lat"] as? Double
        let restaurantLong = location?["lng"] as? Double
        
        // Populates each cell with Name and Distance from our user
        cell.textLabel!.text = restaurants[indexPath.row] ["name"] as? String
        cell.detailTextLabel!.text = getRestaurantDistance(lat: restaurantLat!, long: restaurantLong!)

        return cell
    }
    
    // This function gets called when a table row is selected
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "detail", sender: nil)
    }
    
    // Populates restaurantList using the maps api and json file
    func downloadRestaurants(urlString:String,completionHandler:@escaping (_ array:NSArray)-> ()){
        var restaurantsList = [NSDictionary]()
        let url = URL(string: urlString)
        let session = URLSession.shared
        let task = session.dataTask(with:url!) { (data, response, error) -> Void in
            
            do{
                let jsonDictionary = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as! NSDictionary
                let list = jsonDictionary["results"] as? [[String: AnyObject]]

                for restaurant in list! {
                    restaurantsList.append(restaurant as! NSDictionary)
                }
                
                DispatchQueue.main.async(execute: {
                    completionHandler(restaurantsList as NSArray)
                })
                
            }
            catch{
                print("invalid json format")
            }
        }
        task.resume()
    }
    
    // Send details of selected restaurant to detail view
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let foodView:FoodViewController = segue.destination as! FoodViewController
        selectedRow = restaurantsTable.indexPathForSelectedRow!.row
        
        // Send Name
        foodView.setName(t: restaurants[selectedRow]["name"]! as! String)
        print(" ")
        print(restaurants[selectedRow]["name"]!)
        
        // Send Location
        foodView.setLocation(t: restaurants[selectedRow]["vicinity"]! as! String)
        print(" ")
        print(restaurants[selectedRow]["vicinity"]!)

    }
    
    // Loads restaurants list
    func loadRestaurants(radius:String){
        
        restaurantsTable.dataSource = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        // get user location and pass lat and long to the api
        userLocation = locationManager.location
        let userlat = (userLocation?.coordinate.latitude)!
        let userlong = (userLocation?.coordinate.longitude)!
        
        let url = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(String(describing: userlat))%2C\(String(describing: userlong))&radius=\(radius)&type=restaurant&key=AIzaSyBaqf7fNiIr26U7nWbXz5wblqgvjg-vaiY"

        print(url)
        downloadRestaurants(urlString: url) {(array) ->() in
            self.restaurants = array as! [NSDictionary]
            self.restaurantsTable.reloadData()
        }
    }
    
    // Assigns User's current location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        userLocation = locations[0]
    }
    
    // Returns the distance between a restaurant and the User
    func getRestaurantDistance(lat:Double,long:Double) -> String{
        
        let restaurantLocation = CLLocation(latitude: lat, longitude: long)
        var distance: CLLocationDistance
        distance = (userLocation?.distance(from: restaurantLocation))!
        
        // convert meters to miles
        let distanceMiles = NSString(format: "%.2f",distance * 0.000621371)
        return distanceMiles as String
    }
    
    // Takes an array of restauraunts and returns a random restaurant name
    func getRandomRestaurant(restaurantList: Array<Any>) -> String{
        let randomName : String = {
            let randomIndex = Int(arc4random_uniform(UInt32(restaurantList.count)))
            return restaurantList[randomIndex] as! String
        }()
        return randomName
    }
    
    // This function assists the dropdown menu
    public func numberOfComponents(in pickerView: UIPickerView) -> Int{
        return 1
    }
    
    // This function assists the dropdown menu
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        
        if(miles!) {
            return distanceListMiles.count
        } else {
            return distanceList.count
        }
        
    }
    
    // This function assists the dropdown menu
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        self.view.endEditing(true)
        
        if(miles!) {
            return distanceListMiles[row]
        } else {
            return distanceList[row]
        }
    }
    
    // This function assists the dropdown menu
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if (miles!) {
            print("Sent in Miles")
            self.distanceTextBox.text = self.distanceListMiles[row]
            let a:Int? = Int(self.distanceListMiles[row])
            print(a!)
            let thisRadius = a! * 1609 // 1 miles is 1609km
            print(thisRadius)
            loadRestaurants(radius: String(thisRadius))
            print(String(thisRadius))
        } else {
            print("Sent in KM")
            self.distanceTextBox.text = self.distanceList[row]
            loadRestaurants(radius: self.distanceList[row])
        }
        
        self.distanceDropdown.isHidden = true
    }
    
    // This function assists the dropdown menu
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == self.distanceTextBox {
            self.distanceDropdown.isHidden = false
            //Disables seeing the keyboard
            textField.endEditing(true)
        }
    }
    
}

