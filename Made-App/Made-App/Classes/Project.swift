//
//  Project.swift
//  Made-App
//
//  Created by Ira Dhar Gulati on 11/4/20.
//
import Foundation

class Project{
    var title = NSString()
    var category = NSString()
    var description = NSString()
    var instructions = NSString()
    var timeValue = NSNumber()
    var timeUnit = NSString()
    var difficulty = NSString()
    var images: NSArray = []
    var creationDate = NSString()
    var reviews: NSArray = []
    
    init(title: NSString, category: NSString, description: NSString, instructions: NSString, timeValue: NSNumber, timeUnit: NSString, difficulty: NSString, images: NSArray, creationDate: NSString, reviews: NSArray) {
        self.title = title
        self.category = category
        self.description = description
        self.instructions = instructions
        self.timeValue = timeValue
        self.timeUnit = timeUnit
        self.difficulty = difficulty
        self.images = images
        self.creationDate = creationDate
        self.reviews = reviews
    }
    
    init() {
        // empty initializer
    }
    
}
