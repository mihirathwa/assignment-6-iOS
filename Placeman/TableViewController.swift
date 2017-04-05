// Copyright 2017 Mihir Rathwa,
//
// This license provides the instructor Dr. Tim Lindquist and Arizona
// State University the right to build and evaluate the package for the
// purpose of determining grade and program assessment.
//
// Purpose: This file contains the TableView Controller class as described
// in Assignment 4, it displays the list of Places from JSON and updates on edits
//
// Ser423 Mobile Applications
// see http://pooh.poly.asu.edu/Mobile
// @author Mihir Rathwa Mihir.Rathwa@asu.edu
// Software Engineering, CIDSE, ASU Poly
// @version February 3, 2017
//
//  TableViewController.swift
//  Placeman
//
//  Created by mrathwa on 3/2/17.
//  Copyright © 2017 mrathwa. All rights reserved.
//

import UIKit

let placeLibraryObject = PlaceLibrary()

var _placeDictionary: [String: PlaceDescription] = placeLibraryObject.getPlaces()//[:]

var _placeArray: [String] = [String]()

var _segueIdentity = ""

let stringURL:String = "http://localhost:8080"

class TableViewController: UITableViewController {
    
    @IBOutlet var mainTableView: UITableView!    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //_placeArray = Array(_placeDictionary.keys)
        
        navigationItem.leftBarButtonItem = editButtonItem
        
        let plusButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add, target: self, action: #selector (TableViewController.addPlace))
        navigationItem.rightBarButtonItem = plusButton
        
        NSLog("TableViewController: viewDidLoad")
        
        self.callGetNames()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
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
                        self.mainTableView.reloadData()
                    } catch {
                        print("invalid data format received")
                    }
                }
            }
        })
    }
    
    func addPlace(){
        _segueIdentity = "addButtonSegue"
        performSegue(withIdentifier: "addButtonSegue", sender: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _placeArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = _placeArray[indexPath.row]

        return cell
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            _placeDictionary.removeValue(forKey: _placeArray[indexPath.row])
            _placeArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "goToPlace" {
            _segueIdentity = "goToPlace"
            let viewController:ViewController = segue.destination as! ViewController
            let indexPath = self.tableView.indexPathForSelectedRow!
            viewController.selectedPlace = _placeArray[indexPath.row]
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        NSLog("TableViewController: viewDidAppear")
        NSLog("Place Dictionary Keys: " + String(_placeDictionary.count))
        //_placeArray = Array(_placeDictionary.keys)
        self.callGetNames()
        mainTableView.reloadData()
    }
    
}
