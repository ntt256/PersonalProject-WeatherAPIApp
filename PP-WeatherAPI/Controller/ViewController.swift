//
//  ViewController.swift
//  PP-WeatherAPI
//
//  Created by Tay Yeu on 3/29/25.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var weatherConditionImage: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    
    var weatherLogic = WeatherLogic()
    var locationLogic = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchTextField.delegate = self
        weatherLogic.delegate = self
        locationLogic.delegate = self
        locationLogic.requestAlwaysAuthorization()
    }
}
//MARK: - UITextFieldDelegate
extension ViewController: UITextFieldDelegate{
    @IBAction func searchButtonPressed(_ sender: UIButton) {
        sender.alpha = 0.5
        Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { timer in
            sender.alpha = 1
        }
        searchTextField.endEditing(true)
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text == ""{
            textField.placeholder = "Please enter a valid location!"
            return false
        }
        textField.placeholder = ""
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let cityName = textField.text{
            weatherLogic.getWeather(cityName)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
    }
}
//MARK: - WeatherDelegate
extension ViewController: WeatherDelegate{
    func didUpdateWeather(_ weatherLogic: WeatherLogic, weather: WeatherModel) {
        DispatchQueue.main.async{
            self.cityLabel.text = weather.cityName
            self.temperatureLabel.text = "\(weather.temperatureString)°"
            self.weatherConditionImage.image = UIImage(systemName: weather.condition)
        }
    }
    
    func failWithError(e: any Error) {
        print(e)
    }
}
//MARK: - CLLocationManagerDelegate
extension ViewController: CLLocationManagerDelegate{
    @IBAction func currentLocationButtonPressed(_ sender: UIButton) {
        sender.alpha = 0.5
        Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { timer in
            sender.alpha = 1
        }
        locationLogic.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last{
            print(location)
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            weatherLogic.getWeather(lat: latitude, lon: longitude)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        print(error)
    }
}

