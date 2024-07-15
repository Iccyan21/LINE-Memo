//
//  RoomModel.swift
//  LINE-Memo
//
//  Created by 水原　樹 on 2024/07/12.
//

import SwiftData
import Foundation

// ルームモデル
@Model
final class Room {
    var room_name: String
    var room_image: Data?
    
    @Relationship var memo: [Memo]
    init(room_name: String, room_image: Data? = nil) {
        self.room_name = room_name
        self.room_image = room_image
        self.memo = []
    }
}
