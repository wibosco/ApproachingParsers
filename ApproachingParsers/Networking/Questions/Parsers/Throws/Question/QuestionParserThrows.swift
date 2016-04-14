//
//  QuestionParserThrows.swift
//  ApproachingParsers
//
//  Created by William Boles on 14/04/2016.
//  Copyright © 2016 Boles. All rights reserved.
//

import CoreData
import CoreDataServices

class QuestionParserThrows: Parser {

    //MARK: Questions
    
    func parseQuestions(questionsRetrievalResponse: Dictionary<String, AnyObject>) throws -> Page {
        let page = NSEntityDescription.insertNewObjectForEntity(Page.self, managedObjectContext: self.localManagedObjectContext) as! Page
        
        do {
            let questionResponses = try self.valueForNonOptionalProperty(questionsRetrievalResponse, key: "items") as! Array<Dictionary<String, AnyObject>>
            
            for index in (0..<questionResponses.count) {
                let questionResponse = questionResponses[index]
                
                let question = try self.parseQuestion(questionResponse)
                question.index = index
                
                if (question.page == nil) {
                    question.page = page
                } else {
                    page.fullPage = false
                }
            }

        } catch ParsingError.ExpectedValueNil(let parameter) {
             self.localManagedObjectContext.deleteObject(page)
            
            throw ParsingError.ExpectedValueNil(parameter: parameter)
        }
    
        return page
    }
    
    //MARK: Question
    
    func parseQuestion(questionResponse: Dictionary<String, AnyObject>) throws -> Question {
        
        var question: Question?
        
        do {
            let questionID = try self.valueForNonOptionalProperty(questionResponse, key: "question_id") as! NSInteger
            
            let predicate = NSPredicate(format: "questionID == \(questionID)")
            
            question = self.localManagedObjectContext.retrieveFirstEntry(Question.self, predicate: predicate) as? Question
            
            if (question == nil) {
                question = NSEntityDescription.insertNewObjectForEntity(Question.self, managedObjectContext: self.localManagedObjectContext) as? Question
                
                question?.questionID = questionID
            }
            
            /*----------------*/
            
            question?.title = try self.valueForNonOptionalProperty(questionResponse, key: "title") as? String
            
            /*----------------*/
            
            let authorResponse = try self.valueForNonOptionalProperty(questionResponse, key: "owner") as! Dictionary<String, AnyObject>
            
            let userParser = UserParserThrows(managedObjectContext: self.localManagedObjectContext)
            
            question?.author = try userParser.parseUser(authorResponse)
            
        } catch ParsingError.ExpectedValueNil(let parameter) {
            if question != nil {
                self.localManagedObjectContext.deleteObject(question!)
            }
            
            throw ParsingError.ExpectedValueNil(parameter: parameter)
        }
        
        return question!
    }
}
