//
//  MemoModel.swift
//  LINE-Memo
//
//  Created by 水原　樹 on 2024/07/12.
//

import Foundation
import SwiftData

// メモモデル
@Model
final class Memo {
    var text: String
    var image: Data?
    var sendTime: Date
    var flag: Bool  // この行を追加してBool型のflagを含むようにする
    
    @Relationship var room: [Room]
    init(text: String, image: Data? = nil, sendTime: Date, flag: Bool = true) {
        self.text = text
        self.sendTime = sendTime
        self.image = image
        self.flag = flag
        self.room = []
    }
}
