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

var _placeArray: [String] = [String]()

var _segueIdentity = ""

class TableViewController: UITableViewController {
    
    @IBOutlet var mainTableView: UITableView!    

    override func viewDidLoad() {
        super.viewDidLoad()
                
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
            let placeName: String = _placeArray[indexPath.row]
            self.callRemovePlace(placeName: placeName)
            
            _placeArray.remove(at: indexPath.row)
            
            tableView.deleteRows(at: [indexPath], with: .fade)
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
        self.callGetNames()
        mainTableView.reloadData()
    }
    
    func callGetNames(){
        let asyncConnect:MakeHttpConnection = MakeHttpConnection()
        
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
                            self.mainTableView.reloadData()
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
    
}
