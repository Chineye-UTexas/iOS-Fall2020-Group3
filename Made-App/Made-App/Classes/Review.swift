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
    
    var commentary = ""
    var timeValue = 0
    var timeUnit = ""
    var difficulty = ""
    var images: [String] = []
    var uniqueID = ""
    var creationDate = ""
    var rating = 0
    
    init(commentary: String, timeValue: Int, timeUnit: String, difficulty: String, images: [String], uniqueID: String, creationDate: String, rating: Int) {
        self.commentary = commentary
        self.timeValue = timeValue
        self.timeUnit = timeUnit
        self.difficulty = difficulty
        self.images = images
        self.uniqueID = uniqueID
        self.creationDate = creationDate
        self.rating = rating
    }
    
}
