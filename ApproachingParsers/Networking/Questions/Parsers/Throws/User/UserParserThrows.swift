//
//  UserParserThrows.swift
//  ApproachingParsers
//
//  Created by William Boles on 14/04/2016.
//  Copyright © 2016 Boles. All rights reserved.
//

import CoreData
import CoreDataServices

class UserParserThrows: Parser {

    //MARK: User
    
    func parseUser(userResponse: Dictionary<String, AnyObject>) throws -> User {
        var user: User?
        
        do {
            let userID = try self.valueForNonOptionalProperty(userResponse, key: "user_id") as! NSInteger
            
            let predicate = NSPredicate(format: "userID == \(userID)")
            
            user = self.localManagedObjectContext.retrieveFirstEntry(User.self, predicate: predicate) as? User
            
            if (user == nil) {
                user = NSEntityDescription.insertNewObjectForEntity(User.self, managedObjectContext: self.localManagedObjectContext) as? User
                
                user?.userID = userID
            }
            
            /*----------------*/
            
            user?.name = try self.valueForNonOptionalProperty(userResponse, key: "display_name") as? String
            
            /*----------------*/
            
        } catch ParsingError.ExpectedValueNil(let parameter) {
            if user != nil {
                self.localManagedObjectContext.deleteObject(user!)
            }
            
            throw ParsingError.ExpectedValueNil(parameter: parameter)
        }
        
        return user!
    }
}
