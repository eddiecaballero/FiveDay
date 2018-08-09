//
//  DayViewController.swift
//  FiveDay
//
//  Created by Eddie Caballero on 7/25/18.
//  Copyright © 2018 Eddie Caballero. All rights reserved.
//

import UIKit

class DayViewController: UIViewController
{
    //MARK: Properties
    
    var forecast: FiveDayWeatherForecast? {
        didSet{
            DispatchQueue.main.async
            {
                self.weatherText(self)
            }
        }
    }
    
    var weatherIcons = [UIImage]() {
        didSet{
            DispatchQueue.main.async
            {
                let currentPage = (self.parent as! PageViewController).pageControl.currentPage

                self.imageView.image = self.weatherIcons[currentPage]
            }
        }
    }
    
    var imageView = UIImageView()
    var segmentedControl = UISegmentedControl()
    var textView = UITextView()
    
    //MARK: Temperature Converters
    
    func celsius(kelvin: Double) -> Double
    {
        return ((kelvin - 273.15)*100).rounded()/100
    }
    
    func fahrenheit(kelvin: Double) -> Double
    {
        return ((kelvin * (9/5) - 459.67)*100).rounded()/100
    }
    
    //MARK: Target Action - TextView Text
    
    @objc func weatherText(_ sender: Any)
    {
        let currentPage = (self.parent as! PageViewController).pageControl.currentPage
        
        guard let temperatureKelvin = self.forecast?.list?[currentPage]?.main?.temp else {return}
        guard let maxTemperatureKelvin = self.forecast?.list?[currentPage]?.main?.temp_max else {return}
        guard let minTemperatureKelvin = self.forecast?.list?[currentPage]?.main?.temp_min else {return}
        
        guard let humidityRaw = self.forecast?.list?[currentPage]?.main?.humidity else {return}
        let humidity = String(humidityRaw) + "%"
        
        guard let weatherDescriptionRaw = self.forecast!.list![currentPage]!.weather![0]!.description else {return}
        let weatherDescription = weatherDescriptionRaw.capitalizingFirstLetter()
        
        guard let city = self.forecast?.city?.name else {return}
        
        let space = "\n\n"
        
        let isCelsiusSelectedSegment = self.segmentedControl.selectedSegmentIndex == 0 ? true : false
        
        let temperature = String(isCelsiusSelectedSegment ? self.celsius(kelvin: temperatureKelvin) : self.fahrenheit(kelvin: temperatureKelvin))
        let maxTemperature = String(isCelsiusSelectedSegment ? self.celsius(kelvin: maxTemperatureKelvin) : self.fahrenheit(kelvin: maxTemperatureKelvin))
        let minTemperature = String(isCelsiusSelectedSegment ? self.celsius(kelvin: minTemperatureKelvin) : self.fahrenheit(kelvin: minTemperatureKelvin))
        
        let boldAttributes = [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 20)]
        let plainAttributes = [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 15)]
        
        let attributedText = NSMutableAttributedString(string: "Place: " + space, attributes: boldAttributes)
        attributedText.append(NSMutableAttributedString(string: "City: " + city + space, attributes: plainAttributes))
        attributedText.append(NSMutableAttributedString(string: "Weather: " + space, attributes: boldAttributes))
        attributedText.append(NSMutableAttributedString(string: "Description: " + weatherDescription + space, attributes: plainAttributes))
        attributedText.append(NSMutableAttributedString(string: "Details: " + space, attributes: boldAttributes))
        attributedText.append(NSMutableAttributedString(string: "Temperature: " + temperature + space, attributes: plainAttributes))
        attributedText.append(NSMutableAttributedString(string: "Max Temperature: " + maxTemperature + space, attributes: plainAttributes))
        attributedText.append(NSMutableAttributedString(string: "Min Temperature: " + minTemperature + space, attributes: plainAttributes))
        attributedText.append(NSMutableAttributedString(string: "Humidity: " + humidity + space, attributes: plainAttributes))
        
        self.textView.attributedText = attributedText
    }
    
    //MARK: User Interface
    
    func setupUI()
    {
        //ImageView
        
        self.imageView.frame = CGRect()
        
        self.view.addSubview(self.imageView)
        
        self.imageView.translatesAutoresizingMaskIntoConstraints = false
        
        self.imageView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 8).isActive = true
        self.imageView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 8).isActive = true
        self.imageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        self.imageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        //SegmentedControl
        
        self.segmentedControl.frame = CGRect()
        self.segmentedControl.insertSegment(withTitle: "C°", at: 0, animated: true)
        self.segmentedControl.insertSegment(withTitle: "F°", at: 1, animated: true)
        self.segmentedControl.selectedSegmentIndex = 0
        
        self.segmentedControl.addTarget(self, action: #selector(weatherText), for: .valueChanged)
        
        self.view.addSubview(self.segmentedControl)
        
        self.segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        
        self.segmentedControl.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -8).isActive = true
        self.segmentedControl.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 8).isActive = true
        
        //TextView
        
        self.textView.frame = CGRect()
        self.textView.isEditable = false
        
        self.view.addSubview(self.textView)
        
        self.textView.translatesAutoresizingMaskIntoConstraints = false
        
        self.textView.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -8).isActive = true
        self.textView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.textView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        self.textView.topAnchor.constraint(equalTo: self.imageView.safeAreaLayoutGuide.bottomAnchor, constant: 8).isActive = true
    }
    
    //MARK: View Lifecycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.white

        self.setupUI()
    }
    
    override func viewDidLayoutSubviews()
    {
        self.textView.setContentOffset(.zero, animated: true)
    }
}

