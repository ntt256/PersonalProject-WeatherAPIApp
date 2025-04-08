//
//  WeatherData.swift
//  PP-WeatherAPI
//
//  Created by Tay Yeu on 4/7/25.
//
import UIKit

struct WeatherData: Codable{
    let name: String
    let weather: [Weather]
    let main: Main
}

struct Weather: Codable{
    let id: Int
    let description: String
}

struct Main: Codable{
    let temp: Double
}
