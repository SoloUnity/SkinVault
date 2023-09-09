//
//  ContentView.swift
//  SkinVault
//
//  Created by Gordon on 2023-09-06.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject private var skinModel: SkinModel
    @Query(sort: \Skin.displayName, order: .forward) var skins: [Skin]

    var body: some View {
        VStack {
            Text("List")
    
            Button {
                modelContext.deletedModelsArray
            } label: {
                Text("Delete ")
            }
            
            List {
                ForEach(skins) { skin in
                    Text(skin.displayName)
                }
                //.onDelete(perform: deleteItems)
                
            }
            
            

        }
        .onAppear {
            skinModel.modelContext = self.modelContext
            skinModel.getRemoteDataLogic()
        }
        
        
    }

    /*
    private func addItem() {
        withAnimation {
            let newItem = Item(timestamp: Date())
            modelContext.insert(newItem)
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(items[index])
            }
        }
    }
     */
}
/*
#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
*/
