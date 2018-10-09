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
    
    let urlStr: String = "https://www.metaweather.com/api/location/44418/2013/4/27/"
    
    var resp: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadWeather()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func loadWeather(){
        let url: URL = URL.init(string: urlStr)!
        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
            guard let data = data else { return }
            self.resp = String(data: data, encoding: .utf8)!
            JSONSerialization.jsonObject(with: self.resp)
        }
        
        task.resume()
    }

    @IBAction func displayNextDay(_ sender: UIButton) {
    }
    
    
    @IBAction func displayPreviousDay(_ sender: UIButton) {
    }
}

