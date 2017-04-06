//
//  MakeHttpConnection.swift
//  Placeman
//
//  Created by mrathwa on 4/4/17.
//  Copyright © 2017 mrathwa. All rights reserved.
//

import Foundation

class MakeHttpConnection {
    let url:String = "http://localhost:8080"
    
    init() {
        getStringURL()
    }
    
    func getStringURL(){
//        let infoPlist = Bundle.main.infoDictionary
//        let cfBundleURL = infoPlist?["CFBundleURLTypes"] as? [String]
//        let urlDict = cfBundleURL as? Dictionary<String, String>
//        
//        let myURL = urlDict?["CFBundleURLName"]
        
        let urlTypesArray = Bundle.main.object(forInfoDictionaryKey: "CFBundleURLTypes")
        
        //let urlValue = urlTypesArray[0]["CFBundleURLName"]
        
        print("URL Value -->")
    }
    
    func asyncHttpPostJSON(url: String, data: Data, completion: @escaping (String, String?) -> Void) {
        let request = NSMutableURLRequest(url: NSURL(string: url)! as URL)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpBody = data
        
        HTTPsendRequest(request: request, callback: completion)
    }
    
    func HTTPsendRequest(request: NSMutableURLRequest, callback: @escaping (String, String?) -> Void) {
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            (data, response, error) -> Void in
            if (error != nil) {
                callback("", error!.localizedDescription)
            }
            else {
                DispatchQueue.main.async(execute: {callback(NSString(data: data!, encoding: String.Encoding.utf8.rawValue)! as String, nil)})
            }
        }
        task.resume()
    }
    
    func getPlaceDescription(name: String, callback: @escaping (String, String?) -> Void) -> Bool {
        var ret:Bool = false
        
        do {
            let dict:[String:Any] = ["jsonrpc":"2.0", "method":"get", "params":[name], "id":"3"]
            
            let reqData:Data = try JSONSerialization.data(withJSONObject: dict, options: JSONSerialization.WritingOptions(rawValue: 0))
            self.asyncHttpPostJSON(url: self.url, data: reqData, completion: callback)
            ret = true
        } catch let error as NSError {
            print(error)
        }
        return ret
    }
    
    func getAllPlaces(callback: @escaping (String, String?) -> Void) -> Bool {
        var ret:Bool = false
        
        do {
            let dict:[String:Any] = ["jsonrpc":"2.0", "method":"getNames", "params": [ ], "id":"3"]
            let reqData:Data = try JSONSerialization.data(withJSONObject: dict, options: JSONSerialization.WritingOptions(rawValue: 0))
            self.asyncHttpPostJSON(url: self.url, data: reqData, completion: callback)
            ret = true
        } catch let error as NSError {
            print(error)
        }
        return ret
    }
    
    func removePlace(name: String, callback: @escaping (String, String?) -> Void) -> Bool {
        var ret:Bool = false
        
        do {
            let dict:[String:Any] = ["jsonrpc":"2.0", "method":"remove", "params":[name], "id":"3"]
            
            let reqData:Data = try JSONSerialization.data(withJSONObject: dict, options: JSONSerialization.WritingOptions(rawValue: 0))
            self.asyncHttpPostJSON(url: self.url, data:reqData, completion: callback)
            ret = true
        } catch let error as NSError {
            print(error)
        }
        return ret
    }
    
    func addPlace(placeDict: [String:Any], callback: @escaping (String, String?) -> Void) -> Bool {
        var ret:Bool = false
        
        do {
            let dict:[String:Any] = ["jsonrpc":"2.0", "method":"add", "params":[placeDict], "id":"3"]
            
            let reqData:Data = try JSONSerialization.data(withJSONObject: dict, options: JSONSerialization.WritingOptions(rawValue: 0))
            self.asyncHttpPostJSON(url: self.url, data:reqData, completion: callback)
            ret = true
        } catch let error as NSError {
            print(error)
        }
        return ret
    }
    
}
