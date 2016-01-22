//
//  PhotosViewController.swift
//  Instagram
//
//  Created by Varun Vyas on 14/01/16.
//  Copyright © 2016 Varun Vyas. All rights reserved.
//

import UIKit

import MBProgressHUD

import AFNetworking

class PhotosViewController: UIViewController , UITableViewDataSource, UITableViewDelegate{

    @IBOutlet weak var tableView: UITableView!

    var instaImages: [NSDictionary]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 320
        
        tableView.dataSource = self
        tableView.delegate = self

        actualNetworkSessionGet()
        // Initialize a UIRefreshControl
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "refreshControlAction:", forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
     
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func actualNetworkSessionGet() {
        
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        
        let clientId = "e05c462ebd86446ea48a5af73769b602"
        let url = NSURL(string:"https://api.instagram.com/v1/media/popular?client_id=\(clientId)")
        let request = NSURLRequest(URL: url!)
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate:nil,
            delegateQueue:NSOperationQueue.mainQueue()
        )
        
        let task : NSURLSessionDataTask = session.dataTaskWithRequest(request,
            completionHandler: { (dataOrNil, response, error) in
                if let data = dataOrNil {
                    if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
                        data, options:[]) as? NSDictionary {
                            NSLog("response: \(responseDictionary)")
                            self.instaImages = responseDictionary["data"] as! [NSDictionary]
                            self.tableView.reloadData()
                    }
                }
                // Hide HUD once network request comes back (must be done on main UI thread)
                MBProgressHUD.hideHUDForView(self.view, animated: true)
        });
        task.resume()
    }
  
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let instaImages = instaImages {
            return instaImages.count /* - 1 Removing the last entry as poster_path was getting null resulting in app crash . Will fix it later! :) */
        }
        else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("InstaViewCell", forIndexPath: indexPath) as! InstaViewCell
        let movie = instaImages![indexPath.row]
        
        let baseUrl1 = movie["images"]!["low_resolution"]!!["url"] as! String
        print(baseUrl1)
        let imageUrl = NSURL(string: baseUrl1)
        cell.instaImageView.setImageWithURL(imageUrl!)
//
//        if let poster_path = movie["poster_path"] as? String {
//            let imageUrl = NSURL(string: baseUrl + poster_path)
//            cell.instaImageView.setImageWithURL(imageUrl!)
//        }
        //cell.textLabel!.text = title
        //print("row \(indexPath.row)")
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //NSLog("You selected cell number: \(indexPath.row)!")
        let cell = tableView.dequeueReusableCellWithIdentifier("InstaViewCell", forIndexPath: indexPath) as! InstaViewCell
        cell.selectionStyle = .Blue
        
        // Use a red color when the user selects the cell
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.cyanColor()
        cell.selectedBackgroundView = backgroundView
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
