//
//  Question+CoreDataProperties.swift
//  ApproachingParsers
//
//  Created by Home on 16/04/2016.
//  Copyright © 2016 Boles. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Question {

    @NSManaged var index: NSNumber?
    @NSManaged var questionID: NSNumber?
    @NSManaged var title: String?
    @NSManaged var url: String?
    @NSManaged var isAnswered: NSNumber?
    @NSManaged var author: User?
    @NSManaged var page: Page?
    @NSManaged var tags: NSSet?

    @NSManaged func addTagsObject(value:Tag)
    @NSManaged func removeTagsObject(value:Tag)
    @NSManaged func addTags(value:Set<Tag>)
    @NSManaged func removeTags(value:Set<Tag>)
}
