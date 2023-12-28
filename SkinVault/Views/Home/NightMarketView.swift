//
//  NightMarketView.swift
//  ValorantStoreChecker
//
//  Created by Gordon on 2022-09-25.
//

import SwiftUI

struct NightMarketView: View {
    @EnvironmentObject var authAPIModel : AuthAPIModel
    @EnvironmentObject var skinModel : SkinModel
    @AppStorage("selectedTab") var selectedTab: Tab = .nightMarket
    @State private var hasScrolled = false
    let defaults = UserDefaults.standard
    
    var body: some View {
        
        ScrollViewReader{ (proxy: ScrollViewProxy) in

            ZStack {
                ScrollView(showsIndicators: false) {
                    
                    scrollDetection
                        .id("top")
                    
                    LazyVStack() {
                        
                        ShopTopBarView(reloadType: "nightMarketReload", referenceDate: defaults.object(forKey: "nightTimeLeft") as? Date ?? Date())
                        
                        Divider()
                            .padding(.leading)
                        
                        
                        ForEach(0..<authAPIModel.nightSkins.count, id: \.self) { index in
                            HStack {
                                TierBar(contentTierUuid: authAPIModel.nightSkins[index].contentTierUuid ?? "")
                                
                                VStack {
                                    
                                    
                                    
                                    if index < authAPIModel.nightDiscount.count && index < authAPIModel.nightSkins.count && authAPIModel.nightDiscount.count == authAPIModel.nightSkins.count {
                                        
                                        let percentOff = authAPIModel.nightDiscount[index]
                                        SkinCardView(skin: authAPIModel.nightSkins[index], showPrice: true, showPriceTier: true, price: authAPIModel.nightSkins[index].discountedCost ?? "" , originalPrice: false, percentOff: String(percentOff), nightPrice: true)
                                            .frame(height: (UIScreen.main.bounds.height / Constants.dimensions.cardSize))
                                           
                                    }
                                    else {
                                        SkinCardView(skin: authAPIModel.nightSkins[index], showPrice: true, showPriceTier: true, price: authAPIModel.nightSkins[index].discountedCost ?? "" , originalPrice: false)
                                            .frame(height: (UIScreen.main.bounds.height / Constants.dimensions.cardSize))
                                    }
                                    
                                    Divider()
                                        .padding(.leading)
                                }
                                .clipShape(Rectangle())
                                
                            }

                        }
                        
                        ShopBottomBarView()
                        
                        

                    }
                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 30, style: .continuous))
                    
                    
                    
                    
                }
                .coordinateSpace(name: "scroll")
                .safeAreaInset(edge: .top) {
                    Color.clear.frame(height: 70)
                }
                .padding(.horizontal)
                .overlay {
                    NavigationBar(title: "NightMarket", hasScrolled: $hasScrolled)
                }
                .onChange(of: selectedTab, perform: { tab in
                    if tab == .nightMarket {
                        
                        self.hasScrolled = false
                        proxy.scrollTo("top", anchor: .top)
                        
                    }
                })
                
                if hasScrolled {

                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            
                            GoUpButton(proxy: proxy)
                                .padding(.trailing)
                                .padding(.bottom, (UIScreen.main.bounds.height / Constants.dimensions.upButton))
                            
                        }
                    }
                    .ignoresSafeArea(.all)
                    .onTapGesture {
                        withAnimation {
                            self.hasScrolled = false
                        }
                        
                    }
                }
            }
        }
    }
    
    var scrollDetection: some View {
        GeometryReader { proxy in

            Color.clear
                .preference(key: ScrollPreferenceKey.self,
                            value: proxy.frame(in: .named("scroll")).minY)
        }
        .frame(height: 0)
        .onPreferenceChange(ScrollPreferenceKey.self) { value in
            withAnimation(.easeInOut) {
                hasScrolled = value < 0
            }
        }
    }
}
