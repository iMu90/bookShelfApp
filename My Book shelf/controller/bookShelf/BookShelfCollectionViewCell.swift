//
//  BookShelfCollectionViewCell.swift
//  My Book shelf
//
//  Created by Muteb Alolayan on 14/08/2021.
//

import Foundation
import UIKit

class BookShelfCollectionCell: UICollectionViewCell {
    @IBOutlet weak var bookCover: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var authors: UILabel!
    @IBOutlet weak var bookDesc: UILabel!
    @IBOutlet weak var bookCategory: UILabel!
    @IBOutlet weak var publishedDate: UILabel!
    @IBOutlet weak var removeBookBtn: UIButton!
}
