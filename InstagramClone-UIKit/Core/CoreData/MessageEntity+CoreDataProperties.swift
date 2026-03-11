//
//  MessageEntity+CoreDataProperties.swift
//  InstagramClone-UIKit
//
//  Created by Nihad Gurbanli on 27.02.26.
//
//

public import Foundation
public import CoreData


public typealias MessageEntityCoreDataPropertiesSet = NSSet

extension MessageEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MessageEntity> {
        return NSFetchRequest<MessageEntity>(entityName: "MessageEntity")
    }

    @NSManaged public var id: String?
    @NSManaged public var type: String
    @NSManaged public var content: String
    @NSManaged public var senderID: String
    @NSManaged public var timeStamp: Date
    @NSManaged public var duration: NSNumber?
    @NSManaged public var chatID: String
    

}

extension MessageEntity : Identifiable {

}
