//
//  TagParserValidator.swift
//  ApproachingParsers
//
//  Created by Home on 16/04/2016.
//  Copyright © 2016 Boles. All rights reserved.
//

import CoreData
import CoreDataServices

class TagParserValidator: Parser {

    //MARK: Accessors
    
    var name: String?
    
    //MARK: Validate
    
    func validate(response: String) -> Bool {
        if response.characters.count == 0 {
            return false
        }
        
        self.name = response
        
        return true
    }
    
    //MARK: Parse
    
    func parseTag() -> Tag {
        let predicate = NSPredicate(format: "name MATCHES '\(self.name!)'")
        
        var tag = self.localManagedObjectContext.retrieveFirstEntry(Tag.self, predicate: predicate) as? Tag
        
        if (tag == nil) {
            tag = NSEntityDescription.insertNewObjectForEntity(Tag.self, managedObjectContext: self.localManagedObjectContext) as? Tag
            
            tag?.name = self.name
        }
        
        return tag!
    }
}
