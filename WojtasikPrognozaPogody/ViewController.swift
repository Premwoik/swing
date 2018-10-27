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

    

    @IBOutlet weak var date: UILabel!
    @IBOutlet var imgView: UIImageView!
    
    
    @IBOutlet weak var min_temp: UITextField!
    @IBOutlet weak var max_temp: UITextField!
    @IBOutlet weak var wind_speed: UITextField!
    @IBOutlet weak var wind_direction: UITextField!
    @IBOutlet weak var air_pressure: UITextField!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var previousBtn: UIButton!
    @IBOutlet weak var currentLocalizationLabel: UILabel!
    @IBOutlet weak var theTemp: UITextField!
    @IBOutlet weak var humidity: UITextField!
    @IBOutlet weak var visibility: UITextField!
    @IBOutlet weak var predictability: UITextField!
    
//    let locationManager = CLLocationManager()
    
    
    var client: WeatherClient!
    
    var weatherData: [DayWeatherForecast]?
    var weatherImg: UIImage?
    var choosenDayId: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.client = WeatherClient(owner: self)
        self.client.getCityWeather(cityCode: "44418/")
    }
    
    func updateDayView(){
        let day = weatherData![self.choosenDayId]
        self.client.getWeatherStateIcon(abbreviation: day.weatherStateAbbr)
        self.visibility.text = format(f: day.visibility)
        self.predictability.text = String(day.predictability)
        self.humidity.text = String(day.humidity)
        self.theTemp.text = format(f: day.theTemp)
        self.max_temp.text = format(f: day.maxTemp)
        self.min_temp.text = format(f: day.minTemp)
        self.wind_speed.text = format(f: day.windSpeed) + "m/s"
        self.wind_direction.text = format(f: day.windDirection)
        self.air_pressure.text = format(f: day.airPressure)
        self.date.text = String(day.applicableDate)
        }
    
    func format(f: Double) -> String{
        return String(format: "%.1f", f)
    }
    
    func updateWeatherImg(img: UIImage){
        self.imgView = UIImageView(image: img)
    }
    
    func updateChoosenDayId(newId: Int) -> Bool {
        if (newId > 4 || newId < 0) {
            return false
        }
        else{
            self.choosenDayId = newId
            return true
        }
    }

    @IBAction func nextBtnClick(_ sender: Any) {
        if (updateChoosenDayId(newId: self.choosenDayId+1)){
            self.updateDayView()
            previousBtn.isEnabled = true
        }
        else{
            nextBtn.isEnabled = false
        }
    }
    
    
    @IBAction func previousBtnClick(_ sender: Any) {
        if(updateChoosenDayId(newId: self.choosenDayId-1)){
            self.updateDayView()
            nextBtn.isEnabled = true
        }
        else{
            previousBtn.isEnabled = false
        }
    }
    

    
}

