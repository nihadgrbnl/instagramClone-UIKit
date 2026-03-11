//
//  MessageEntity+CoreDataClass.swift
//  InstagramClone-UIKit
//
//  Created by Nihad Gurbanli on 27.02.26.
//
//

public import Foundation
public import CoreData

public typealias MessageEntityCoreDataClassSet = NSSet

@objc(MessageEntity)
public class MessageEntity: NSManagedObject {

}

extension MessageEntity {
    
    func toMessage() -> Message? {
        guard let messageType = MessageType(rawValue: type) else { return nil }
        
        var message = Message(type: messageType, content: content, senderID: senderID, timeStamp: timeStamp)
        message.id = id
        message.duration = duration?.doubleValue
        return message
    }
    
}
