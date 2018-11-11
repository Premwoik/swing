//
//  ForecastData.swift
//  WojtasikPrognozaPogody
//
//  Created by PW on 23/10/2018.
//  Copyright © 2018 RS KIS.EDU. All rights reserved.
//

import Foundation
import UIKit

private struct CityWeatherResponse: Codable {
    let consolidatedWeather: [DayWeatherForecast]

    enum CodingKeys: String, CodingKey {
        case consolidatedWeather = "consolidated_weather"
    }
}

struct DayWeatherForecast: Codable {
    let id: Int
    let weatherStateName, weatherStateAbbr, windDirectionCompass, created: String
    let applicableDate: String
    let minTemp, maxTemp, theTemp, windSpeed: Double
    let windDirection, airPressure: Double
    let humidity: Int
    let visibility: Double
    let predictability: Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case weatherStateName = "weather_state_name"
        case weatherStateAbbr = "weather_state_abbr"
        case windDirectionCompass = "wind_direction_compass"
        case created
        case applicableDate = "applicable_date"
        case minTemp = "min_temp"
        case maxTemp = "max_temp"
        case theTemp = "the_temp"
        case windSpeed = "wind_speed"
        case windDirection = "wind_direction"
        case airPressure = "air_pressure"
        case humidity, visibility, predictability
    }
}

struct CityData: Codable {
    let title: String
    let woeid: Int
    
    enum CodingKeys: String, CodingKey {
        case title
        case woeid
    }
}

typealias CitiesData = [CityData]


protocol CityDataProt{
    func updateCitiesData(data: CitiesData)
    
}

protocol WeatherData{
    func updateWeatherData(data: [DayWeatherForecast])
    func updateWeatherImg(img: UIImage)
}


class CityClient{
    let apiUrl: String = "https://www.metaweather.com/api/"
    var owner: CityDataProt
    
    init(owner: CityDataProt) {
        self.owner = owner
    }
    
    func searchForCity(cityName: String){
        let url: URL = URL.init(string: apiUrl + "location/search/?query=" + cityName)!
        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
            guard let data = data else { return }
            do{
                let responseObj = try JSONDecoder().decode(CitiesData.self, from: data)
                DispatchQueue.main.async{
                    self.owner.updateCitiesData(data: responseObj)
                }
            }
            catch{
                print("\(error)")
            }
        }
        task.resume()
        
    }
}


class WeatherClient{
    
    let apiUrl: String = "https://www.metaweather.com/api/"
    let staticUrl: String = "https://www.metaweather.com/static/"
    var weatherForecast: [DayWeatherForecast]?
    var owner: WeatherData
    
    init(owner: WeatherData) {
        self.owner = owner
    }
    
    func getCityWeather(cityCode: String){
        let url: URL = URL.init(string: apiUrl + "location/" + cityCode)!
        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
            guard let data = data else { return }
            do{
            let responseObj = try JSONDecoder().decode(CityWeatherResponse.self, from: data)
                DispatchQueue.main.async{
                    self.owner.updateWeatherData(data: responseObj.consolidatedWeather)
                }
            }
            catch{
                print("\(error)")
            }
        }
        task.resume()
    }
    
    func getWeatherStateIcon(abbreviation: String){
        let url: URL = URL.init(string: staticUrl + "img/weather/png/\(abbreviation).png")!
        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
            guard let data = data else {return}
            DispatchQueue.main.async{
                let img = UIImage(data: data)
                self.owner.updateWeatherImg(img: img!)
            }
        }
        task.resume()
    }
}
