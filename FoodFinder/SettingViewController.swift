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
    var resultsList = ["10","20","30","40","50"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
