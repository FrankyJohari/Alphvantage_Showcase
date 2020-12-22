//
//  SearchViewController.swift
//  Alphvantage_Showcase
//
//  Created by Franky Chainoor Johari on 19/12/20.
//

import UIKit
import ClockKit


class SettingViewController: UIViewController {

    @IBOutlet weak var textFieldAPIKey: UITextField!
    @IBOutlet weak var segmentControlOutputSize: UISegmentedControl!
    @IBOutlet weak var textFieldInterval: UITextField!
    var pickerInterval = UIPickerView()
    
    let intervalData = ["1min", "5min", "15min", "30min", "60min"]
    let userDefaults = UserDefaults.standard
   
    override func viewDidLoad() {
        super.viewDidLoad()

        pickerInterval.dataSource = self
        pickerInterval.delegate = self
        
        textFieldInterval.inputView = pickerInterval
        textFieldInterval.placeholder = "Select Output Size"
        
        //Load userdefaults
        if(userDefaults.string(forKey: "OutputSize") == "Compact"){
            segmentControlOutputSize.selectedSegmentIndex = 1
        }else{
            segmentControlOutputSize.selectedSegmentIndex = 0
        }
        textFieldInterval.text = userDefaults.string(forKey: "Interval")
        textFieldAPIKey.text = userDefaults.string(forKey: "APIKey")
       

    }
    

    @IBAction func buttonSave(_ sender: Any) {
//        textFieldOutputSize.text = segmentControlInterval.selectedSegmentIndex.description
//        textFieldOutputSize.text = segmentControlInterval.titleForSegment(at: segmentControlInterval.selectedSegmentIndex)
        userDefaults.setValue(textFieldAPIKey.text, forKey: "APIKey")
        userDefaults.setValue(segmentControlOutputSize.titleForSegment(at: segmentControlOutputSize.selectedSegmentIndex), forKey: "OutputSize")
        userDefaults.setValue(textFieldInterval.text, forKey: "Interval")
        let alert = UIAlertController(title: "Saved", message: "Success save your setting", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
            
        }))
        present(alert, animated: true)
    }
    
    
    
}

extension SettingViewController: UIPickerViewDataSource{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return intervalData.count
    }
    
}

extension SettingViewController: UIPickerViewDelegate{
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return intervalData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        textFieldInterval.text = intervalData[row]
        textFieldInterval.resignFirstResponder()
    }
    
}
