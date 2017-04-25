//
//  SettingViewController.swift
//  FoodFinder
//
//  Created by Macbook  on 4/14/17.
//  Copyright © 2017 Milan. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {

    @IBOutlet weak var NumberOfResultsTextBox: UITextField!
    @IBOutlet weak var NumberOfResultsDropdown: UIPickerView!
    
    @IBOutlet weak var textFieldContainer: UIImageView!
    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var kmMiSwitch: UISwitch!
    @IBAction func kmMiSwitch(_ sender: Any) {
        checkSwitch()
    }
    
    @IBOutlet weak var kmMiButton: UIButton!
    @IBAction func kmMiButton(_ sender: Any) {
        if(kmMiSwitch.isOn) {
            kmMiSwitch.isOn = false
        } else {
            kmMiSwitch.isOn = true
        }

        checkSwitch()
    }
    
    @IBOutlet weak var clearFavoritesButton: UIButton!
    @IBAction func clearFavoritesButton(_ sender: Any) {
        promptDelete()
    }
    
    @IBOutlet weak var SearchResultsButton: UIButton!
    @IBAction func SearchResultsButton(_ sender: Any) {
        textFieldDidBeginEditing(textField)
    }
    
    var resultsList = ["20","30","40","50","60"]
    
    // kmMiSwitch State
    var miles:Bool? = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.NumberOfResultsTextBox.text = "20"// initial results
        
        kmMiButton.center.x -= view.bounds.width * 2
        kmMiSwitch.center.x += view.bounds.width
        
        SearchResultsButton.center.x += view.bounds.width
        textFieldContainer.center.x -= view.bounds.width * 2
        textField.center.x -= view.bounds.width * 2
        
        clearFavoritesButton.center.y += view.bounds.width
        
        load()
        if (miles != nil) {
            if(miles)! {
                kmMiSwitch.setOn(true, animated: false)
            } else {
                kmMiSwitch.setOn(false, animated: false)
            }
        }
        
        
        UIView.animate(withDuration: 1, delay: 0.0, options: [],
                       animations: {
                        self.kmMiButton.center.x += self.view.bounds.width * 2
        },
                       completion: nil
        )
        
        UIView.animate(withDuration: 1, delay: 0.3, options: [],
                       animations: {
                        self.kmMiSwitch.center.x -= self.view.bounds.width
        },
                       completion: nil
        )
        
        UIView.animate(withDuration: 0.8, delay: 0.6, options: [],
                       animations: {
                        self.SearchResultsButton.center.x -= self.view.bounds.width
        },
                       completion: nil
        )
        
        UIView.animate(withDuration: 1, delay: 0.5, options: [],
                       animations: {
                        self.textFieldContainer.center.x += self.view.bounds.width * 2
                        self.textField.center.x += self.view.bounds.width * 2
        },
                       completion: nil
        )
        
        UIView.animate(withDuration: 0.8, delay: 0.8, options: [],
                       animations: {
                        self.clearFavoritesButton.center.y -= self.view.bounds.width
        },
                       completion: nil
        )
        
    }

    
    func checkSwitch() {
        if (kmMiSwitch.isOn) {
            miles = true
        }else {
            miles = false
        }
        save()
    }
    
    
    func save() {
        UserDefaults.standard.setValue(miles, forKey: "distanceType")
        UserDefaults.standard.synchronize()
    }
    
    func load() {
        if let loadedData = UserDefaults.standard.value(forKey: "distanceType") as? Bool {
            miles = loadedData
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func promptDelete() {
        // create the alert
        let alert = UIAlertController(title: "Delete All Favorites?", message: "This cannot be undone!", preferredStyle: UIAlertControllerStyle.alert)
        
        
        // add an action button that copies the address
        let copyLocationButton = UIAlertAction(title: "Yes", style: UIAlertActionStyle.default) { _ in
            // CALL CODE GOES HERE
            let fav = FavoritesViewController()
            fav.clearFavorites()
        }
        
        // add an action button with a funny name that brings the user back to the NearMeView
        let returnButton = UIAlertAction(title: "No", style: UIAlertActionStyle.default, handler: nil)
        
        alert.addAction(copyLocationButton)
        alert.addAction(returnButton)
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
    
    }
    
    
    
    
    // This function assists the dropdown menu
    public func numberOfComponents(in pickerView: UIPickerView) -> Int{
        return 1
    }
    
    // This function assists the dropdown menu
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return resultsList.count
    }
    
    // This function assists the dropdown menu
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        self.view.endEditing(true)
        return resultsList[row]
    }
    
    // This function assists the dropdown menu
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.NumberOfResultsTextBox.text = self.resultsList[row]
        self.NumberOfResultsDropdown.isHidden = true
    }
    
    // This function assists the dropdown menu
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == self.NumberOfResultsTextBox {
            self.NumberOfResultsDropdown.isHidden = false
            //Disables seeing the keyboard
            textField.endEditing(true)
        }
    }

}
