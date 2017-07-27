//
//  UpdateViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Kinshuk Singh on 2017-07-12.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit
import Parse

class UpdateViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    //var iAm = "Man"
    //var interestedIn = "Women"
    
    @IBAction func logout(_ sender: Any) {
        
        performSegue(withIdentifier: "updateLogout", sender: self)
        
    }
    
    
    @IBOutlet weak var errorText: UILabel!
    
    @IBOutlet weak var image: UIImageView!
    
    @IBAction func uploadImageButton(_ sender: Any) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        imagePicker.allowsEditing = false
        
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            self.image.image = image
            
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var identitySwitch: UISwitch!
    
    @IBOutlet weak var seekSwitch: UISwitch!
    
    /*
    @IBAction func identitySwitchButton(_ sender: Any) {
        
        if identitySwitch.isOn {
        
            iAm = "Woman"
            
        } else {
        
            iAm = "Man"
            
        }
        
    }
    
    @IBAction func seekSwitchButton(_ sender: Any) {
        
        if seekSwitch.isOn {
        
            interestedIn = "Women"
            
        } else {
        
            interestedIn = "Men"
            
        }
     
    }
 */
    
    @IBAction func updateButton(_ sender: Any) {
        
        /*
        let update = PFObject(className: "UserInfo")
        
        update["identity"] = iAm
        update["seeking"] = interestedIn
        
        let imageData = UIImageJPEGRepresentation(image.image!, 1.0)
        let imageFile = PFFile(name: "image.png", data: imageData!)
        update["image"] = imageFile
        */
        
        PFUser.current()?["isFemale"] = identitySwitch.isOn
        PFUser.current()?["isInterestedinWomen"] = seekSwitch.isOn
        let imageData = UIImageJPEGRepresentation(image.image!, 1.0)
        PFUser.current()?["photo"] = PFFile(name: "image.png", data: imageData!)
        
        PFUser.current()?.saveInBackground { (success, error) in
            
            if error != nil {
            
                var errorMessage = "Couldn't update! Please try again later!"
                
                let error = error as NSError?
                
                if let parseError = error?.userInfo["error"] as? String {
                    
                    errorMessage = parseError
                    
                }
                
                self.errorText.text = errorMessage
                
            } else {
            
                print("Successfully Updated!")
                
                self.performSegue(withIdentifier: "updateToSwipe", sender: self)
                
            }
            
        }
        
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        if let isFemale = PFUser.current()?["isFemale"] as? Bool {
        
            identitySwitch.setOn(isFemale, animated: false)
            
        }
        
        if let isInterestedInWomen = PFUser.current()?["isInterestedInWomen"] as? Bool {
            
            identitySwitch.setOn(isInterestedInWomen, animated: false)
            
        }
        
        if let photo = PFUser.current()?["photo"] as? PFFile {
            
            photo.getDataInBackground(block: { (data, error) in
                
                if let imageData = data {
                
                    if let downloadImage = UIImage(data: imageData) {
                    
                        self.image.image = downloadImage
                        
                    }
                    
                }
                
            })
            
        }
        
        /* That's how we add a bunch of users at a go!!!
        let urlArray = ["http://www.polyvore.com/cgi/img-thing?.out=jpg&size=l&tid=1760886", "https://s-media-cache-ak0.pinimg.com/736x/78/97/3f/78973f7e1799871436f21f96af125b2e--female-cartoon-characters-cartoon-faces.jpg", "https://www.premadegraphics.com/wp-content/uploads/2016/01/female-characters-1-3.png?x84334", "http://images6.fanpop.com/image/polls/1462000/1462875_1426206361383_full.jpg?v=1426265789", "https://s-media-cache-ak0.pinimg.com/originals/65/8e/3e/658e3e85a4d99cca3c1246d6455eedef.jpg", "https://d1yn1kh78jj1rr.cloudfront.net/preview/girl-standing-business-cartoon-character-vector_zkMkVk_u_M.jpg", "http://static.vectorcharacters.net/uploads/2013/02/Young_Girl_Vector_Character_Preview.jpg", "https://image.freepik.com/free-vector/woman-cartoon-character_23-2147502478.jpg"]
        
        var counter = 0
        
        for urlString in urlArray {
            
            counter += 1
        
            let url = URL(string: urlString)!
            
            do {
             
                let data = try Data(contentsOf: url)
                
                let imageFile = PFFile(name: "photo.png", data: data)
                
                let user = PFUser()
                
                user["photo"] = imageFile
                
                user.username = String(counter)
                
                user.password = "password"
                
                user["isInterestedInWomen"] = true
                
                user["isFemale"] = false
                
                let acl = PFACL()
                acl.getPublicReadAccess = true
                user.acl = acl
                
                user.signUpInBackground(block: { (success, error) in
                    
                    if success {
                    
                        print("user signed up")
                        
                    }
                    
                })
                
            } catch {
            
                print("Coundn't get the data")
                
            }
        }
        */
        
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
