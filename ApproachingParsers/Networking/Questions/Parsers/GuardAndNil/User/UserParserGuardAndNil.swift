//
//  UserParserGuardAndNil.swift
//  ApproachingParsers
//
//  Created by William Boles on 14/04/2016.
//  Copyright © 2016 Boles. All rights reserved.
//

import UIKit
import CoreData
import CoreDataServices

class UserParserGuardAndNil: Parser {
    
    //MARK: User
    
    func parseUser(userResponse: Dictionary<String, AnyObject>) -> User? {
        guard let userID = userResponse["user_id"] as? NSInteger,
            let name = userResponse["display_name"] as? String else {
                return nil
        }
        
        let predicate = NSPredicate(format: "userID == \(userID)")
        
        var user = self.localManagedObjectContext.retrieveFirstEntry(User.self, predicate: predicate) as? User
        
        if (user == nil) {
            user = NSEntityDescription.insertNewObjectForEntity(User.self, managedObjectContext: self.localManagedObjectContext) as? User
            
            user?.userID = userID
        }
        
        /*----------------*/
        
        user?.name = name
        
        /*----------------*/
        
        return user!
    }
    
}
