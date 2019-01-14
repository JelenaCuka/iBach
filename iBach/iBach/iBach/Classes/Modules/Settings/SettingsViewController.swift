//
//  SettingsViewController.swift
//  iBach
//
//  Created by Neven Travas on 01/12/2018.
//  Copyright © 2018 Petar Jedek. All rights reserved.
//

import UIKit

class SettingsViewController: UITableViewController,UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate{
    
    let myPickerData = ["Light Theme","Dark Theme","Blue Theme"]
    let songDetailData = ["musicmix"]
    
    @IBOutlet weak var themeTextField: UITextField!
    @IBOutlet weak var songDetailTextField: AppTextField!
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 1{
            return songDetailData.count
        }
        return myPickerData.count
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 1 {
            return songDetailData[row]
        }
        return myPickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)  {
        
        if pickerView.tag == 1 {
            print("works")
            songDetailTextField.text = songDetailData[row]
        }
        
        
        let theme: Theme
        
        switch row {
        case 1: theme = DarkTheme()
        case 2: theme = BlueTheme()
        default: theme = LightTheme()
        }
        
        theme.apply(for: UIApplication.shared)
        themeTextField.text = myPickerData[row]
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let themePicker = UIPickerView()
        let songDetailPicker = UIPickerView()
        themeTextField.inputView = themePicker
        songDetailTextField.inputView = songDetailPicker
        songDetailTextField.inputView?.tag = 1
        themePicker.delegate = self
        songDetailPicker.delegate = self
        
    }
    
    
    
    
    
    
}






