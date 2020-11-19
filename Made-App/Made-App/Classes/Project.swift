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
    var timeValue = NSString()
    var timeUnit = NSString()
    var difficulty = NSString()
    var images: NSArray = []
    var creationDate = NSString()
    var username = NSString()
    var reviews: NSArray = []
    var firebaseProjectID = String()
    
    init(title: NSString, category: NSString, description: NSString, instructions: NSString, timeValue: NSString, timeUnit: NSString, difficulty: NSString, images: NSArray, creationDate: NSString, username: NSString, reviews: NSArray, firebaseProjectID: String) {
        self.title = title
        self.category = category
        self.description = description
        self.instructions = instructions
        self.timeValue = timeValue
        self.timeUnit = timeUnit
        self.difficulty = difficulty
        self.images = images
        self.creationDate = creationDate
        self.username = username
        self.reviews = reviews
        self.firebaseProjectID = firebaseProjectID
    }
    
    init() {
        // empty initializer
    }
    
}
