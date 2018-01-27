//
//  UserCollectionViewCell.swift
//  CoreDataDemo
//
//  Created by Chainarong Chaiyaphat on 1/22/18.
//  Copyright © 2018 Chainarong Chaiyaphat. All rights reserved.
//

import UIKit

class UserCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblAge: UILabel!
    @IBOutlet weak var btnDelete: UIButton!
    
    func setupUserView(user:User){
        
        lblName.text = user.userName
        lblEmail.text = user.email
        lblAge.text = "Age : \(user.age) years"
        
        
    }
    
}
