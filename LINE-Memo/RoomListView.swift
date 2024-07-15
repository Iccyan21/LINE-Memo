//
//  RoomListView.swift
//  LINE-Memo
//
//  Created by 水原　樹 on 2024/07/12.
//

import SwiftUI
import SwiftData
import PhotosUI

struct RoomListView: View {
    @Environment(\.modelContext) var model
    @State private var searchText = ""
    @Query(animation: .snappy) var rooms: [Room]
    
    var filteredRooms: [Room] {
        if searchText.isEmpty {
            return rooms
        } else {
            return rooms.filter { $0.room_name.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                if rooms.isEmpty {
                    NavigationLink(destination: RoomCreateView()) {
                        Text("ルームを作成する")
                    }
                } else {
                    ListView(filteredRooms: filteredRooms, deleteRoom: deleteRoom)
                }
                
                Spacer()
                createButton
                
            }
            .navigationTitle("ルーム一覧")
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
            .toolbarBackground(Color.green, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarTitleDisplayMode(.inline)
            .toolbarColorScheme(.dark)
        }
    }
    
    var createButton: some View {
        HStack {
            Spacer()
            NavigationLink(destination: RoomCreateView()) {
                Image(systemName: "plus.circle")
                    .resizable()
                    .frame(width: 50, height: 50)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.green)
                    .clipShape(Circle())
            }
            .padding()
        }
    }
    
    func deleteRoom(at offsets: IndexSet) {
        offsets.forEach { index in
            let room = rooms[index]
            model.delete(room)
        }
    }
}


#Preview {
    RoomListView()
        .modelContainer(for: [Room.self,Memo.self])
}



