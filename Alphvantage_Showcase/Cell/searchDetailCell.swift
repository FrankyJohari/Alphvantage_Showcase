//
//  searchDetailCell.swift
//  Alphvantage_Showcase
//
//  Created by Franky Chainoor Johari on 21/12/20.
//

import UIKit

class searchDetailCell: UITableViewCell{
    
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var labelOpen: UILabel!
    @IBOutlet weak var labelClose: UILabel!
    @IBOutlet weak var labelHigh: UILabel!
    @IBOutlet weak var labelLow: UILabel!
    
//    func config(lblDate: String, lblOpen: String, lblClose: String, lblHigh: String, lblLow: String){
//        labelDate.text = lblDate
//        labelOpen.text = lblOpen
//        labelClose.text = lblClose
//        labelHigh.text = lblHigh
//        labelLow.text = lblLow
//    }
    
    func config(dataHistory: TimeSeries){
        labelDate.text = dataHistory.timedate
        labelOpen.text = dataHistory.openVal
        labelClose.text = dataHistory.closeVal
        labelHigh.text = dataHistory.highVal
        labelLow.text = dataHistory.lowVal
    }
}
