//
//  ViewController.swift
//  MeetMeUp
//
//  Created by joy on 6/13/16.
//  Copyright © 2016 JanL. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var meetups: [NSDictionary]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        let url = NSURL(string: "https://api.meetup.com/2/open_events.json?zip=60604&text=mobile&time=,1w&key=76135e6231206b5e603e435e20152a12")
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithURL(url!) { (data: NSData?, response:NSURLResponse?, error:NSError?) in
            do {
                
//                we're creating a variable (JSONDictionary) to assign the contents of the JSON data to the variable
                
                let JSONDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments) as!
                    NSDictionary
                
//                we need to access whatevers at the other end of the key within the JSON dictionary (web) - we're accessing the value by using the key ("results") and using that to assign to self.meetups
                self.meetups = JSONDictionary.valueForKey("results") as! [NSDictionary]
            
                
            } catch let error as NSError {
                print("JSON Error: \(error.localizedDescription)")
            }
            dispatch_async(dispatch_get_main_queue(), {
                
                self.tableView.reloadData()
            })
        }
        task.resume()
    }

    
   
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
        let cell = tableView.dequeueReusableCellWithIdentifier("CellID", forIndexPath: indexPath)
        let meetupGroup = meetups?[indexPath.row]
        cell.textLabel?.text = meetupGroup?["name"] as? String
        cell.detailTextLabel?.text = meetupGroup?["description"] as? String
        
        return cell
        
    }
    
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return meetups?.count
    }
   


}

