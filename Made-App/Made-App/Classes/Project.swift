//
//  Project.swift
//  Made-App
//
//  Created by Ira Dhar Gulati on 11/4/20.
//
import Foundation

class Project{
    var title = ""
    var category = ""
    var description = ""
    var instructions = ""
    var timeValue = 0
    var timeUnit = ""
    var difficulty = ""
    var images: [String] = []
    var uniqueID = ""
    var creationDate = ""
    var reviews: [Review] = []
    
    init(title: String, category: String, description: String, instructions: String, timeValue: Int, timeUnit: String, difficulty: String, images: [String], uniqueID: String, creationDate: String, reviews: [Review]) {
        self.title = title
        self.category = category
        self.description = description
        self.instructions = instructions
        self.timeValue = timeValue
        self.timeUnit = timeUnit
        self.difficulty = difficulty
        self.images = images
        self.uniqueID = uniqueID
        self.creationDate = creationDate
        self.reviews = reviews
    }
    
    init() {
        // empty initializer
    }
    
}
