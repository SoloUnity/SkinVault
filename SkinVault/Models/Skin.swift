//
//  Weapon.swift
//  ValorantStoreChecker
//
//  Created by Gordon Ng on 2022-07-17.
//

import Foundation
import UIKit
import SwiftData

@Model
class Skin: Identifiable, Codable, ObservableObject{
    
    var id : UUID
    var displayName : String
    var themeUuid : String?
    var contentTierUuid : String?
    var displayIcon : String?
    @Relationship(deleteRule: .cascade)
    var chromas : [Chromas]?
    @Relationship(deleteRule: .cascade)
    var levels : [Levels]?
    var assetPath : String?
    var discountedCost : String?
    
    enum CodingKeys:String, CodingKey{
        case id = "uuid"
        
        case displayName
        case themeUuid
        case contentTierUuid
        case displayIcon
        case chromas
        case levels
        case assetPath
        case discountedCost
    }
    
    init(id: UUID, 
         displayName: String,
         themeUuid: String?,
         contentTierUuid: String?,
         displayIcon:String?,
         chromas: [Chromas]?,
         levels: [Levels]?,
         assetPath : String?,
         discountedCost : String?) {
        self.id = id
        self.displayName = displayName
        self.themeUuid = themeUuid
        self.contentTierUuid = contentTierUuid
        self.displayIcon = displayIcon
        self.chromas = chromas
        self.levels = levels
        self.assetPath = assetPath
        self.discountedCost = discountedCost
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try container.decode(UUID.self, forKey: .id)
        self.displayName = try container.decode(String.self, forKey: .displayName)
        self.themeUuid = try container.decodeIfPresent(String.self, forKey: .themeUuid)
        self.contentTierUuid = try container.decodeIfPresent(String.self, forKey: .contentTierUuid)
        self.displayIcon = try container.decodeIfPresent(String.self, forKey: .displayIcon)
        self.chromas = try container.decodeIfPresent([Chromas].self, forKey: .chromas)
        self.levels = try container.decodeIfPresent([Levels].self, forKey: .levels)
        self.assetPath = try container.decodeIfPresent(String.self, forKey: .assetPath)
        self.discountedCost = try container.decodeIfPresent(String.self, forKey: .discountedCost)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(id, forKey: .id)
        try container.encode(displayName, forKey: .displayName)
        try container.encode(themeUuid, forKey: .themeUuid)
        try container.encode(contentTierUuid, forKey: .contentTierUuid)
        try container.encode(displayIcon, forKey: .displayIcon)
        try container.encode(chromas, forKey: .chromas)
        try container.encode(levels, forKey: .levels)
        try container.encode(assetPath, forKey: .assetPath)
        try container.encode(discountedCost, forKey: .discountedCost)
    }
}

@Model
class Chromas: Codable, Identifiable{
    
    var id : UUID
    var displayName : String?
    var displayIcon : String?
    var fullRender : String?
    var streamedVideo : String?
    var swatch : String?
    
    enum CodingKeys:String, CodingKey{
        case id = "uuid"
        
        case displayName
        case displayIcon
        case fullRender
        case streamedVideo
        case swatch
    }
    
    init(id: UUID,
         displayName: String?,
         displayIcon: String?,
         fullRender: String?,
         streamedVideo: String?,
         swatch: String?) {
        self.id = id
        self.displayName = displayName
        self.displayIcon = displayIcon
        self.fullRender = fullRender
        self.streamedVideo = streamedVideo
        self.swatch = swatch
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try container.decode(UUID.self, forKey: .id)
        self.displayName = try container.decodeIfPresent(String.self, forKey: .displayName)
        self.displayIcon = try container.decodeIfPresent(String.self, forKey: .displayIcon)
        self.fullRender = try container.decodeIfPresent(String.self, forKey: .fullRender)
        self.streamedVideo = try container.decodeIfPresent(String.self, forKey: .streamedVideo)
        self.swatch = try container.decodeIfPresent(String.self, forKey: .swatch)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(id, forKey: .id)
        try container.encode(displayName, forKey: .displayName)
        try container.encode(displayIcon, forKey: .displayIcon)
        try container.encode(fullRender, forKey: .fullRender)
        try container.encode(streamedVideo, forKey: .streamedVideo)
        try container.encode(swatch, forKey: .swatch)
    }
}

@Model
class Levels: Codable, Identifiable{
    
    var id:UUID
    var displayName:String?
    var levelItem:String?
    var displayIcon:String?
    var streamedVideo:String?
    
    enum CodingKeys:String, CodingKey{
        case id = "uuid"
        
        case displayName
        case levelItem
        case displayIcon
        case streamedVideo
    }
    
    init(id: UUID,
         displayName: String?,
         levelItem: String?,
         displayIcon: String?,
         streamedVideo: String?) {
        self.id = id
        self.displayName = displayName
        self.levelItem = levelItem
        self.displayIcon = displayIcon
        self.streamedVideo = streamedVideo
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try container.decode(UUID.self, forKey: .id)
        self.displayName = try container.decodeIfPresent(String.self, forKey: .displayName)
        self.levelItem = try container.decodeIfPresent(String.self, forKey: .levelItem)
        self.displayIcon = try container.decodeIfPresent(String.self, forKey: .displayIcon)
        self.streamedVideo = try container.decodeIfPresent(String.self, forKey: .streamedVideo)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(id, forKey: .id)
        try container.encode(displayName, forKey: .displayName)
        try container.encode(levelItem, forKey: .levelItem)
        try container.encode(displayIcon, forKey: .displayIcon)
        try container.encode(streamedVideo, forKey: .streamedVideo)
    }
}

class Skins: Codable {
    
    var data: [Skin]
    /*
    enum CodingKeys: String, CodingKey {
        case data
    }
    
    init(data: [Skin]) {
        self.data = data
    }
        
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.data = try container.decode([Skin].self, forKey: .data)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(data, forKey: .data)
    }
    */
}


/*
struct Skins: Codable, AsyncSequence {
    typealias Element = Skin
    
    var data:[Skin]
    
    init(data: [Skin]) {
        self.data = data
    }
    
    func makeAsyncIterator() -> DataIterator {
        return DataIterator(data: data)
    }
}

struct DataIterator: AsyncIteratorProtocol {
    typealias Element = Skin
    
    var index = 0
    var data:[Skin]
    
    mutating func next() async throws -> Skin? {
        guard index < data.count else {
            return nil
        }
        
        let skin = data[index]
        index += 1
        
        return skin
    }
    
}
*/

