//
//  WeatherManager.swift
//  Clima
//
//  Created by Wallace Santos on 09/05/22.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, _ weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager {
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=d973e9b7c70722ecc5317e5200a1c4e6&units=metric"
    
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(_ cityName:String){
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(with: urlString)
    }
    func fetchWeather( latitude:CLLocationDegrees,  longtute:CLLocationDegrees){
        let urlString = "\(weatherURL)&lon=\(longtute)&lat=\(latitude)"
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String){
        //1. Criar um URL
        guard let url = URL(string: urlString) else {return}
        //2. Criar um URLSession
        let session = URLSession(configuration: .default)
        //3.Dar a Sessão uma tarefa
        let task = session.dataTask(with: url) { data, response, error in
            if error != nil {
                print(error!)
                delegate?.didFailWithError(error: error!)
                return
            }
            guard let safeData = data else {return}
            guard let weather = self.parseJSON(safeData) else {return}
            delegate?.didUpdateWeather(self, weather)
        }
        //4.Começar a tarefa
        task.resume()
        
    }
    
    func parseJSON(_ weatherData: Data) -> WeatherModel?{
        let decoder = JSONDecoder()
        do{
            let decoderData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decoderData.weather[0].id
            let temp = decoderData.main.temp
            let name = decoderData.name
            
            let weather = WeatherModel(conditionId: id, citiName: name, temperatura: temp)
            return weather
            
            
        }catch{
            print(error)
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
    
}
