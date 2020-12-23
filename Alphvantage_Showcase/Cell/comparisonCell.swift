//
//  comparisonCell.swift
//  Alphvantage_Showcase
//
//  Created by Franky Chainoor Johari on 23/12/20.
//

import UIKit

class comparisonCell: UITableViewCell{
    
    @IBOutlet weak var labelDateComparison: UILabel!
    @IBOutlet weak var labelSymbolOne: UILabel!
    @IBOutlet weak var labelSymbolTwo: UILabel!
    @IBOutlet weak var labelSymbolThree: UILabel!
    @IBOutlet weak var labelOpenOne: UILabel!
    @IBOutlet weak var labelOpenTwo: UILabel!
    @IBOutlet weak var labelOpenThree: UILabel!
    @IBOutlet weak var labelLowOne: UILabel!
    @IBOutlet weak var labelLowTwo: UILabel!
    @IBOutlet weak var labelLowThree: UILabel!
    
    
    func config(dataComparison: [[DailyAdjusted]], items: Int, indexPathRow: Int){
        labelDateComparison.text = dataComparison[0][indexPathRow].timedate
        labelSymbolOne.text = dataComparison[0][indexPathRow].symbol
        labelOpenOne.text = dataComparison[0][indexPathRow].openVal
        labelLowOne.text = dataComparison[0][indexPathRow].lowVal
        
        labelSymbolTwo.text = ""
        labelOpenTwo.text = ""
        labelLowTwo.text = ""
        
        labelSymbolThree.text = ""
        labelOpenThree.text = ""
        labelLowThree.text = ""
        
        if items == 2 {
            labelSymbolTwo.text = dataComparison[1][indexPathRow].symbol
            
            if dataComparison[0][indexPathRow].timedate == dataComparison[1][indexPathRow].timedate{
                labelOpenTwo.text = dataComparison[1][indexPathRow].openVal
                labelLowTwo.text = dataComparison[1][indexPathRow].lowVal
            }else{
                labelOpenTwo.text = ""
                labelLowTwo.text = ""
            }
            
            labelSymbolThree.text = ""
            labelOpenThree.text = ""
            labelLowThree.text = ""
        }else if items == 3 {
            labelSymbolTwo.text = dataComparison[1][indexPathRow].symbol
            labelSymbolThree.text = dataComparison[2][indexPathRow].symbol
            
            if dataComparison[0][indexPathRow].timedate == dataComparison[1][indexPathRow].timedate{
                labelOpenTwo.text = dataComparison[1][indexPathRow].openVal
                labelLowTwo.text = dataComparison[1][indexPathRow].lowVal
            }else{
                labelOpenTwo.text = ""
                labelLowTwo.text = ""
            }
            if dataComparison[0][indexPathRow].timedate == dataComparison[2][indexPathRow].timedate{
                labelOpenThree.text = dataComparison[2][indexPathRow].openVal
                labelLowThree.text = dataComparison[2][indexPathRow].lowVal
            }else{
                labelOpenThree.text = ""
                labelLowThree.text = ""
            }
        }
    }
}
