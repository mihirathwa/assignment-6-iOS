//// Copyright 2017 Mihir Rathwa,
//
// This license provides the instructor Dr. Tim Lindquist and Arizona
// State University the right to build and evaluate the package for the
// purpose of determining grade and program assessment.
//
// Purpose: This file contains the Place Library class as described
// in Assignment 4, initializing from a static JSON file for values of Places
//
// Ser423 Mobile Applications
// see http://pooh.poly.asu.edu/Mobile
// @author Mihir Rathwa Mihir.Rathwa@asu.edu
// Software Engineering, CIDSE, ASU Poly
// @version February 3, 2017

//  PlaceLibrary.swift
//  Placeman
//
//  Created by mrathwa on 3/2/17.
//  Copyright © 2017 mrathwa. All rights reserved.
//

import Foundation

class PlaceLibrary{
    
    private var _placeDictionary: [String: PlaceDescription]
    
    init () {
        self._placeDictionary = [String: PlaceDescription]()
        
        readJSONFile()
    }
    
    func readJSONFile() {
        
        do {
            let file: String = (Bundle.main.path(forResource: "places", ofType: "json"))!
            
            let data = try Data(contentsOf: URL(fileURLWithPath: file))
            
            let json = try JSONSerialization.jsonObject(with: data, options: [])
            
            if let jsonDictionary = json as? [String: Any]{
                
                for (placeKey, _) in jsonDictionary {
                    
                    if let placeDetails = jsonDictionary[placeKey] as? [String: Any] {
                        
                        for (_, _) in placeDetails {
                            
                            var jsonName = ""
                            var jsonDescription = ""
                            var jsonCategory = ""
                            var jsonAddress_title = ""
                            var jsonAddress_street = ""
                            var jsonElevation = 0.0
                            var jsonLatitude = 0.0
                            var jsonLongitude = 0.0
                            
                            jsonName = (placeDetails["name"] as? String)!
                            jsonDescription = (placeDetails["description"] as? String)!
                            jsonCategory = (placeDetails["category"] as? String)!
                            jsonAddress_title = (placeDetails["address-title"] as? String)!
                            jsonAddress_street = (placeDetails["address-street"] as? String)!
                            jsonElevation = (placeDetails["elevation"] as? Double)!
                            jsonLatitude = (placeDetails["latitude"] as? Double)!
                            jsonLongitude = (placeDetails["longitude"] as? Double)!
                            
                            let placeObject = PlaceDescription(name: jsonName, description: jsonDescription, category: jsonCategory, address_title: jsonAddress_title, address_street: jsonAddress_street, elevation: jsonElevation, latitude: jsonLatitude, longitude: jsonLongitude)
                            
                            _placeDictionary[placeKey] = placeObject
                            
                            
                        }
                    }
                }
            }
        }
        catch {
            NSLog(error.localizedDescription)
        }
    }
    
    func getPlaces() -> [String: PlaceDescription] {
        return _placeDictionary
    }
}
