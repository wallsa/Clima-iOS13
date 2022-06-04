//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreLocation



class WeatherViewController: UIViewController {
    
   
    
    
    
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    
    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        //Location data irá fazer uma requisição para acessar esse dado
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        //O searchTextField delega para a view(self)
        searchTextField.delegate = self
        
        weatherManager.delegate = self
    }
    
    @IBAction func locationPress(_ sender: Any) {
        //Requisita por uma veza localizacao do usuario
        //Temos que delegar antes de requistar uma localizacao se não teremos um erro
       
        locationManager.requestLocation()
        }
}


//MARK: - UITextFieldDelegate

extension WeatherViewController:UITextFieldDelegate{
    
    @IBAction func searchPress(_ sender: UIButton) {
        searchTextField.endEditing(true)
        print(searchTextField.text!)
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        print(searchTextField.text!)
        return true
    }
    //Hey ViewController o usuario parou de editar
    func textFieldDidEndEditing(_ textField: UITextField) {
        //Usar o texto que foi colocado para conseguir o clima da cidade digitada
        guard let city = searchTextField.text else {return}
        weatherManager.fetchWeather(city)
        searchTextField.text = "" // então limpe o campo de texto do search
    }
    //Hey ViewController o usuario tocou em outro lugar, oque devo fazer?
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != ""{
            return true
        }else{
            textField.placeholder = "Type something"
            return false
        }
    }
    
}

//MARK: - WeatherManagerDelegate


extension WeatherViewController:WeatherManagerDelegate{
    
    func didUpdateWeather(_ weatherManager: WeatherManager, _ weather: WeatherModel){
        print(weather.temperatureString)
        //Utilizado para atualizar a UI sem que o App congele pois estamos em um Completion Handler
        DispatchQueue.main.async {
            self.temperatureLabel.text = weather.temperatureString
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
            self.cityLabel.text = weather.citiName
            
        }
        
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}
//MARK: - LocationManagerDelegate


extension WeatherViewController:CLLocationManagerDelegate{
    
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //CLLocation é um array que guarda todas as localizacoes recebidas
        guard let locValue = locations.last else {return}
        locationManager.stopUpdatingLocation()
        print(locValue.coordinate.latitude)
        print(locValue.coordinate.longitude)
        weatherManager.fetchWeather(latitude: locValue.coordinate.latitude, longtute: locValue.coordinate.longitude)
        
        
        
        
    }

}
