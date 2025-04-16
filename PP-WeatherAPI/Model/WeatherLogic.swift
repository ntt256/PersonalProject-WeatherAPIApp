//
//  WeatherLogic.swift
//  PP-WeatherAPI
//
//  Created by Tay Yeu on 4/7/25.
//
import UIKit
import CoreLocation

protocol WeatherDelegate{
    func didUpdateWeather(_ weatherLogic: WeatherLogic, weather: WeatherModel)
    func failWithError(e: Error)
}

struct WeatherLogic{
    var delegate: WeatherDelegate?
    let apiKey = Bundle.main.object(forInfoDictionaryKey: "API_KEY") as! String
    var apiURL : String{
        return "https://api.openweathermap.org/data/2.5/weather?units=metric&appid=\(apiKey)"
    }
    
    //by city name
    func getWeather(_ cityName: String){
        let url = apiURL + "&q=\(cityName)"
        print(url)
        performApiRequest(url)
    }
    
    //by lat and lon
    func getWeather(lat: CLLocationDegrees, lon: CLLocationDegrees){
        let url = "\(apiURL)&lat=\(lat)&lon=\(lon)"
        performApiRequest(url)
    }
    
    //helper function: API request
    func performApiRequest(_ urlRequest: String){
        if let url = URL(string: urlRequest){ //converting string to URL
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) {data, response, error in
                if error != nil{
                    delegate?.failWithError(e: WeatherError.apiRequestFailed)
                    return //exit the function early
                }
                if let safeData = data{
                    if let weather = parseJSON(weatherData: safeData){
                        delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
            }
            task.resume()
        }
    }
    
    //helper function: parsing JSON data
    func parseJSON(weatherData: Data) -> WeatherModel?{
        let decoder = JSONDecoder()
        do{
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let weather = WeatherModel(temperature: decodedData.main.temp, cityName: decodedData.name, conditionID: decodedData.weather[0].id)
            return weather
        } catch{
            delegate?.failWithError(e: error)
            return nil
        }
    }
    
}
