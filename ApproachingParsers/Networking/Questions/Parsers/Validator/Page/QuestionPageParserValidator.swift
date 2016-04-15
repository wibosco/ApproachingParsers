//
//  QuestionPageParserValidator.swift
//  ApproachingParsers
//
//  Created by William Boles on 15/04/2016.
//  Copyright © 2016 Boles. All rights reserved.
//

import CoreData
import CoreDataServices

class QuestionPageParserValidator: Parser {

    //MARK: Accessors
    
    private lazy var questionParsers: Array<QuestionParserValidator> = {
        let questionParsers = Array<QuestionParserValidator>()
        
        return questionParsers
    }()
    
    //MARK: Validate
    
    func validate(response: Dictionary<String, AnyObject>) -> Bool {
        guard let questionResponses = response["items"] as? Array<Dictionary<String, AnyObject>> else {
            return false
        }
        
        /*---------------*/
        
        for questionResponse in questionResponses {
            
            let questionParser = QuestionParserValidator.init(managedObjectContext: self.localManagedObjectContext)
            
            if !questionParser.validate(questionResponse) {
                return false
            }
            
            self.questionParsers.append(questionParser)
        }
        
        /*---------------*/
        
        return true
    }
    
    //MARK: Parse
    
    func parsePage() -> Page {
        let page =  NSEntityDescription.insertNewObjectForEntity(Page.self, managedObjectContext: self.localManagedObjectContext) as! Page
        
        for index in (0..<self.questionParsers.count) {
            let questionParser = questionParsers[index]
            
            let question = questionParser.parseQuestion()
            question.index = index
            
            if (question.page == nil) {
                question.page = page
            } else {
                page.fullPage = false
            }
        }
        
        return page
    }
}
