//
//  Project.swift
//  Made-App
//  CS 371L
//  Group 3
//
//  Created by Ira Dhar Gulati on 11/4/20.
//

import Foundation

class Review {
    
    var commentary = NSString()
    var images: NSArray = []
    var creationDate = NSString()
    var rating = NSNumber()
    
    init(commentary: NSString, images: NSArray, creationDate: NSString, rating: NSNumber) {
        self.commentary = commentary
        self.images = images
        self.creationDate = creationDate
        self.rating = rating
    }
    
}
