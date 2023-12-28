//
//  ContentView.swift
//  ValorantStoreChecker
//
//  Created by Gordon Ng on 2022-12-16.
//  https://www.youtube.com/watch?v=3psB2i2Ondo

import SwiftUI

struct HomeView: View {

    @AppStorage("selectedTab") var selectedTab: Tab = .shop
    let diffBottomInset: CGFloat = 88
    
    var body: some View  {

        ZStack(alignment: .bottom) {
            
            switch selectedTab {
                
            case .shop:
                ShopView()
            case .bundle:
                BundleView()
            case .skinList:
                SkinListView()
            case .settings:
                SettingsView()
            case .nightMarket:
                NightMarketView()
            }
            
            TabBar(diffSafeAreaBottomInset: diffBottomInset)

        }
        .safeAreaInset(edge: .bottom) {
            Color.clear.frame(height: diffBottomInset)
        }
        .dynamicTypeSize(.large ... .xxLarge)
        
    }
}


