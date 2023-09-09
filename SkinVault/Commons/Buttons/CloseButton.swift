//
//  CloseButton.swift
//  ValorantStoreChecker
//
//  Created by Gordon on 2023-09-03.
//

import SwiftUI

struct CloseButton: View {
    
    @Binding var isImagePresented : Bool
    
    var body: some View {
        Button {
            isImagePresented = false
        } label: {
            Image(systemName: "xmark")
                .font(.headline)
        }
        .buttonStyle(.bordered)
        .clipShape(Circle())
        .tint(.pink)
        .padding()
    }
}

