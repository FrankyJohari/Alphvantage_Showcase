//
//  ComparisonViewController.swift
//  Alphvantage_Showcase
//
//  Created by Franky Chainoor Johari on 19/12/20.
//

import UIKit

class ComparisonViewController: UIViewController {

    
    @IBOutlet weak var textfieldSymbolOne: UITextField!
    @IBOutlet weak var textfieldSymbolTwo: UITextField!
    @IBOutlet weak var textfieldSymbolThree: UITextField!
    @IBOutlet weak var tableCompare: UITableView!
    @IBOutlet weak var isLoading: UIActivityIndicatorView!
    @IBOutlet weak var compareButton: UIButton!
    
    let userDefaults = UserDefaults.standard
    var outputSize: String = ""
    var apiKey: String = ""
    var count = 0
    var dailyAdjusted: [DailyAdjusted] = [DailyAdjusted]()
    var dailyAdjusteAll: [[DailyAdjusted]] = [[DailyAdjusted]]()
    var statusOne = true
    var statusTwo = true
    var statusThree = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textfieldSymbolOne.text = "IBM"
        textfieldSymbolTwo.text = "A"
        isLoading.isHidden = true
    }
    
    
    

    @IBAction func buttonCompare(_ sender: Any) {
        
        if(userDefaults.string(forKey: "Interval") == nil && userDefaults.string(forKey: "OutputSize") == nil && userDefaults.string(forKey: "APIKey") == nil){
            let alert = UIAlertController(title: "Error", message: "Please set your setting first", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                
            }))
            present(alert, animated: true)
        }else{
            compareButton.isEnabled = false
            isLoading.isHidden = false
            isLoading.startAnimating()
            
            outputSize = userDefaults.string(forKey: "OutputSize")!.lowercased()
            apiKey = userDefaults.string(forKey: "APIKey")!
            dailyAdjusteAll.removeAll()
            statusOne = true
            statusTwo = true
            statusThree = true
            
            
            if (textfieldSymbolOne.text?.isEmpty == false && textfieldSymbolTwo.text?.isEmpty == false && textfieldSymbolThree.text?.isEmpty == false) {
                count = 0
                print("jejak count \(count)")
                checkingTextfield()
            }else if (textfieldSymbolOne.text?.isEmpty == true && textfieldSymbolTwo.text?.isEmpty == false && textfieldSymbolThree.text?.isEmpty == false || textfieldSymbolOne.text?.isEmpty == false && textfieldSymbolTwo.text?.isEmpty == true && textfieldSymbolThree.text?.isEmpty == false || textfieldSymbolOne.text?.isEmpty == false && textfieldSymbolTwo.text?.isEmpty == false && textfieldSymbolThree.text?.isEmpty == true){
                count = 1
                print("jejak count \(count)")
                checkingTextfield()
            }else if(textfieldSymbolOne.text?.isEmpty == true && textfieldSymbolTwo.text?.isEmpty == true && textfieldSymbolThree.text?.isEmpty == false || textfieldSymbolOne.text?.isEmpty == true && textfieldSymbolTwo.text?.isEmpty == false && textfieldSymbolThree.text?.isEmpty == true || textfieldSymbolOne.text?.isEmpty == false && textfieldSymbolTwo.text?.isEmpty == true && textfieldSymbolThree.text?.isEmpty == true){
                count = 2
                print("jejak count \(count)")
                checkingTextfield()
            }
            

        }
    }
    
    
    
    func fetchAdjustedDay(symbols: String){
        dailyAdjusted.removeAll()
        guard let URL = URL(string: "https://www.alphavantage.co/query?function=TIME_SERIES_DAILY_ADJUSTED&symbol=\(symbols)&outputsize=\(outputSize)&apikey=\(apiKey)") else {return}

        URLSession.shared.dataTask(with: URL) { (data, respone, error) in

        guard let data = data else { return }
        guard let jsonIntra = try? JSONSerialization.jsonObject(with: data, options: []) else {return}
        if let dictionary = jsonIntra as? [String: Any] {
            
            let getTime = "Time Series (Daily)"
            guard let timeSeries = dictionary[getTime] as? [String: Any] else {return}
            for (key, value) in timeSeries {
                guard let detail = timeSeries[key] as? [String: Any] else {return}
                let getOpen = "1. open"
                let getLow = "3. low"
                
                let openValue = detail[getOpen]!
                let lowValue = detail[getLow]!
                self.dailyAdjusted += [DailyAdjusted(symbol: symbols, timedate: "\(key)", openVal: "\(openValue)", lowVal: "\(lowValue)")]
                
            }
            let sortedDailyAdjusted = self.dailyAdjusted.sorted {$0.timedate > $1.timedate}
            
            self.dailyAdjusteAll.append(sortedDailyAdjusted)
            print(self.dailyAdjusteAll.count)
            print(self.dailyAdjusteAll[0][0].timedate)
            print(self.count)

        }else{
            return print("false")
        }
        
        DispatchQueue.main.async {
            if(self.count == 2){
                self.tableCompare.reloadData()
                self.isLoading.stopAnimating()
                self.isLoading.isHidden = true
                self.compareButton.isEnabled = true
                print("reload")
            }else{
                self.count += 1
                self.checkingTextfield()
            }
        }

           }.resume()
        print("test \(count)")

       }
    
    
    func checkingTextfield(){
        if (textfieldSymbolOne.text?.isEmpty == false && statusOne) {
            statusOne = false
            print("one \(statusOne)")
            fetchAdjustedDay(symbols: textfieldSymbolOne.text!)
        }else if (textfieldSymbolTwo.text?.isEmpty == false && statusTwo) {
            statusTwo = false
            print("two \(statusTwo)")
            fetchAdjustedDay(symbols: textfieldSymbolTwo.text!)

        }else if (textfieldSymbolThree.text?.isEmpty == false && statusThree) {
            statusThree = false
            print("three \(statusThree)")
            fetchAdjustedDay(symbols: textfieldSymbolThree.text!)
            
        }
    }
    

}

extension ComparisonViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dailyAdjusted.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(indexPath.row >= 0 && indexPath.row < dailyAdjusted.count){
            guard let comparasionCell = tableView.dequeueReusableCell(withIdentifier: "comparisonDetailCell") as? comparisonCell else {return UITableViewCell()}
            comparasionCell.config(dataComparison: dailyAdjusteAll, items: dailyAdjusteAll.count, indexPathRow: indexPath.row)
            return comparasionCell
        }else{
            return UITableViewCell()
        }

    }
    
    
    
}
