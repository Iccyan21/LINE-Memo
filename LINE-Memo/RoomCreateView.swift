//
//  RoomCreateView.swift
//  LINE-Memo
//
//  Created by 水原　樹 on 2024/07/15.
//

import SwiftUI
import PhotosUI
import SwiftData

class RoomCreateViewModel: ObservableObject {
    var model: ModelContext?
    @Environment(\.presentationMode) var presentationMode
    @Published var roomName: String = ""
    @Published var roomImage: Data?
    @Published var item: PhotosPickerItem?
    @Published var messageToSend: String? // 送信するメッセージ
    // エラーメッセージの公開
    @Published var errorMessage: String?
    @Published var isErrorPresented = false
    @Environment(\.dismiss) var dismiss
    @Published var shouldDismiss = false
    
    
    // ビューモデルにモデルコンテキストを設定するためのメソッド。@Environmentから渡されたmodelContextを受け取り、内部プロパティに設定
    
    func setup(model: ModelContext) {
        self.model = model
    }
    
    func addData() {
        guard let model = model, !roomName.isEmpty, let roomImage = roomImage else {
            errorMessage = "部屋の名前と画像が必要です。"
            isErrorPresented = true
            return
        }
        
        let newRoom = Room(room_name: roomName, room_image: roomImage)
        model.insert(newRoom)
        shouldDismiss = true  // 画面を閉じるフラグをセット
    }
    
    
    // 写真の読み込み
    func loadImage(for item: PhotosPickerItem?) {
        guard let item = item else {
            messageToSend = "写真が選択されていません。"
            return
        }
        
        item.loadTransferable(type: Data.self) { result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    self.roomImage = data
                }
            case .failure(let error):
                print("Error loading image: \(error)")
            }
        }
    }
}


struct RoomCreateView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel = RoomCreateViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                
                PhotosPicker(selection: $viewModel.item, matching: .images, label: {
                    if let data = viewModel.roomImage, let uiImage = UIImage(data: data) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .clipShape(Circle())
                            .frame(width: 150, height: 150)
                            .overlay(Circle().stroke(Color.green, lineWidth: 4))
                    } else {
                        Image(systemName: "photo.circle.fill")
                            .resizable()
                            .frame(width: 150, height: 150)
                            .foregroundColor(.secondary)
                            .overlay(Circle().stroke(Color.green, lineWidth: 4))
                    }
                })
                .onChange(of: viewModel.item) { newItem in
                    viewModel.loadImage(for: newItem)
                }
                
                TextField("ルーム名", text: $viewModel.roomName)
                    .font(.system(size: 20))
                    .padding(.horizontal)
                    .frame(height: 50)
                    .overlay(
                        Rectangle()
                            .frame(height: 2)
                            .foregroundColor(Color.green)
                            .padding(.top, 45),
                        alignment: .bottomLeading
                    )
                    .padding(.horizontal, 20)
                
                Spacer()
                
                Button(action: {
                    viewModel.addData()
                }) {
                    Text("作成")
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .frame(height: 50)
                        .foregroundColor(.white)
                        .font(.title)
                        .background(Color.green)
                        .cornerRadius(25)
                        .padding(.horizontal)
                }
                .onChange(of: viewModel.shouldDismiss) { shouldDismiss in
                    if shouldDismiss {
                        dismiss()
                    }
                }
                .alert("エラー", isPresented: $viewModel.isErrorPresented) {
                    Button("OK", role: .cancel) { }
                } message: {
                    Text(viewModel.errorMessage ?? "不明なエラーが発生しました。")
                }
                
                Spacer()
            }
            .navigationTitle("ルーム作成")
            .toolbarBackground(Color.green, for: .navigationBar)
            .toolbarTitleDisplayMode(.inline)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarColorScheme(.dark)
            .onAppear {
                viewModel.setup(model: modelContext)
            }
        }
        .toolbar(.hidden, for: .tabBar)
    }
}
#Preview {
    RoomCreateView()
}
