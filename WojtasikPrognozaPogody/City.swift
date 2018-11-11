//
//  City.swift
//  WojtasikPrognozaPogody
//
//  Created by PW on 11/11/2018.
//  Copyright © 2018 RS KIS.EDU. All rights reserved.
//

import UIKit






class CityCell: UITableViewCell {
    
    @IBOutlet var img: UIImageView!
    @IBOutlet weak var temp: UILabel!
    @IBOutlet weak var title: UILabel!
    
}


class City : WeatherData {
  
    
    let name: String
    var img: UIImage?
    var temp: Double?
    let id: Int
    
    var api: WeatherClient?
    
    init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
    
    func load(){
        api = WeatherClient(owner: self)
        api!.getCityWeather(cityCode: String(id))
        
    }
    
    func updateWeatherData(data: [DayWeatherForecast]) {
        let day = data[0]
        let iconName = day.weatherStateAbbr
        temp = day.theTemp
        api!.getWeatherStateIcon(abbreviation: iconName)
    }
    
    func updateWeatherImg(img: UIImage) {
        self.img = img
    }
}
