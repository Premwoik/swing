//
//  ViewController.swift
//  WojtasikPrognozaPogody
//
//  Created by Student on 09/10/2018.
//  Copyright © 2018 RS KIS.EDU. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var min_temp: UITextField!
    @IBOutlet weak var max_temp: UITextField!
    @IBOutlet weak var wind_speed: UITextField!
    @IBOutlet weak var wind_direction: UITextField!
    @IBOutlet weak var air_pressure: UITextField!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var previousBtn: UIButton!
    @IBOutlet weak var currentLocalizationLabel: UILabel!
    
    let locationManager = CLLocationManager()
    
    
    let urlStr: String = "https://www.metaweather.com/api/location/"
    var weatherData: [[String: Any]] = []
    var choosenDayId: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initLocation()
        loadWeather()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    func initLocation(){
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.delegate = self
        self.locationManager.startMonitoringSignificantLocationChanges()
    }
    
    func locationManager(_ manager: CLLocationManager,  didUpdateLocations locations: [CLLocation]) {
        CLGeocoder().reverseGeocodeLocation(locations.last!, completionHandler: {(placemarks, error) -> Void in
            
            if error != nil {
                print("Reverse geocoder failed with error" + error!.localizedDescription)
                return
            }
            
            if placemarks!.count > 0 {
                print(placemarks!)
            }
            else {
                print("Problem with the data received from geocoder")
            }
        })
        
        // Do something with the location.
    }
    
    func loadWeather(){
        let utlT: String = urlStr + getCity()
        print(utlT)
        let url: URL = URL.init(string: utlT)!
        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
            guard let data = data else { return }
            guard let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {return}
            guard let weatherData = json!["consolidated_weather"] as? [[String: Any]] else {return}
            DispatchQueue.main.async {
                self.weatherData = weatherData
                self.updateView()
            }
        }
        task.resume()
    }
    
    func findCity(){
        
    }
    
    func getCity() -> String{
        return "44418/"
    }
    
    func currentDate() -> String{
        let date = Date()
        let calendar = Calendar.current
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        return "\(year)/\(month)/\(day)/"
    }
    
    func updateView(){
        self.max_temp.text = prepareTxt(field: "max_temp")
        self.min_temp.text = prepareTxt(field: "min_temp")
        self.wind_speed.text = prepareTxt(field: "wind_speed")
        self.wind_direction.text = prepareTxt(field: "wind_direction")
        self.air_pressure.text = prepareTxt(field: "air_pressure")
        self.date.text = prepareTxt(field: "applicable_date")
        }
    
    func prepareTxt(field: String) -> String{
        return "\(self.weatherData[self.choosenDayId][field]!)"
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
            self.updateView()
            previousBtn.isEnabled = true
        }
        else{
            nextBtn.isEnabled = false
        }
    }
    
    
    @IBAction func previousBtnClick(_ sender: Any) {
        if(updateChoosenDayId(newId: self.choosenDayId-1)){
        self.updateView()
            nextBtn.isEnabled = true
        }
        else{
            previousBtn.isEnabled = false
        }
    }
    

    
}

