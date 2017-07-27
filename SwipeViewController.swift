//
//  SwipeViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Kinshuk Singh on 2017-07-13.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit
import Parse

class SwipeViewController: UIViewController {
    
    @IBAction func matchesButton(_ sender: Any) {
        
        performSegue(withIdentifier: "swipeToMatches", sender: self)
        
    }
    
    
    @IBOutlet weak var image: UIImageView!
    
    var displayUderID = ""
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "swipeToHome" {
        
            PFUser.logOut()
            
        }
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(self.wasDragged(gestureRecognizer:)))
        
        image.isUserInteractionEnabled = true
        
        image.addGestureRecognizer(gesture)
        
        PFGeoPoint.geoPointForCurrentLocation { (geoPoint, error) in
            
            if let geoPoint = geoPoint {
            
                PFUser.current()?["location"] = geoPoint
                
                PFUser.current()?.saveInBackground()
                
            }
            
        }
        
        updateImage()
    }
    
    func updateImage() {
    
        let query = PFUser.query()
        
        query?.whereKey("isFemale", equalTo: PFUser.current()?["isInterestedInWomen"])
        query?.whereKey("isInterestedInWomen", equalTo: PFUser.current()?["isFemale"])
        
        var ignoredUsers = [""]
        
        if let acceptedUsers = PFUser.current()?["accepted"] {
        
            ignoredUsers += acceptedUsers as! Array
            
        }
        
        if let rejectedUsers = PFUser.current()?["rejected"] {
            
            ignoredUsers += rejectedUsers as! Array
            
        }
        
        query?.whereKey("objectId", notContainedIn: ignoredUsers)
        
        if let latitude = (PFUser.current()?["location"] as AnyObject).latitude {
        
            if let londitude = (PFUser.current()?["location"] as AnyObject).longitude {
                
                // this is how we add location feature
                query?.whereKey("location", withinGeoBoxFromSouthwest: PFGeoPoint(latitude: latitude - 1, longitude: londitude - 1), toNortheast: PFGeoPoint(latitude: latitude + 1, longitude: londitude + 1))
                
            }
            
        }
        
        query?.limit = 1
        
        query?.findObjectsInBackground(block: { (objects, error) in
            
            if let users = objects {
            
                for object in users {
                
                    if let user = object as? PFUser {
                        
                        self.displayUderID = user.objectId!
                    
                        let imageFile = user["photo"] as! PFFile
                        
                        imageFile.getDataInBackground(block: { (data, error) in
                            
                            if let imageData = data {
                            
                                self.image.image = UIImage(data: imageData)
                                
                            }
                            
                        })
                        
                    }
                    
                }
                
            }
            
        })
        
        
    }
    
    func wasDragged(gestureRecognizer: UIPanGestureRecognizer) {
        
        let translation = gestureRecognizer.translation(in: view)
        
        let label = gestureRecognizer.view!
        
        label.center = CGPoint(x: self.view.bounds.width / 2 + translation.x, y: self.view.bounds.height / 2 + translation.y)
        
        let xFromCenter = label.center.x - self.view.bounds.width / 2
        
        var rotation = CGAffineTransform(rotationAngle: xFromCenter / 200)
        
        var scale = min(1, abs(100 / xFromCenter))
        
        var stretchAndRotation = rotation.scaledBy(x: scale, y: scale)
        
        label.transform = stretchAndRotation
        
        if gestureRecognizer.state == UIGestureRecognizerState.ended {
            
            var acceptedOrRejected = ""
            
            if label.center.x < 100 {
                
                acceptedOrRejected = "rejected"
                
            } else if label.center.x > self.view.bounds.width - 100 {
                
                acceptedOrRejected = "accepted"
                
            }
            
            if acceptedOrRejected != "" && displayUderID != "" {
                
                PFUser.current()?.addUniqueObjects(from: [displayUderID], forKey: acceptedOrRejected)
                
                PFUser.current()?.saveInBackground(block: { (success, error) in
                    
                    self.updateImage()
                    
                })
            }
            
            rotation = CGAffineTransform(rotationAngle: 0)
            
            stretchAndRotation = rotation.scaledBy(x: 1, y: 1)
            
            label.transform = stretchAndRotation
            
            label.center = CGPoint(x: self.view.bounds.width / 2, y: self.view.bounds.height / 2)
            
        }
        
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
