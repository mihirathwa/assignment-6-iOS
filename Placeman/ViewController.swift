// Copyright 2017 Mihir Rathwa,
//
// This license provides the instructor Dr. Tim Lindquist and Arizona
// State University the right to build and evaluate the package for the
// purpose of determining grade and program assessment.
//
// Purpose: This file contains the View Controller class as described
// in Assignment 6, it displays the descriptions of Places with ability
// edit fields and remove places, all calls made to the JSON RPC Server
//
// Ser423 Mobile Applications
// see http://pooh.poly.asu.edu/Mobile
// @author Mihir Rathwa Mihir.Rathwa@asu.edu
// Software Engineering, CIDSE, ASU Poly
// @version February 3, 2017

//
//  ViewController.swift
//  Placeman
//
//  Created by mrathwa on 3/2/17.
//  Copyright © 2017 mrathwa. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var tfDescription: UITextField!
    @IBOutlet weak var tfCategory: UITextField!
    @IBOutlet weak var tfAddressTitle: UITextField!
    @IBOutlet weak var tfAddressStreet: UITextField!
    @IBOutlet weak var tfElevation: UITextField!
    @IBOutlet weak var tfLatitude: UITextField!
    @IBOutlet weak var tfLongitude: UITextField!
    
    @IBOutlet weak var pvPlaces: UIPickerView!
    @IBOutlet weak var lblDistance: UILabel!
    @IBOutlet weak var lblBearing: UILabel!
    
    var selectedPlace = ""
    
    var selectedPlaceLatitude:Double = 0.0
    var selectedPlaceLongitude:Double = 0.0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSLog("Selected Place in Table" + selectedPlace)
        
        let tappedAnyWhere: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.dismissOpenKeyboard))
        view.addGestureRecognizer(tappedAnyWhere)
        
        if _segueIdentity == "goToPlace" {
            pvPlaces.isHidden = false
            lblDistance.isHidden = false
            lblBearing.isHidden = false
            
            NSLog("Incoming Segue: " + _segueIdentity)
            callGetPlaceDescription(placeName: selectedPlace)
        }
        else if _segueIdentity == "addButtonSegue" {
            pvPlaces.isHidden = true
            lblDistance.isHidden = true
            lblBearing.isHidden = true
            
            NSLog("Incoming Segue: " + _segueIdentity)
        }
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func dismissOpenKeyboard(){
        self.view.endEditing(true)
    }
    
    @IBAction func clickedBtnRemove(_ sender: Any) {
        self.callRemovePlace(placeName: selectedPlace)
    }
    
    @IBAction func clickedBtnSave(_ sender: Any) {
        
        if validateTextFields() {
            NSLog("ViewController: ClickedButtonSave:: Adding Place")
            
            let newPlaceName: String = tfName.text!
            let newPlaceDescription: String = tfDescription.text!
            let newPlaceCategory: String = tfCategory.text!
            let newPlaceAddressTitle: String = tfAddressTitle.text!
            let newPlaceAddressStreet: String = tfAddressStreet.text!
            let newPlaceElevation: Double = Double(tfElevation.text!)!
            let newPlaceLatitude: Double = Double(tfLatitude.text!)!
            let newPlaceLongitude: Double = Double(tfLongitude.text!)!
            
            let placeDict: [String: Any] = [
                "name": newPlaceName,
                "description": newPlaceDescription,
                "category": newPlaceCategory,
                "address-title": newPlaceAddressTitle,
                "address-street": newPlaceAddressStreet,
                "elevation": newPlaceElevation,
                "latitude": newPlaceLatitude,
                "longitude": newPlaceLongitude
            ] as [String: Any]
            
            if _segueIdentity == "goToPlace" {
                self.callRemovePlace(placeName: selectedPlace)
            }
            
            self.callAddPlace(newPlace: placeDict)
            
            performSegue(withIdentifier: "gotoHomeScreen", sender: self)
            
        }
        else {
            NSLog("ViewController: ClickedButtonSave:: Missing Fields")
        }
        
    }
    
    func validateTextFields() -> Bool{
        let redBorderColor: UIColor = UIColor.red
        let greenBorderColor: UIColor = UIColor.green
        
        var isValidated = true
        
        if tfName.text == ""{
            tfName.layer.borderWidth = 1.5
            tfName.layer.borderColor = redBorderColor.cgColor
            tfName.placeholder = "required"
            isValidated = false
        }
        else {
            tfName.layer.borderColor = greenBorderColor.cgColor
            isValidated = true
        }
        
        if tfDescription.text == ""{
            tfDescription.layer.borderWidth = 1.5
            tfDescription.layer.borderColor = redBorderColor.cgColor
            tfDescription.placeholder = "required"
            isValidated = false
        }
        else {
            tfDescription.layer.borderColor = greenBorderColor.cgColor
            isValidated = true
        }
        
        if tfCategory.text == ""{
            tfCategory.layer.borderWidth = 1.5
            tfCategory.layer.borderColor = redBorderColor.cgColor
            tfCategory.placeholder = "required"
            isValidated = false
        }
        else {
            tfCategory.layer.borderColor = greenBorderColor.cgColor
            isValidated = true
        }
        
        if tfAddressTitle.text == ""{
            tfAddressTitle.layer.borderWidth = 1.5
            tfAddressTitle.layer.borderColor = redBorderColor.cgColor
            tfAddressTitle.placeholder = "required"
            isValidated = false
        }
        else {
            tfAddressTitle.layer.borderColor = greenBorderColor.cgColor
            isValidated = true
        }
        
        if tfAddressStreet.text == ""{
            tfAddressStreet.layer.borderWidth = 1.5
            tfAddressStreet.layer.borderColor = redBorderColor.cgColor
            tfAddressStreet.placeholder = "required"
            isValidated = false
        }
        else {
            tfAddressStreet.layer.borderColor = greenBorderColor.cgColor
            isValidated = true
        }
        
        if tfElevation.text == ""{
            tfElevation.layer.borderWidth = 1.5
            tfElevation.layer.borderColor = redBorderColor.cgColor
            tfElevation.placeholder = "required"
            isValidated = false
        }
        else {
            tfElevation.layer.borderColor = greenBorderColor.cgColor
            isValidated = true
        }
        
        if tfLatitude.text == ""{
            tfLatitude.layer.borderWidth = 1.5
            tfLatitude.layer.borderColor = redBorderColor.cgColor
            tfLatitude.placeholder = "required"
            isValidated = false
        }
        else {
            tfLatitude.layer.borderColor = greenBorderColor.cgColor
            isValidated = true
        }
        
        if tfLongitude.text == ""{
            tfLongitude.layer.borderWidth = 1.5
            tfLongitude.layer.borderColor = redBorderColor.cgColor
            tfLongitude.placeholder = "required"
            isValidated = false
        }
        else {
            tfLongitude.layer.borderColor = greenBorderColor.cgColor
            isValidated = true
        }
        
        return isValidated
    }
        
    func setPlaceDescriptionData(placeObject: PlaceDescription){
        tfName.text = placeObject.name
        tfDescription.text = placeObject.description
        tfCategory.text = placeObject.category
        tfAddressTitle.text = placeObject.address_title
        tfAddressStreet.text = placeObject.address_street
        tfElevation.text = String(placeObject.elevation)
        tfLatitude.text = String(placeObject.latitude)
        tfLongitude.text = String(placeObject.longitude)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return _placeArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return _placeArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        callGetGeoCoordinates(placeName: _placeArray[row])
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func calculateGreatCircle(firstLatitude: Double,
                              firstLongitude: Double,
                              secondLatitude: Double,
                              secondLongitude: Double) -> Double{
        var greatDistance: Double
        let toRadians: Double = M_PI / 180
        
        let rValue: Double = 6371 * pow(10, 3)
        
        let phi1: Double = firstLatitude * toRadians
        let phi2: Double = secondLatitude * toRadians
        
        let deltaPhi: Double = (secondLatitude - firstLatitude) * toRadians
        let deltaLambda: Double = (secondLongitude - firstLongitude) * toRadians
        
        let aValue: Double = sin(deltaPhi / 2) * sin(deltaPhi / 2) + cos(phi1) * cos(phi2) * sin(deltaLambda / 2) * sin(deltaLambda / 2)
        
        let cValue: Double = 2 * atan2(sqrt(aValue), sqrt(1-aValue))
        
        greatDistance = rValue * cValue
        
        return greatDistance
    }
    
    func calculateInitialBearing(firstLatitude: Double,
                                 firstLongitude: Double,
                                 secondLatitude: Double,
                                 secondLongitude: Double) -> Double{
        var bearing: Double
        
        let toRadians: Double = M_PI / 180
        
        let phi1: Double = firstLatitude * toRadians
        let lambda1: Double = firstLongitude * toRadians
        
        let phi2: Double = secondLatitude * toRadians
        let lambda2: Double = secondLongitude * toRadians
        
        let yValue: Double = sin(lambda2 - lambda1) * cos(phi2)
        let xValue: Double = cos(phi1) * sin(phi2) - sin(phi1) * cos(phi2) * cos(lambda2 - lambda1)
        
        let aTan2Value: Double = atan2(yValue, xValue)
        
        bearing = aTan2Value * ( 180 / M_PI )
        
        return bearing
    }
    
    func callGetPlaceDescription(placeName: String) {
        
        let asyncConnect:MakeHttpConnection = MakeHttpConnection()
        let _:Bool = asyncConnect.getPlaceDescription(name: placeName, callback: {(res: String, error: String?) -> Void in
            if error != nil {
                NSLog("Error", error!)
            }
            else {
                NSLog(res)
                if let data: Data = res.data(using: String.Encoding.utf8){
                    do {
                        let dict = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:AnyObject]
                        let jsonDict: [String:AnyObject] = (dict!["result"] as? [String:AnyObject])!
                        
                        let newPlaceName: String = jsonDict["name"] as! String
                        let newPlaceDesc: String = jsonDict["description"] as! String
                        let newPlaceCategory: String = jsonDict["category"] as! String
                        let newPlaceAddressTitle: String = jsonDict["address-title"] as! String
                        let newPlaceAddressStreet: String = jsonDict["address-street"] as! String
                        let newPlaceElevation: Double = jsonDict["elevation"] as! Double
                        let newPlaceLatitude: Double = jsonDict["latitude"] as! Double
                        let newPlaceLongitude: Double = jsonDict["longitude"] as! Double
                        
                        let placeObject: PlaceDescription = PlaceDescription(name: newPlaceName,
                                                                             description: newPlaceDesc,
                                                                             category: newPlaceCategory,
                                                                             address_title: newPlaceAddressTitle,
                                                                             address_street: newPlaceAddressStreet,
                                                                             elevation: newPlaceElevation,
                                                                             latitude: newPlaceLatitude,
                                                                             longitude: newPlaceLongitude)
                        
                        self.setPlaceDescriptionData(placeObject: placeObject)
                        
                        self.selectedPlaceLatitude = newPlaceLatitude
                        self.selectedPlaceLongitude = newPlaceLongitude
                        
                    } catch {
                        print("invalid data format received")
                    }
                }
            }
        })
    }
    
    func callGetGeoCoordinates(placeName: String) {
        let asyncConnect:MakeHttpConnection = MakeHttpConnection()
        let _:Bool = asyncConnect.getPlaceDescription(name: placeName, callback: {(res: String, error: String?) -> Void in
            if error != nil {
                NSLog("Error", error!)
            }
            else {
                NSLog(res)
                if let data: Data = res.data(using: String.Encoding.utf8){
                    do {
                        let dict = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:AnyObject]
                        let jsonDict: [String:AnyObject] = (dict!["result"] as? [String:AnyObject])!
                        
                        let newPlaceLatitude: Double = jsonDict["latitude"] as! Double
                        let newPlaceLongitude: Double = jsonDict["longitude"] as! Double
                        
                        let initialBearing: Double = self.calculateInitialBearing(firstLatitude: self.selectedPlaceLatitude,
                                                                                  firstLongitude: self.selectedPlaceLongitude,
                                                                                  secondLatitude: newPlaceLatitude,
                                                                                  secondLongitude: newPlaceLongitude)
                        
                        let greatCircle: Double = self.calculateGreatCircle(firstLatitude: self.selectedPlaceLatitude,
                                                                            firstLongitude: self.selectedPlaceLongitude,
                                                                            secondLatitude: newPlaceLatitude,
                                                                            secondLongitude: newPlaceLongitude)
                        
                        NSLog("Place: " + self.selectedPlace + "Initial Bearing: " + String(initialBearing))
                        NSLog("Place: " + self.selectedPlace + "Great Circle: " + String(greatCircle))
                        
                        self.lblDistance.text = String("Distance: " + String(initialBearing))
                        self.lblBearing.text = String("Initial Bearing: " + String(greatCircle))
                        
                    } catch {
                        print("invalid data format received")
                    }
                }
            }
        })
    }
    
    func callRemovePlace(placeName: String) {
        let asyncConnect:MakeHttpConnection = MakeHttpConnection()
        let _:Bool = asyncConnect.removePlace(name: placeName, callback: {(res: String, error: String?) -> Void in
            if error != nil {
                NSLog("Error", error!)
            }
            else {
                NSLog(res)
                if let data: Data = res.data(using: String.Encoding.utf8){
                    do {
                        let dict = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:AnyObject]
                        
                        if ((dict?["result"]) != nil){
                            NSLog("Place Removed")
                        }
                        else {
                            NSLog("Place is not removed")
                        }
                        
                    } catch {
                        print("invalid data format received")
                    }
                }
            }
        })
    }
    
    func callAddPlace(newPlace: [String:Any]) {
        let asyncConnect:MakeHttpConnection = MakeHttpConnection()
        let _:Bool = asyncConnect.addPlace(placeDict: newPlace , callback: {(res: String, error: String?) -> Void in
            if error != nil {
                NSLog("Error", error!)
            }
            else {
                NSLog(res)
                if let data: Data = res.data(using: String.Encoding.utf8){
                    do {
                        let dict = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:AnyObject]
                        
                        if ((dict?["result"]) != nil){
                            NSLog("Place Added")
                        }
                        else {
                            NSLog("Place is not added")
                        }
                        
                    } catch {
                        print("invalid data format received")
                    }
                }
            }
        })
    }
}

