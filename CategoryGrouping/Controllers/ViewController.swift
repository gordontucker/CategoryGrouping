//
//  ViewController.swift
//  CategoryGrouping
//
//  Created by Gordon Tucker on 1/28/16.
//
//

import UIKit
import Alamofire
import TouchVisualizer

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView:UITableView!
    @IBOutlet weak var logoImageView: UIImageView!
    
    var categories:[Category] = []
    var offsets:[CGFloat] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Visualizer.start()
        
        self.logoImageView.image = self.logoImageView.image?.imageWithRenderingMode(.AlwaysTemplate)
        self.logoImageView.tintColor = UIColor.whiteColor()
        
        // We need to make some fake categories
        var categories:[Category] = []
        let categoryNames:[String] = ["NEW DEALS", "POPULAR", "ENDING SOON", "ACCESSORIES", "BABY", "CLOTHING", "HOME DECOR", "KIDS", "MISC"]
        var offsets:[CGFloat] = []
        for i in 0...8 {
            let category:Category = Category.generateCategory(i + 1, name: categoryNames[i])
            categories.append(category)
            offsets.append(CGFloat(0))
        }
        self.categories = categories
        self.offsets = offsets
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.categories.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCellWithIdentifier("categoryCell", forIndexPath: indexPath)
    }

    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        guard let cell:CategoryTableViewCell = cell as? CategoryTableViewCell else { return }
        
        let category:Category = self.categories[indexPath.row]
        
        // Rows on the table only do two things. They set the category name and they initialize the collection view's delegate/datasource
        cell.categoryNameLabel.text = category.name
        cell.setCollectionViewDataSourceDelegate(self, forRow: indexPath.row)
        
        // When you load a cell, revert it to the last scroll position for this row
        cell.collectionViewOffset = self.offsets[indexPath.row] ?? 0
    }

    func tableView(tableView: UITableView, didEndDisplayingCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        guard let cell:CategoryTableViewCell = cell as? CategoryTableViewCell else { return }
        
        // This cell just scrolled out of view, so get the position its collection view is scrolled to so we can return to that later
        self.offsets[indexPath.row] = cell.collectionViewOffset
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 188
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let category:Category = self.categories[collectionView.tag]
        return category.items.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCellWithReuseIdentifier("itemCell", forIndexPath: indexPath)
    }
    
    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        
        guard let cell:ItemCollectionViewCell = cell as? ItemCollectionViewCell else { return }

        let category:Category = self.categories[collectionView.tag]
        let item = category.items[indexPath.item]
        
        // Load the image on the item here. If nil, it will blank the image until loaded later
        cell.imageView.image = item.image
        
        cell.discountPriceLabel.text = item.discountPrice
        cell.originalPriceLabel.text = item.originalPrice
        
        cell.tag = item.id
        
        // If we don't have an image, load it in the background here
        if item.image == nil {
            // For now, we are using an image generator so we can see images
            let url = "http://lorempixel.com/220/320/?unique=\(item.id)"
            //let url = "https://jane.com/cdn.jane/img/deals/\(item.id)_thumb.jpg"
            Alamofire.request(.GET, url).response() {
                [weak cell] (_, _, data, _)  in
                
                // Update the item's image.
                let image = UIImage(data: data!)
                item.image = image
                
                // Make sure the cell is still around and that it contains the same item still
                if let cell = cell where cell.tag == item.id {
                    cell.imageView.image = image
                }
            }
        }
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        collectionView.deselectItemAtIndexPath(indexPath, animated: true)
        
        let category:Category = self.categories[collectionView.tag]
        let item = category.items[indexPath.item]
        
        // Tell the user they tapped this item!
        let alert = UIAlertController(title: "Item Selected", message: "You just selected \(item.name)", preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
}