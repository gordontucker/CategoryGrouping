//
//  Item.swift
//  CategoryGrouping
//
//  Created by Gordon Tucker on 1/28/16.
//
//

import UIKit

/* Represents a single item in an category */
class Item: NSObject {
    /* The cached image. We may want to move this to using a file system instead of inline, but for now this shows pretty good for the demo */
    var image:UIImage?
    /* I was using this to log when you select an item to make sure that was working */
    var name:String!
    /* This is used to uniquely identify an item. This prevents problems loading the wrong image in the collection/table views */
    var id:Int = 0
    var originalPrice:String!
    var discountPrice:String!
}
