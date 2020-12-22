//
//  SettingViewController.swift
//  Alphvantage_Showcase
//
//  Created by Franky Chainoor Johari on 19/12/20.
//

import UIKit

class SearchViewController: UIViewController {

    @IBOutlet weak var textFieldSymbol: UITextField!
    @IBOutlet weak var intradayDetailTable: UITableView!
    
    let userDefaults = UserDefaults.standard
    var interval: String = ""
    var outputSize: String = ""
    var apiKey: String = ""
//    var timeserieses = TimeSeries(timedate: [], openVal: [], highVal: [], lowVal: [], closeVal: [])
    var timeseriesarray: [TimeSeries] = [TimeSeries]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        textFieldSymbol.text = "IBM"
        
    }
    

    @IBAction func buttonSearch(_ sender: Any) {
        
        if(userDefaults.string(forKey: "Interval") == nil && userDefaults.string(forKey: "OutputSize") == nil && userDefaults.string(forKey: "APIKey") == nil){
            let alert = UIAlertController(title: "Error", message: "Please set your setting first", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                
            }))
            present(alert, animated: true)
        }else{
            timeseriesarray.removeAll()
//            timeserieses.timedate?.removeAll()
//            timeserieses.lowVal?.removeAll()
//            timeserieses.highVal?.removeAll()
//            timeserieses.openVal?.removeAll()
//            timeserieses.closeVal?.removeAll()
            interval = userDefaults.string(forKey: "Interval")!
            outputSize = userDefaults.string(forKey: "OutputSize")!.lowercased()
            apiKey = userDefaults.string(forKey: "APIKey")!
            print("btn")
            fetchIntraDay()
        }
    }
    
    func fetchIntraDay(){
        
        guard let URL = URL(string: "https://www.alphavantage.co/query?function=TIME_SERIES_INTRADAY&symbol=\(textFieldSymbol.text!)&interval=\(self.interval)&outputsize=\(outputSize)&apikey=\(apiKey)") else {return}

        URLSession.shared.dataTask(with: URL) { (data, respone, error) in

        guard let data = data else { return }
        guard let jsonIntra = try? JSONSerialization.jsonObject(with: data, options: []) else {return}
        print("ini jsonintra")
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
            self.intradayDetailTable.reloadData()
        }

           }.resume()
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

