//
//  Item.swift
//  CategoryGrouping
//
//  Created by Gordon Tucker on 1/28/16.
//
//

import UIKit
import Alamofire

/* Represents a single item in an category */
class Item: NSObject {
    var image:UIImage!
    var name:String!
    
    /* Generate a random item */
    class func generateItem(name:String, imageLoaded:((item:Item) -> ())) {
        //http://lorempixel.com/108/148/fashion/
        Alamofire.request(.GET, "http://lorempixel.com/108/148/fashion/").response() {
            (_, _, data, _) in
            
            let image = UIImage(data: data!)
            let item = Item()
            item.image = image
            item.name = name
            
            // We aren't handling exceptions here right now, this is just for making a fake item
            
            imageLoaded(item: item)
        }
    }
}
