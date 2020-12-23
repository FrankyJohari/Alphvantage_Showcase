//
//  SettingViewController.swift
//  Alphvantage_Showcase
//
//  Created by Franky Chainoor Johari on 19/12/20.
//

import UIKit

class SearchViewController: UIViewController {

    @IBOutlet weak var textFieldSymbol: UITextField!
    @IBOutlet weak var textfieldSort: UITextField!
    @IBOutlet weak var intradayDetailTable: UITableView!
    @IBOutlet weak var isLoading: UIActivityIndicatorView!
    @IBOutlet weak var searchButton: UIButton!
    
    let userDefaults = UserDefaults.standard
    var interval: String = ""
    var outputSize: String = ""
    var apiKey: String = ""
    var timeseriesarray: [TimeSeries] = [TimeSeries]()
    
    var pickerSort = UIPickerView()
    
    let sortData = ["OPEN ASC", "OPEN DSC", "HIGH ASC", "HIGH DSC", "LOW ASC", "LOW DSC", "CLOSE ASC", "CLOSE DSC"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerSort.dataSource = self
        pickerSort.delegate = self
        self.hideKeyboardWhenTappedAround()
        
        textfieldSort.inputView = pickerSort
        textfieldSort.placeholder = "Select Sort(Opt)"
        isLoading.isHidden = true

    }
    

    @IBAction func buttonSearch(_ sender: Any) {
        
        if(textFieldSymbol.text?.isEmpty != true){
            if(userDefaults.string(forKey: "Interval") == nil && userDefaults.string(forKey: "OutputSize") == nil && userDefaults.string(forKey: "APIKey") == nil){
                let alert = UIAlertController(title: "Error", message: "Please set your setting first", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                    
                }))
                present(alert, animated: true)
            }else{
                searchButton.isEnabled = false
                isLoading.isHidden = false
                isLoading.startAnimating()
                timeseriesarray.removeAll()
                interval = userDefaults.string(forKey: "Interval")!
                outputSize = userDefaults.string(forKey: "OutputSize")!.lowercased()
                apiKey = userDefaults.string(forKey: "APIKey")!
                fetchIntraDay()
            }
        }else{
            let alert = UIAlertController(title: "Error", message: "Please fill your symbol first", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                
            }))
            present(alert, animated: true)
        }
    }
    
    func fetchIntraDay(){
        
        guard let URL = URL(string: "https://www.alphavantage.co/query?function=TIME_SERIES_INTRADAY&symbol=\(textFieldSymbol.text!)&interval=\(self.interval)&outputsize=\(outputSize)&apikey=\(apiKey)") else {return}

        URLSession.shared.dataTask(with: URL) { (data, respone, error) in

        guard let data = data else { return }
        guard let jsonIntra = try? JSONSerialization.jsonObject(with: data, options: []) else {return}
        if let dictionary = jsonIntra as? [String: Any] {
            
            let getTime = "Time Series (\(self.interval))"
            guard let timeSeries = dictionary[getTime] as? [String: Any] else {return}
            for (key, value) in timeSeries {
                guard let detail = timeSeries[key] as? [String: Any] else {return}

                let getOpen = "1. open"
                let getHigh = "2. high"
                let getLow = "3. low"
                let getClose = "4. close"
                
                let openValue = detail[getOpen]!
                let highValue = detail[getHigh]!
                let closeValue = detail[getClose]!
                let lowValue = detail[getLow]!
                
                self.timeseriesarray += [TimeSeries(timedate: "\(key)", openVal: "\(openValue)", highVal: "\(highValue)", lowVal: "\(lowValue)", closeVal: "\(closeValue)")]
            }

        }else{
            return print("false")
        }
        
        DispatchQueue.main.async {
            self.sortingIntraday(typeSort: self.textfieldSort.text ?? "Date ASC")
            self.intradayDetailTable.reloadData()
            self.isLoading.stopAnimating()
            self.isLoading.isHidden = true
            self.searchButton.isEnabled = true
        }

           }.resume()
       }
    
    func sortingIntraday(typeSort: String){
        if typeSort == "OPEN ASC" {
            timeseriesarray = timeseriesarray.sorted { $0.openVal < $1.openVal }
        }else if typeSort == "OPEN DSC"{
            timeseriesarray = timeseriesarray.sorted { $0.openVal > $1.openVal }
        }else if typeSort == "HIGH ASC" {
            timeseriesarray = timeseriesarray.sorted { $0.highVal < $1.highVal }
        }else if typeSort == "HIGH DSC"{
            timeseriesarray = timeseriesarray.sorted { $0.highVal > $1.highVal }
        }else if typeSort == "LOW ASC" {
            timeseriesarray = timeseriesarray.sorted { $0.lowVal < $1.lowVal }
        }else if typeSort == "LOW DSC"{
            timeseriesarray = timeseriesarray.sorted { $0.lowVal > $1.lowVal }
        }else if typeSort == "CLOSE ASC" {
            timeseriesarray = timeseriesarray.sorted { $0.closeVal < $1.closeVal }
        }else if typeSort == "CLOSE DSC"{
            timeseriesarray = timeseriesarray.sorted { $0.closeVal > $1.closeVal }
        }else{
            timeseriesarray = timeseriesarray.sorted {$0.timedate > $1.timedate}
        }

    }
    
    

}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timeseriesarray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(indexPath.row >= 0 && indexPath.row < timeseriesarray.count){
            guard let searchDetailCell = tableView.dequeueReusableCell(withIdentifier: "detailCell") as? searchDetailCell else {return UITableViewCell()}
            searchDetailCell.config(dataHistory: timeseriesarray[indexPath.row])
            return searchDetailCell
        }else{
            return UITableViewCell()
        }

    }

}

extension SearchViewController: UIPickerViewDataSource{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return sortData.count
    }
    
}

extension SearchViewController: UIPickerViewDelegate{
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return sortData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        textfieldSort.text = sortData[row]
        textfieldSort.resignFirstResponder()
    }
    
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

