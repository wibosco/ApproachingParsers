//
//  QuestionParserGuardAndNil.swift
//  ApproachingParsers
//
//  Created by William Boles on 14/04/2016.
//  Copyright © 2016 Boles. All rights reserved.
//

import UIKit
import CoreData
import CoreDataServices

class QuestionParserGuardAndNil: Parser {
    
    //MARK: Questions
    
    func parseQuestions(questionsRetrievalResponse: Dictionary<String, AnyObject>) -> Page? {
        guard let questionResponses = questionsRetrievalResponse["items"] as? Array<Dictionary<String, AnyObject>> else {
            return nil
        }
        
        let page =  NSEntityDescription.insertNewObjectForEntity(Page.self, managedObjectContext: self.localManagedObjectContext) as! Page
        
        for index in (0..<questionResponses.count) {
            let questionResponse = questionResponses[index]
            
            let question = self.parseQuestion(questionResponse)
            
            if question != nil {
                question!.index = index
                
                if (question!.page == nil) {
                    question!.page = page
                } else {
                    page.fullPage = false
                }
            }
        }
        
        if page.questions!.count == 0 {
            return nil
        } else {
            return page
        }
    }
    
    //MARK: Question
    
    func parseQuestion(questionResponse: Dictionary<String, AnyObject>) -> Question? {
        guard let questionID = questionResponse["question_id"] as? NSInteger,
            let title = questionResponse["title"] as? String,
            let authorResponse = questionResponse["owner"] as? Dictionary<String, AnyObject> else {
                return nil
        }
        
        let predicate = NSPredicate(format: "questionID == \(questionID)")
        
        var question = self.localManagedObjectContext.retrieveFirstEntry(Question.self, predicate: predicate) as? Question
        
        if (question == nil) {
            question = NSEntityDescription.insertNewObjectForEntity(Question.self, managedObjectContext: self.localManagedObjectContext) as? Question
            
            question?.questionID = questionID
        }
        
        /*----------------*/
        
        question?.title = title
        
        /*----------------*/
        
        let userParser = UserParserGuardAndNil(managedObjectContext: self.localManagedObjectContext)
        
        question?.author = userParser.parseUser(authorResponse)
        
        /*----------------*/
        
        if question?.author == nil {
            self.localManagedObjectContext.deleteObject(question!)
            
            return nil
        } else {
            return question!
        }
    }
}
