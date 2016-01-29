//
//  CategoryTableViewCell.swift
//  CategoryGrouping
//
//  Created by Gordon Tucker on 1/28/16.
//
//

import UIKit

class CategoryTableViewCell: UITableViewCell {

    @IBOutlet weak var categoryNameLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    /* We want to be able to remember where collection views were scrolled to, so this abstraction allows the tableview controller to track it */
    var collectionViewOffset:CGFloat {
        get {
            return self.collectionView.contentOffset.x
        }
        set {
            self.collectionView.contentOffset.x = newValue
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    override func prepareForReuse() {
        // Clean up the cell when it is going to be reused
        self.categoryNameLabel.text = nil
        self.collectionViewOffset = 0
    }
}
