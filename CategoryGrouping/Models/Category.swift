//
//  Category.swift
//  CategoryGrouping
//
//  Created by Gordon Tucker on 1/28/16.
//
//

import UIKit

/* A category has a collection of items */
class Category: NSObject {
    var name:String!
    var items:[Item] = []
    
    /* Generate a random set of 15 items in a category */
    class func generateCategory(name:String, categoryLoaded:((category:Category) -> ())) {
        
        let category:Category = Category()
        category.name = name
        for i in 0...15 {
            Item.generateItem("Item Number \(i)") { (item) -> () in
                category.items.append(item)
                print("\(category.items.count)")
                if (category.items.count == 15) {
                    // We finished loading all items! Hurray!
                    categoryLoaded(category: category)
                }
            }
        }
    }
}
