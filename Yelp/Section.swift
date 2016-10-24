//
//  Section.swift
//  Yelp
//
//  Created by Ryan Chee on 10/23/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import Foundation

class Section: NSObject {
    var heading : String
    var items : AnyObject
    
    init(title: String, objects : AnyObject) {
        heading = title
        items = objects
    }
}
