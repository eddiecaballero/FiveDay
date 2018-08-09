//
//  PageViewController.swift
//  FiveDay
//
//  Created by Eddie Caballero on 7/27/18.
//  Copyright © 2018 Eddie Caballero. All rights reserved.
//

import UIKit

class PageViewController: UIPageViewController, UIPageViewControllerDelegate,UIPageViewControllerDataSource
{
    //MARK: Properties
    
    var pages = [UIViewController]()
    let pageControl = UIPageControl()
    
    var forecast: FiveDayWeatherForecast?
    var weatherIcons = [UIImage]()
    
    //Mark: Init
    
    override init(transitionStyle style: UIPageViewControllerTransitionStyle, navigationOrientation: UIPageViewControllerNavigationOrientation, options: [String : Any]? = nil)
    {
        super.init(transitionStyle: .scroll, navigationOrientation: navigationOrientation, options: options)
    }
    
    required init?(coder: NSCoder)
    {
        super.init(coder: coder)
    }
    
    
    //MARK: User Interface - Segmented Control
    
    func setupPageControl()
    {
        self.pageControl.frame = CGRect()
        self.pageControl.currentPageIndicatorTintColor = UIColor.red
        self.pageControl.pageIndicatorTintColor = UIColor.blue
        self.pageControl.numberOfPages = self.pages.count
        self.pageControl.currentPage = 0
        
        self.view.addSubview(self.pageControl)
        
        self.pageControl.translatesAutoresizingMaskIntoConstraints = false
        
        self.pageControl.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -5).isActive = true
        self.pageControl.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -20).isActive = true
        self.pageControl.heightAnchor.constraint(equalToConstant: 20).isActive = true
        self.pageControl.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
    }
    
    //MARK: Networking
    
    func getWeatherIcons()
    {
        guard let iconName0 = self.forecast?.list?[0]?.weather?[0]?.icon else {return}
        guard let iconName1 = self.forecast?.list?[1]?.weather?[0]?.icon else {return}
        guard let iconName2 = self.forecast?.list?[2]?.weather?[0]?.icon else {return}
        guard let iconName3 = self.forecast?.list?[3]?.weather?[0]?.icon else {return}
        guard let iconName4 = self.forecast?.list?[4]?.weather?[0]?.icon else {return}
        
        let iconNames = [iconName0, iconName1, iconName2, iconName3, iconName4]
        
        for iconName in iconNames
        {
            if let url = URL(string: "https://openweathermap.org/img/w/" + iconName + ".png")
            {
                let session = URLSession.shared
                
                let request = URLRequest(url: url)
                
                let downloadTask = session.downloadTask(with: request, completionHandler:
                { (localURL, response, error) in
                    
                    if localURL == nil || error != nil {return}
                    
                    guard let localURL = localURL else {return}
                    guard let data = NSData(contentsOf: localURL) else {return}
                    guard let image = UIImage(data: data as Data) else {return}
                    
                    self.weatherIcons.append(image)
                    
                    (self.childViewControllers[0] as! DayViewController).weatherIcons = self.weatherIcons
                })
                
                downloadTask.resume()
            }
        }
    }
    
    func getWeather(zipCode: String)
    {
        let key = "<ENTER API KEY HERE>"

        if let url = URL(string: "https://api.openweathermap.org/data/2.5/forecast?zip=" + zipCode + ",us&APPID=" + key)
        {
            let session = URLSession.shared
            
            let request = URLRequest(url: url)
            
            let dataTask = session.dataTask(with: request, completionHandler:
            { (data, response, error) in
                
                if data == nil || error != nil {return}
                
                guard let data = data else {return}

                do
                {
                    self.forecast = try JSONDecoder().decode(FiveDayWeatherForecast.self, from: data)
                }
                catch let jsonErr
                {
                    print(jsonErr)
                }
                
                (self.childViewControllers[0] as! DayViewController).forecast = self.forecast //set from jsondecoder
                
                self.getWeatherIcons()
            })
            
            dataTask.resume()
        }
    }
    
    //MARK: View Lifecycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.delegate = self
        self.dataSource = self
        
        let day1 = DayViewController()
        let day2 = DayViewController()
        let day3 = DayViewController()
        let day4 = DayViewController()
        let day5 = DayViewController()
        
        self.pages = [day1, day2, day3, day4, day5]
        
        setViewControllers([pages[0]], direction: .forward, animated: true, completion: nil)
        
        setupPageControl()
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        
        Alert.showUserInput(title: "Ready for the weather?", message: "All we need is your zipcode.", placeHolder: "Please enter your zipcode", viewController: self, function: getWeather)
    }
    
    //MARK: PageViewController - Delegates and DataSource
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController?
    {
        if let viewControllerIndex = self.pages.index(of: viewController)
        {
            if viewControllerIndex > 0
            {
                return self.pages[viewControllerIndex - 1]
            }
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController?
    {
        if let viewControllerIndex = self.pages.index(of: viewController)
        {
            if viewControllerIndex < self.pages.count - 1
            {
                return self.pages[viewControllerIndex + 1]
            }
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool)
    {
        if let viewControllers = pageViewController.viewControllers
        {
            if let viewControllerIndex = self.pages.index(of: viewControllers[0])
            {
                self.pageControl.currentPage = viewControllerIndex
            }
        }

        for vc in pageViewController.viewControllers!
        {
            if self.forecast == nil || self.weatherIcons.isEmpty {return}
            
            (vc as! DayViewController).forecast = self.forecast
            (vc as! DayViewController).weatherIcons = self.weatherIcons
        }
    }
}
