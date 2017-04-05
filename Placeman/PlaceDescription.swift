// Copyright 2017 Mihir Rathwa,
//
// This license provides the instructor Dr. Tim Lindquist and Arizona
// State University the right to build and evaluate the package for the
// purpose of determining grade and program assessment.
//
// Purpose: This file contains the Place Description class as described
// in Assignment 1
//
// Ser423 Mobile Applications
// see http://pooh.poly.asu.edu/Mobile
// @author Mihir Rathwa Mihir.Rathwa@asu.edu
// Software Engineering, CIDSE, ASU Poly
// @version January 17, 2017

//  PlaceDescription.swift
//  Placeman
//
//  Created by mrathwa on 1/17/17.
//  Copyright © 2017 mrathwa. All rights reserved.
//

import Foundation

class PlaceDescription {
    private var _name: String
    
    var name: String {
        set { _name = name }
        get { return _name }
    }
    
    private var _description: String
    
    var description: String {
        set { _description = name }
        get { return _description }
    }
    
    private var _category: String
    
    var category: String {
        set { _category = category }
        get { return _category }
    }
    
    private var _address_title: String
    
    var address_title: String {
        set { _address_title = address_title }
        get { return _address_title }
    }
    
    private var _address_street: String
    
    var address_street: String {
        set { _address_street = address_street }
        get { return _address_street }
    }
    
    private var _elevation: Double
    
    var elevation: Double {
        set { _elevation = elevation }
        get { return _elevation }
    }
    
    private var _latitude: Double
    
    var latitude: Double {
        set { _latitude = latitude }
        get { return _latitude }
    }
    
    private var _longitude: Double
    
    var longitude: Double {
        set { _longitude = longitude }
        get { return _longitude }
    }
    
    init(name: String, description: String, category: String, address_title: String, address_street: String, elevation: Double, latitude: Double, longitude: Double){
        self._name = name
        self._description = description
        self._category = category
        self._address_title = address_title
        self._address_street = address_street
        self._elevation = elevation
        self._latitude = latitude
        self._longitude = longitude
    }
    
}
