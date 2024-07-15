//
//  ListView.swift
//  LINE-Memo
//
//  Created by 水原　樹 on 2024/07/12.
//

import SwiftUI

struct ListView: View {
    let filteredRooms: [Room]
    var deleteRoom: (IndexSet) -> Void
    
    var body: some View {
        List {
            Section {
                ForEach(filteredRooms) { room in
                    NavigationLink(destination: MemoView(viewModel: MemoViewModel(memo: room))) {
                        RoomRow(room: room)
                    }
                }
                .onDelete(perform: deleteRoom)
            } header: {
                Text("フレンド: \(filteredRooms.count)")
            }
        }
        .listStyle(.grouped)
        .scrollContentBackground(.hidden)
        .background(Color.white)
    }
}
