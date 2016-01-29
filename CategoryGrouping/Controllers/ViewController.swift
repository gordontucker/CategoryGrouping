//
//  ViewController.swift
//  CategoryGrouping
//
//  Created by Gordon Tucker on 1/28/16.
//
//

import UIKit
import Alamofire

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView:UITableView!
    
    var categories:[Category] = []
    var offsets:[CGFloat] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // We need to make some fake categories
        var categories:[Category] = []
        var offsets:[CGFloat] = []
        for i in 1...15 {
            let category:Category = Category.generateCategory(i, name: "Category \(i)")
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
        
        cell.categoryNameLabel.text = category.name
        
        cell.setCollectionViewDataSourceDelegate(self, forRow: indexPath.row)
        cell.collectionViewOffset = self.offsets[indexPath.row] ?? 0
    }

    func tableView(tableView: UITableView, didEndDisplayingCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        guard let cell:CategoryTableViewCell = cell as? CategoryTableViewCell else { return }
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
        
        cell.tag = item.id
        if item.image == nil {
            Alamofire.request(.GET, "http://dummyimage.com/224x300&text=\(item.name)").response() {
                [weak cell] (_, _, data, _)  in
                
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
        
        print("Selected '\(item.name)' on collection \(collectionView.tag)")
    }
}