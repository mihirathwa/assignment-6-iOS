//
//  CallServerMethods.swift
//  Placeman
//
//  Created by mrathwa on 4/5/17.
//  Copyright © 2017 mrathwa. All rights reserved.
//

import Foundation

class CallServerMethods {
    var viewControllerRef: ViewController
    
    init(callingView: ViewController){
        self.viewControllerRef = callingView
    }
    
    
    func callGetNames(){
        let asyncConnect:MakeHttpConnection = MakeHttpConnection(stringURL: stringURL)
        
        let _:Bool = asyncConnect.getAllPlaces(callback: {(res: String, error: String?) -> Void in
            if error != nil {
                NSLog("Error", error!)
            }
            else {
                NSLog(res)
                
                if let data: Data = res.data(using: String.Encoding.utf8) {
                    do {
                        let dict = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:AnyObject]
                        
                        _placeArray = (dict!["result"] as? [String])!
                        viewControllerRef.mainTableView.reloadData()
                    } catch {
                        print("invalid data format received")
                    }
                }
            }
        })
    }
}
