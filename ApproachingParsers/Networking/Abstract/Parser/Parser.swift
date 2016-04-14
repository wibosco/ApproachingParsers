//
//  Parser.swift
//  ApproachingParsers
//
//  Created by William Boles on 12/04/2016.
//  Copyright © 2016 Boles. All rights reserved.
//

import UIKit
import CoreData


class Parser: NSObject {
    
    //MARK: Accessors
    
    var localManagedObjectContext: NSManagedObjectContext
    
    //MARK: Init
    
    init(managedObjectContext: NSManagedObjectContext) {
        self.localManagedObjectContext = managedObjectContext
        
        super.init()
    }
    
    //MARK: NonOptional
    
    enum ParsingError: ErrorType {
        case ExpectedValueNil(parameter: String)
    }
    
    func valueForNonOptionalProperty(response: Dictionary<String, AnyObject>, key: String) throws -> AnyObject{
        guard let valueForNonOptionalProperty = response[key] else {
            throw ParsingError.ExpectedValueNil(parameter: key)
        }
        
        return valueForNonOptionalProperty
    }
}
