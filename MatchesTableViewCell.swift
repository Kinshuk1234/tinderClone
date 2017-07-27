//
//  MatchesTableViewCell.swift
//  ParseStarterProject-Swift
//
//  Created by Kinshuk Singh on 2017-07-14.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit
import Parse

class MatchesTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var hiddenLabel: UILabel!
    
    @IBOutlet weak var userImageView: UIImageView!
    
    
    @IBOutlet weak var messageLabel: UILabel!
    
    @IBOutlet weak var messageText: UITextField!
    
    @IBAction func send(_ sender: Any) {
        
        let message = PFObject(className: "Message")
        
        message["sender"] = PFUser.current()?.objectId!
        
        message["recipient"] = hiddenLabel.text
        
        message["content"] = messageText.text
        
        message.saveInBackground()
        
    }
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
