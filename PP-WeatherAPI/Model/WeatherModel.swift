//
//  WeatherModel.swift
//  PP-WeatherAPI
//
//  Created by Tay Yeu on 4/7/25.
//
import UIKit

struct WeatherModel{
    let temperature: Double
    let cityName: String
    let conditionID: Int
    var temperatureString: String{
        return String(format: "%.0f", temperature)
    }
    var condition: String{
        switch conditionID{
        case 200...232:
            return "cloud.bolt.rain"
        case 300...321:
            return "cloud.drizzle"
        case 500...531:
            return "cloud.rain"
        case 600...622:
            return "cloud.snow"
        case 701...781:
            return "cloud.fog"
        case 800:
            return "sun.max"
        case 801...804:
            return "cloud"
        default:
            return "cloud"
        }
    }
}

