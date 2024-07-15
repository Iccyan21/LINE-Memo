//
//  RoomRow.swift
//  LINE-Memo
//
//  Created by 水原　樹 on 2024/07/12.
//

import SwiftUI

struct RoomRow: View {
    let room: Room
    
    var body: some View {
        HStack {
            if let imageData = room.room_image, let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .clipShape(Circle())
                    .frame(width: 60, height: 60)
            } else {
                Image(systemName: "photo.fill")
                    .resizable()
                    .clipShape(Circle())
                    .frame(width: 60, height: 60)
                    .foregroundColor(.secondary)
            }
            
            VStack(alignment: .leading) {
                HStack{
                    Text(room.room_name)
                        .font(.headline)
                        .foregroundColor(.primary)
                    if let lastMemo = room.memo.sorted(by: { $0.sendTime > $1.sendTime }).first {
                        
                        
                        Spacer()
                        
                        Text(lastMemo.sendTime, style: .time)
                            .font(.caption)
                            .foregroundColor(.gray)
                        
                    }
                }
                .padding(.bottom, 10)
                
                if let lastMemo = room.memo.sorted(by: { $0.sendTime > $1.sendTime }).first {
                    Text(lastMemo.text)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                }
            }
        }
    }
}


