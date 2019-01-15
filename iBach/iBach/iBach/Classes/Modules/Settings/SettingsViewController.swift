//
//  SettingsViewController.swift
//  iBach
//
//  Created by Neven Travas on 01/12/2018.
//  Copyright © 2018 Petar Jedek. All rights reserved.
//

import UIKit

class SettingsViewController: UITableViewController, UITextFieldDelegate{
    
    let myPickerData = ["Light Theme","Dark Theme","Blue Theme"]
    let songDetailData = ["musicmix"]
    
    @IBOutlet weak var themeTextField: UITextField!
    @IBOutlet weak var songDetailTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let themePicker = UIPickerView()
        let songDetailPicker = UIPickerView()
        themeTextField.inputView = themePicker
        songDetailTextField.inputView = songDetailPicker
        songDetailTextField.inputView?.tag = 1
        themePicker.delegate = self
        songDetailPicker.delegate = self
        
        let themeRow = UserDefaults.standard.integer(forKey: "theme")
        themeTextField.text = myPickerData[themeRow]
    }
}

extension SettingsViewController: UIPickerViewDelegate, UIPickerViewDataSource {
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
        themeTextField.text = myPickerData[row]
        self.view.endEditing(true)
        
        UserDefaults.standard.set(Int(row), forKey: "theme")
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(0.5)) {
            theme.apply(for: UIApplication.shared)
        }
    }
}






