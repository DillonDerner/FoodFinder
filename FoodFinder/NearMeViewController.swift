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
    
    @IBOutlet weak var colorWheelImage: UIImageView!
    
    // Distance in KiloMeters
    var distanceList = ["2", "4", "6", "8", "10", "15", "20", "30", "40", "50"]
    
    // Distance in Miles
    var distanceListMiles = ["1","2","3","4","5","10","15","20","25","30"]
    
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
        
        chooseForMeButton.center.y += self.view.bounds.width
        
        let fileManager = FileManager.default
        let tempFolderPath = NSTemporaryDirectory()
        
        do {
            let filePaths = try fileManager.contentsOfDirectory(atPath: tempFolderPath)
            for filePath in filePaths {
                try fileManager.removeItem(atPath: NSTemporaryDirectory() + filePath)
                //print(filePath)
            }
        } catch let error as NSError {
            print("Could not clear temp folder: \(error.debugDescription)")
        }
        
        UIView.animate(withDuration: 0.5, delay: 0.0, options: [],
                       animations: {
                        self.chooseForMeButton.center.y -= self.view.bounds.width
        },
                       completion: nil
        )
        
    }
    
    
    @IBOutlet weak var chooseForMeButton: UIButton!
    @IBAction func chooseForMeButton(_ sender: Any) {
        
        // If the restaurants list is empty, do not allow this button to work
        if (restaurants.isEmpty) { return }
        
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
    
    
    @IBAction func showRandomAlert(_ sender: UIButton) {
        
        // setup a list of the current restaurant names
        var restaurantNameList:[String] = []
        for restaurant in restaurants{
            let thisName = String(describing: restaurant.object(forKey: "name")!)
            restaurantNameList.append(thisName)
        }
        
        // setup a list of the current restaurant names
        var restaurantLocationList:[String] = []
        for restaurant in restaurants{
            let thisLocation = String(describing: restaurant.object(forKey: "vicinity")!)
            restaurantLocationList.append(thisLocation)
        }
        
        
        // choose a randome restaurant and display message
        let randomFoodNumber    = Int(arc4random_uniform(UInt32(restaurantNameList.count)))
        
        let randomMessageNumber = Int(arc4random_uniform(UInt32(self.foodMessage.count)))
        
        // create the alert
        let alert = UIAlertController(title: restaurantNameList[randomFoodNumber], message: restaurantLocationList[randomFoodNumber], preferredStyle: UIAlertControllerStyle.alert)
        

        // add an action button that copies the address
        let copyLocationButton = UIAlertAction(title: "Copy Location", style: UIAlertActionStyle.default) { _ in
            UIPasteboard.general.string = restaurantLocationList[randomFoodNumber] as String
        }
        
        // add an action button with a funny name that brings the user back to the NearMeView
        let returnButton = UIAlertAction(title: self.foodMessage[randomMessageNumber], style: UIAlertActionStyle.default, handler: nil)
        
        alert.addAction(copyLocationButton)
        alert.addAction(returnButton)
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
    
    
    // Handles what has been set in the Settings View
    func switchDistance() {

        // Miles
        if(miles!) {
            self.distanceImage.image = #imageLiteral(resourceName: "Miles")
            loadRestaurants(radius: "1")
            self.distanceTextBox.text = "1" // initial radius / search distance 1 mile

        // Kilometers
        } else {
            self.distanceImage.image = #imageLiteral(resourceName: "Km")
            loadRestaurants(radius: "2")
            self.distanceTextBox.text = "2"   // initial distance 2km
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
                    restaurantsList.append(restaurant as NSDictionary)
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
        
        // print(restaurants[selectedRow]["name"]!)
        
        // Send Location
        foodView.setLocation(t: restaurants[selectedRow]["vicinity"]! as! String)
        
        // print(restaurants[selectedRow]["vicinity"]!)
        
        let photos = restaurants[selectedRow]["photos"]! as? NSArray
        
        let photosdic = photos![0] as! NSDictionary
        
        let photoref = photosdic["photo_reference"]! as? String    // photo reference
        
        //send photoref to favoritesViewController.swift
        
        foodView.setPhoto(t: photoref!)
        
        deletepreviousPhotos()  //delete previous photo to load new in temp folder
     

    }
    
    
     // delete all the previous photos from temp folder 
    
    func deletepreviousPhotos() {
        let fileManager = FileManager.default
        let tempFolderPath = NSTemporaryDirectory()
        
        do {
            let filePaths = try fileManager.contentsOfDirectory(atPath: tempFolderPath)
            for filePath in filePaths {
                try fileManager.removeItem(atPath: NSTemporaryDirectory() + filePath)
                //print("files all called")
                //print(filePath)
                //type(of: filePath)
            }
        } catch let error as NSError {
            print("Could not clear temp folder: \(error.debugDescription)")
        }
        
    }
    // Loads restaurants list
    func loadRestaurants(radius:String){
        var radiusinmeter:String
        print(miles!)
        restaurantsTable.dataSource = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        //var radiusinmeter = "2000"
        if(miles!){
            
        radiusinmeter = String(Double(radius)! * 1609.34) // miles to meter
        }else{
        radiusinmeter = String(Double(radius)! * 1000) // km to meter

        }
        // get user location and pass lat and long to the api
        userLocation = locationManager.location
        let userlat = (userLocation?.coordinate.latitude)!
        let userlong = (userLocation?.coordinate.longitude)!
        
        let url = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(String(describing: userlat))%2C\(String(describing: userlong))&radius=\(radiusinmeter)&type=restaurant&key=AIzaSyBaqf7fNiIr26U7nWbXz5wblqgvjg-vaiY"

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
        var distance1:String
        let restaurantLocation = CLLocation(latitude: lat, longitude: long)
        var distance: CLLocationDistance
        distance = (userLocation?.distance(from: restaurantLocation))!
        
        // convert meters to miles
        if(miles!){
        return NSString(format: "%.2f",distance * 0.000621371) as String // return distance in miles if preferred search is in milesin miles
        }else {
        return NSString(format: "%.2f",distance * 0.001) as String // return distance in km if in km
        }
    
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
            self.distanceTextBox.text = self.distanceListMiles[row]
           // let a:Int? = Int(self.distanceListMiles[row])
           // let thisRadius = a! * 1609 // 1 miles is 1609km
           // loadRestaurants(radius: String(thisRadius))   logic changed to handle inside loadRest func
        } else {
            self.distanceTextBox.text = self.distanceList[row]
           // loadRestaurants(radius: self.distanceList[row])
        }
        loadRestaurants(radius: self.distanceList[row])
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

