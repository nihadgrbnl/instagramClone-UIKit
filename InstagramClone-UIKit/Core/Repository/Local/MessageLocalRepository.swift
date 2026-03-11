//
//  LocalRepository.swift
//  ChatAppLearning
//
//  Created by Nihad Gurbanli on 27.02.26.
//

import Foundation
import CoreData

class MessageLocalRepository: MessageLocalDataSource {
    
    private let context = Persistence.shared.context
    
    
    func save(chatID: String, model: Message) {
        
        guard let id = model.id else {
            print("❌ ID nil, kaydedilmedi")
            return
        }
        print("✅ Kaydediliyor: \(id), type: \(model.type)")
        
        let request = MessageEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id)
        request.fetchLimit = 1
        
        if let count = try? context.count(for: request), count > 0 {
            return
        }
        
        let entity = MessageEntity(context: context)
        entity.id = model.id
        entity.duration = model.duration.map{ NSNumber(value: $0) }
        entity.type = model.type.rawValue
        entity.timeStamp = model.timeStamp
        entity.content = model.content
        entity.senderID = model.senderID
        entity.chatID = chatID
        
        do {
            try context.save()
        } catch {
            print("CoreData kayıt hatası: \(error)")
        }
    }
    
    func fetch(chatID: String) -> [Message] {
        let request = MessageEntity.fetchRequest()
        request.predicate = NSPredicate(format: "chatID == %@", chatID)
        request.sortDescriptors = [NSSortDescriptor(key: "timeStamp", ascending: true)]
        
        do {
            let entites = try context.fetch(request)
            print(" CORE DATA: \(entites.count) adet mesaj YEREL veritabanından ekrana çiziliyor!")
            return entites.compactMap { $0.toMessage()}
        } catch {
            print("CoreData fetch hatası: \(error)")
            return []
        }
    }
    
    func delete(chatID: String) {
        let request = MessageEntity.fetchRequest()
        request.predicate = NSPredicate(format: "chatID == %@", chatID)
        
        do {
            let entities = try context.fetch(request)
            entities.forEach { context.delete($0) }
            try context.save()
        } catch {
            print("CoreData silme hatasi \(error)")
        }
    }
}
