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
    class func generateCategory(categoryIndex:Int, name:String) -> Category {
        
        let category:Category = Category()
        category.name = name
        for i in 1...15 {
            let item = Item()
            item.name = "Item\(categoryIndex)-\(i)"
            item.id = Int(arc4random_uniform(UInt32.max))
            
            category.items.append(item)
        }
        return category
    }
}
