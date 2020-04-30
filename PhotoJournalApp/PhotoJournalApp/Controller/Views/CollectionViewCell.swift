//
//  CollectionViewCell.swift
//  PhotoJournalApp
//
//  Created by Tanya Burke on 2/19/20.
//  Copyright © 2020 Tanya Burke. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var photoViem: UIImageView!
    
    @IBOutlet weak var descriptionText: UILabel!
    @IBOutlet weak var editDescription: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    //need protocol
    //need variable the conforms to it
    //call on the delegate function when ever the button gets pressed
    
    //make the cell a delegate
    //cell.delegate = self
}
