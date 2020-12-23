//
//  DataModel.swift
//  Alphvantage_Showcase
//
//  Created by Franky Chainoor Johari on 20/12/20.
//

import Foundation

struct TimeSeries{
    var timedate: String
    var openVal: String
    var highVal: String
    var lowVal: String
    var closeVal: String
    
}

struct DailyAdjusted{
    var symbol: String
    var timedate: String
    var openVal: String
    var lowVal: String
}
