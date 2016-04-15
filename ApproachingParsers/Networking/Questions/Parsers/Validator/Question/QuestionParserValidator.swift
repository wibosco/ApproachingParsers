//
//  QuestionParserValidator.swift
//  ApproachingParsers
//
//  Created by William Boles on 15/04/2016.
//  Copyright © 2016 Boles. All rights reserved.
//

import CoreData
import CoreDataServices

class QuestionParserValidator: Parser {
    
    //MARK: Accessors
    
    private var questionID: NSInteger?
    private var title: String?
    
    private lazy var userParser: UserParserValidator = {
        let userParser = UserParserValidator.init(managedObjectContext: self.localManagedObjectContext)
        
        return userParser
    }()
    
    //MARK: Validate
    
    func validate(response: Dictionary<String, AnyObject>) -> Bool {
        guard let questionID = response["question_id"] as? NSInteger,
            let title = response["title"] as? String,
            let authorResponse = response["owner"] as? Dictionary<String, AnyObject> else {
                return false
        }
        
        /*---------------*/
        
        self.questionID = questionID
        self.title = title
        
        /*---------------*/
        
        if !self.userParser.validate(authorResponse) {
            return false
        }
        
        return true
    }
    
    //MARK: Parse
    
    func parseQuestion() -> Question {
        let predicate = NSPredicate(format: "questionID == \(self.questionID!)")
        
        var question = self.localManagedObjectContext.retrieveFirstEntry(Question.self, predicate: predicate) as? Question
        
        if (question == nil) {
            question = NSEntityDescription.insertNewObjectForEntity(Question.self, managedObjectContext: self.localManagedObjectContext) as? Question
            
            question?.questionID = self.questionID
        }
        
        /*----------------*/
        
        question?.title = self.title
        
        /*----------------*/
        
        question?.author = self.userParser.parseUser()
        
        /*----------------*/
        
        return question!
    }
 
}
