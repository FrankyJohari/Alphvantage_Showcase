//
//  SearchViewController.swift
//  Alphvantage_Showcase
//
//  Created by Franky Chainoor Johari on 19/12/20.
//

import UIKit

class SettingViewController: UIViewController {

    @IBOutlet weak var textFieldAPIKey: UITextField!
    @IBOutlet weak var segmentControlInterval: UISegmentedControl!
    @IBOutlet weak var textFieldOutputSize: UITextField!
    var pickerOutputSize = UIPickerView()
    
    let outputSize = ["1 Mins", "5 Mins", "15 Mins", "30 Mins", "60 Mins"]
    let userDefaults = UserDefaults.standard
    var a = "Compact"
    override func viewDidLoad() {
        super.viewDidLoad()

        pickerOutputSize.dataSource = self
        pickerOutputSize.delegate = self
        
        textFieldOutputSize.inputView = pickerOutputSize
        textFieldOutputSize.placeholder = "Select Output Size"
        
        //Load userdefaults
        if(a == "Compact"){
            segmentControlInterval.selectedSegmentIndex = 1
        }else{
            segmentControlInterval.selectedSegmentIndex = 0
        }
        textFieldOutputSize.text = "1 Mins"
        

    }
    

    @IBAction func buttonSave(_ sender: Any) {
//        textFieldOutputSize.text = segmentControlInterval.selectedSegmentIndex.description
        textFieldOutputSize.text = segmentControlInterval.titleForSegment(at: segmentControlInterval.selectedSegmentIndex)
    }
    
}

extension SettingViewController: UIPickerViewDataSource{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return outputSize.count
    }
    
}

extension SettingViewController: UIPickerViewDelegate{
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return outputSize[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        textFieldOutputSize.text = outputSize[row]
        textFieldOutputSize.resignFirstResponder()
    }
    
}
