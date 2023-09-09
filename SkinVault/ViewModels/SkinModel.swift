//
//  ContentModel.swift
//  ValorantStoreChecker
//
//  Created by Gordon Ng on 2022-07-15.
//

import Foundation
import SwiftUI
import SwiftData

class SkinModel: ObservableObject{
    
    @Published var data : [Skin] = []
    @Published var standardSkins : [Skin] = []
    @Published var errorMessage = ""
    @Published var progressNumerator : Double = 0
    @Published var progressDenominator : Double = 0
    @Published var modelContext : ModelContext? = nil
    @AppStorage("networkType") var networkType = "both"
    @AppStorage("currentNetworkType") var currentNetworkType = ""
    
    
    let defaults = UserDefaults.standard
    let network = NetworkModel()
    
    func getRemoteDataLogic() {
        if networkType == "wifi" && currentNetworkType == "wifi" {
            self.getRemote()
        }
        else if networkType == "cellular" && currentNetworkType == "cellular" {
            self.getRemote()
        }
        else if networkType == "both" {
            self.getRemote()
        }
    }
    
    func getRemote() {
        DispatchQueue.global(qos: .background).async {
            self.getRemoteData()
        }
    }
    
    func getRemoteData() {
        
        if network.isConnected {
            let language = Bundle.main.preferredLocalizations
            
            if language[0] != defaults.string(forKey: "currentLanguage") {
                defaults.set(language[0], forKey: "currentLanguage")
            }
            
            var urlString = Constants.URL.valAPISkins

            urlString = urlString + "?language=" + LanguageManager().getAPIChosenLanguageString()
            
            let url = URL(string: urlString)
            
            let request = URLRequest(url: url!)
            let session = URLSession.shared
            let dataTask = session.dataTask(with: request){ [self] data, response, error in
                
                // Check if there is an error
                guard error == nil || data != nil else{
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    return
                }
                
                guard httpResponse.statusCode == 200 else {
                    return
                }
                
                
                // Handle response
                let jsonDecoder = JSONDecoder()
                
                let skinDataResponse = try! jsonDecoder.decode(Skins.self, from: data!)
                
                
                let skinData = skinDataResponse.data
                for skin in skinData {
                    var fetchDescriptor = FetchDescriptor<Skin>()
                    fetchDescriptor.predicate = #Predicate { item in
                        skin.persistentModelID == item.id
                    }
                    
                    do {
                        let existingSkin = try self.modelContext?.fetch(fetchDescriptor)
                        
                        if (existingSkin?.first == nil) {
                            self.modelContext?.insert(skin)
                        }
                    } catch {
                        print(error)
                    }
                }


                
                
                var totalImages : Double = 0
                
                //totalImages += self.getRemoteDataDownloadCount(skinDataResponse: skinDataResponse)
                /*
                DispatchQueue.main.async{
                    self.progressDenominator = totalImages
                    
                    if self.defaults.bool(forKey: "authorizeDownload") {
                        
                        let session: URLSession = {
                            let configuration = URLSessionConfiguration.ephemeral
                            configuration.timeoutIntervalForRequest = 240 // seconds
                            configuration.timeoutIntervalForResource = 240 // seconds
                            return URLSession(configuration: configuration)
                        }()
                        
                        DispatchQueue.global(qos: .default).async {
                            
                            for skin in skinDataResponse.data {
                                
                                self.getImageLevelData(skin: skin, session: session)
                                self.getImageChromaData(skin: skin, session: session)
                                
                                if skin.displayName.count > 2 && String(Array(skin.displayName)[0..<2]).contains("\n"){
                                    skin.displayName = String(Array(skin.displayName)[2...])
                                }
                                   
                            }
                            
                            
                         }
                        
                    }
                    
                    self.standardSkins = skinDataResponse.data.filter({$0.themeUuid!.contains("5a629df4-4765-0214-bd40-fbb96542941f")})
                    
                    self.data = skinDataResponse.data.sorted(by: {$0.displayName.lowercased() < $1.displayName.lowercased()}).filter({!$0.themeUuid!.contains("5a629df4-4765-0214-bd40-fbb96542941f")}).filter({!$0.themeUuid!.contains("0d7a5bfb-4850-098e-1821-d989bbfd58a8")}) //Sorts alphabetically and filters out Standard skin
                }
                */
                
                
            }
            // Kick off data task
            dataTask.resume()
        }
        
    }
    
    /*
    func getRemoteDataDownloadCount(skinDataResponse: Skins) -> Double {
        
        var totalImages: Double = 0
        
        for skin in skinDataResponse.data {
            
            if let _ = self.defaults.data(forKey: skin.levels!.first!.id.description) {
                
            } else {
                totalImages += 1
            }
                            
            for chroma in skin.chromas! {
                
                if let _ = self.defaults.data(forKey: chroma.id.description) {
                    
                }
                else {
                    totalImages += 1
                }
                
                if let _ = self.defaults.data(forKey: chroma.id.description + "swatch") {
                    
                }
                else if chroma.swatch != nil {
                    
                    totalImages += 1
                    
                }
            }
        }
        
        return totalImages
    }
    */
    func deleteData() async {
        if let skinData = defaults.data(forKey: "skinDataResponse") {
            
            let skinDataResponse = try! JSONDecoder().decode(Skins.self, from: skinData)
            
            for skin in skinDataResponse.data {
                
                if let _ = self.defaults.data(forKey: skin.levels!.first!.id.description) {
                    self.defaults.removeObject(forKey: skin.levels!.first!.id.description)
                }
                
                
                
                for chroma in skin.chromas! {
                    
                    if let _ = self.defaults.data(forKey: chroma.id.description) {
                        self.defaults.removeObject(forKey: chroma.id.description)
                    }

                    if let _ = self.defaults.data(forKey: chroma.id.description + "swatch") {
                        self.defaults.removeObject(forKey: chroma.id.description + "swatch")
                    }
                }
            }
        }
        
        

    }
    
    // Convert image url to data object
    func getImageLevelData(skin: Skin, session: URLSession) {
        
        if let _ = defaults.data(forKey: skin.levels!.first!.id.description) {
            
        } else {
            if let url = URL(string: "\(Constants.URL.valStore)weaponskinlevels/\(skin.levels!.first!.id.description.lowercased()).png") {
                
                dataHelper(url: url, key: skin.levels!.first!.id.description, session: session)
                
            }
            
        }
    }
    
    func getImageChromaData(skin: Skin, session: URLSession) {
        
        for chroma in skin.chromas! {
            
            if let _ = defaults.data(forKey: chroma.id.description) {
                
            }
            else {
                if let url = URL(string: "\(Constants.URL.valAPIMedia)weaponskinchromas/\(chroma.id.description.lowercased())/fullrender.png") {
                    
                    dataHelper(url: url, key: chroma.id.description, session: session)
                }
            }
            
            if let _ = defaults.data(forKey: chroma.id.description + "swatch") {
                
            }
            else {
                
                guard let swatchURL = chroma.swatch else {
                    return
                }
                
                if let url = URL(string: swatchURL) {
                    
                    dataHelper(url: url, key: chroma.id.description + "swatch", session: session)
                }
                
            }
            
            
        }
    }
    
    
    func dataHelper (url : URL, key : String, session: URLSession) {        
        
        let dataTask = session.dataTask(with: url) { (data, response, error) in
            
            guard
                let httpResponse = response as? HTTPURLResponse,
                httpResponse.statusCode == 200
            else{
                DispatchQueue.main.async{
                    self.progressNumerator += 1
                }
                
                return
                
            }
            
            if error == nil {
                
                DispatchQueue.main.async {
                    // Set the image data
                    if data != nil {
                        let encoded = try! PropertyListEncoder().encode(data)
                        UserDefaults.standard.set(encoded, forKey: key)
                        
                        DispatchQueue.main.async{
                            self.progressNumerator += 1
                        }
                    }
                    else {
                        return
                    }
                }
            }
            else {
                return
            }
        }
        
        let _ : NSKeyValueObservation = dataTask.progress.observe(\.fractionCompleted) { observationProgress, _ in
            
            DispatchQueue.main.async{
                self.progressNumerator += observationProgress.fractionCompleted
            }
            
        }
        
        dataTask.resume()
    }
}







