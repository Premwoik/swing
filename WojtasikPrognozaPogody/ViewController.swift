//
//  ViewController.swift
//  WojtasikPrognozaPogody
//
//  Created by Student on 09/10/2018.
//  Copyright © 2018 RS KIS.EDU. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    struct Forecast {
        let min_temp: Double?
        let max_temp: Double?
        let wind_speed: Double?
        let wind_direction: Int?
        let air_pressure: Any?
        
        let location: (latitude: Double, longitude: Double)
    }
    
    
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var min_temp: UITextField!
    @IBOutlet weak var max_temp: UITextField!
    @IBOutlet weak var wind_speed: UITextField!
    @IBOutlet weak var wind_direction: UITextField!
    @IBOutlet weak var air_pressure: UITextField!
    
    let urlStr: String = "https://www.metaweather.com/api/location/"
    
    var resp: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadWeather()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func loadWeather(){
        let utlT: String = urlStr + getCity() + currentDate()
        print(utlT)
        let url: URL = URL.init(string: utlT)!
        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
            guard let data = data else { return }
            guard let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] else {return}
            DispatchQueue.main.async {
                self.updateView(jsonArray: json!)
            }
        }
        task.resume()
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
    
    func updateView(jsonArray: [[String:Any]]){
        self.max_temp.insertText("\(jsonArray[1]["max_temp"]!)")
        self.min_temp.insertText("\(jsonArray[1]["min_temp"]!)")
        self.wind_speed.insertText("\(jsonArray[1]["wind_speed"]!)")
        self.wind_direction.insertText("\(jsonArray[1]["wind_direction"]!)")
        self.air_pressure.insertText("\(jsonArray[1]["air_pressure"]!)")
        }

    @IBAction func displayNextDay(_ sender: UIButton) {
    }
    
    
    @IBAction func displayPreviousDay(_ sender: UIButton) {
    }
}

