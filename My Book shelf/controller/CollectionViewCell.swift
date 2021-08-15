//
//  CollectionViewCell.swift
//  My Book shelf
//
//  Created by Muteb Alolayan on 12/08/2021.
//

import Foundation
import UIKit

class CollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var bookCoverImage: UIImageView!
    @IBOutlet weak var bookTitle: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var authorNames: UILabel!
    @IBOutlet weak var bookDesc: UILabel!
    @IBOutlet weak var bookCategory: UILabel!
    @IBOutlet weak var publishedDate: UILabel!
    
    
    @IBOutlet weak var addToFavioriate: UIButton!
}
