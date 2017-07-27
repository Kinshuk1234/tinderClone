/**
* Copyright (c) 2015-present, Parse, LLC.
* All rights reserved.
*
* This source code is licensed under the BSD-style license found in the
* LICENSE file in the root directory of this source tree. An additional grant
* of patent rights can be found in the PATENTS file in the same directory.
*/

import UIKit
import Parse

class ViewController: UIViewController {
    
    var signupMode = true
    
    @IBOutlet weak var usernameText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    
    @IBOutlet weak var signupOrLoginText: UIButton!
    
    @IBAction func signupOrLoginButton(_ sender: Any) {
        
        if signupMode {
            
            let user = PFUser()
            user.username = usernameText.text
            user.password = passwordText.text
            
            
            /*let acl = PFACL()
            acl.getPublicReadAccess = true
            acl.getPublicReadAccess = true
            user.acl = acl*/
 
            
            user.signUpInBackground(block: { (success, error) in
                
                if error != nil {
                    
                    var errorMessage = "Sign up failed! Please try again later!"
                    
                    let error = error as NSError?
                    
                    if let parseError = error?.userInfo["error"] as? String {
                        
                        errorMessage = parseError
                        
                    }
                    
                    self.errorText.text = errorMessage
                    
                } else {
                    
                    print("user has successfully signed up")
                    
                    self.performSegue(withIdentifier: "signupUpdate", sender: self)
                    
                }
                
            })
            
        } else {
        
            
            PFUser.logInWithUsername(inBackground: usernameText.text!, password: passwordText.text!, block: { (user, error) in
                
                if error != nil {
                    
                    var errorMessage = "Log In failed! Please try again later!"
                    
                    let error = error as NSError?
                    
                    if let parseError = error?.userInfo["error"] as? String {
                        
                        errorMessage = parseError
                        
                    }
                    
                    self.errorText.text = errorMessage
                    
                } else {
                    
                    print("user has successfully logged in")
                    
                    self.redirect()
                    
                }
                
            })
            
        }
        
        
    }
    
    @IBOutlet weak var changeModeText: UIButton!
    
    @IBAction func changeModeButton(_ sender: Any) {
        
        if signupMode {
            
            signupMode = false
            signupOrLoginText.setTitle("Log In", for: [])
            changeModeText.setTitle("Sign Up", for: [])
            updateText.text = "Don't have an account?"
            
        } else {
            
            signupMode = true
            signupOrLoginText.setTitle("Sign Up", for: [])
            changeModeText.setTitle("Log In", for: [])
            updateText.text = "Already have an account?"
            
        }
        
    }
    
    /*override func viewDidAppear(_ animated: Bool) {
        
        if PFUser.current() != nil {
        
            performSegue(withIdentifier: "homeToSwipe", sender: self)
            
        }
        
    }*/
    
    @IBOutlet weak var updateText: UILabel!
    
    @IBOutlet weak var errorText: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    
        redirect()
        
    }
    
    func redirect() {
    
        if PFUser.current()?["isFemale"] != nil && PFUser.current()?["isInterestedInWomen"] != nil && PFUser.current()?["isInterestedInWomen"] != nil {
            
            performSegue(withIdentifier: "homeToSwipe", sender: self)
            
        } else {
            
            performSegue(withIdentifier: "signupUpdate", sender: self)
            
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}






















