//
//  Alert.swift
//  FiveDay
//
//  Created by Eddie Caballero on 7/27/18.
//  Copyright © 2018 Eddie Caballero. All rights reserved.
//

import Foundation
import UIKit

class Alert
{
    class func showBasic(title: String, message: String, viewController: UIViewController)
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        viewController.present(alert, animated: true, completion: nil)
    }
    
    class func showUserInput(title: String, message: String, placeHolder: String, viewController: UIViewController, function: @escaping (String) -> Void)
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = placeHolder
        })
        
        //
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            
            if let input = alert.textFields?.first?.text
            {
                return function(input)
            }
        }))
        
        viewController.present(alert, animated: true)
    }
}
