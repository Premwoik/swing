//
//  ViewController.swift
//  WojtasikPrognozaPogody
//
//  Created by Student on 09/10/2018.
//  Copyright © 2018 RS KIS.EDU. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate, WeatherData {

    
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet var imgView: UIImageView!
    
    @IBOutlet weak var theTemp: UITextField!
    @IBOutlet weak var minTemp: UITextField!
    @IBOutlet weak var maxTemp: UITextField!
    @IBOutlet weak var windSpeed: UITextField!
    @IBOutlet weak var windDirection: UITextField!
    @IBOutlet weak var airPressure: UITextField!
    @IBOutlet weak var humidity: UITextField!
    @IBOutlet weak var visibility: UITextField!
    @IBOutlet weak var predictability: UITextField!
    
    @IBOutlet weak var previousBtn: UIButton!
    @IBOutlet weak var nextBtn: UIButton!
    
    
    var client: WeatherClient!
    
    var weatherData: [DayWeatherForecast]?
    var weatherImg: UIImage?
    var choosenDayId: Int = 0
    
    var city: City? {
        didSet{
            refreshUI()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.client = WeatherClient(owner: self)
     
    }
    
    func loadCity(){
        self.cityName.text = city!.name
        self.client.getCityWeather(cityCode: String(city!.id) + "/")
        self.previousBtn.isEnabled = false
        
    }
    
    func refreshUI(){
        loadViewIfNeeded()
        loadCity()
    }
    
    func updateDayView(){
        let day = weatherData![self.choosenDayId]
        self.client.getWeatherStateIcon(abbreviation: day.weatherStateAbbr)
        self.visibility.text = format(f: day.visibility) + " miles"
        self.predictability.text = String(day.predictability) + "%"
        self.humidity.text = String(day.humidity) + "%"
        self.theTemp.text = format(f: day.theTemp) + " °C"
        self.maxTemp.text = format(f: day.maxTemp) + " °C"
        self.minTemp.text = format(f: day.minTemp) + " °C"
        self.windSpeed.text = format(f: day.windSpeed) + " mph"
        self.windDirection.text = format(f: day.windDirection) + "°"
        self.airPressure.text = format(f: day.airPressure) + " mbar"
        self.date.text = String(day.applicableDate)
        }
    
    private func format(f: Double) -> String{
        return String(format: "%.1f", f)
    }
    
    func updateWeatherImg(img: UIImage){
        self.imgView.image = img
    }
    
    func updateWeatherData(data: [DayWeatherForecast]){
        self.weatherData = data
        updateDayView()
    }
    
    @IBAction func nextBtnClick(_ sender: Any) {
        if (isIdInRange(id: choosenDayId + 1)){
            nextDay(plusId: 1)
            previousBtn.isEnabled = true
            if(!isIdInRange(id: choosenDayId + 1)){
                nextBtn.isEnabled = false
            }
        }
    }
    
    @IBAction func previousBtnClick(_ sender: Any) {
        if(isIdInRange(id: choosenDayId - 1)){
            nextDay(plusId: -1)
            nextBtn.isEnabled = true
            if(!isIdInRange(id: choosenDayId - 1)){
                previousBtn.isEnabled = false
            }
        }
    }
    
    private func isIdInRange(id: Int) -> Bool {
        return !(id > 5 || id < 0)
    }
    
    private func nextDay(plusId: Int){
        choosenDayId += plusId
        updateDayView()
    }
    
}

extension ViewController: CitySelectionDelegate {
    func citySelected(_ newCity: City) {
        city  = newCity
    }
}
