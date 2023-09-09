//
//  SplashScreenView.swift
//  ValorantStoreChecker
//
//  Created by Gordon Ng on 2022-08-03.
//

import SwiftUI

struct SplashScreenView: View {
    
    @Environment(\.colorScheme) var colourScheme
    @AppStorage("dark") var toggleDark = true
    @AppStorage("autoDark") var auto = false
    
    @State private var isActive = false
    @State private var size = 0.8
    @State private var opacity = 0.5
    
    var body: some View {
        
        if isActive {
            
            ContentView()
                .environmentObject(SkinModel())
                .environmentObject(AuthAPIModel())
                .environmentObject(AlertModel())
                //.environmentObject(TipModel())
                .environmentObject(UpdateModel())
                .environmentObject(NetworkModel())
            
        } else{
            
            GeometryReader { geo in
                VStack {
                    
                    Spacer()
                    
                    Logo()
                    
                    Image("textlogo")
                        .resizable()
                        .scaledToFit()
                        .shadow(color:.red, radius: 3)
                        .padding(.top)
                    
                    Spacer()
                    
                }
                .scaleEffect(size)
                .opacity(opacity)
                .onAppear {
                    withAnimation(.easeIn(duration: 0.65)) {
                        self.size = 0.9
                        self.opacity = 1.0
                    }
                }
                
                
            }
            .padding(120)
            .background(auto ? (colourScheme == .light ? .white : .black) : (toggleDark ? .black : .white))
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.65) {   // Duration of splash screen
                    withAnimation {
                        
                        self.isActive = true
                        
                    }
                    
                }
            }
            
        }
    }
}

struct SplashScreenView_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreenView()
    }
}
