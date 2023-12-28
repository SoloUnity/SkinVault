//
//  LanguageManager.swift
//  ValorantStoreChecker
//
//  Created by Gordon on 2023-09-02.
//

import Foundation

class LanguageManager {
    
    let language = Bundle.main.preferredLocalizations

    func getAPIChosenLanguageString() -> String {
        var chosenLanguage = ""
        
        switch self.language[0] {
            case "fr","fr-CA":
                chosenLanguage = "fr-FR"
            case "ja":
                chosenLanguage = "ja-JP"
            case "ko":
                chosenLanguage = "ko-KR"
            case "de":
                chosenLanguage = "de-DE"
            case "zh-Hans":
                chosenLanguage = "zh-CN"
            case "vi":
                chosenLanguage = "vi-VN"
            case "es":
                chosenLanguage = "es-ES"
            case "pt-PT", "pt-BR":
                chosenLanguage = "pt-BR"
            case "pl":
                chosenLanguage = "pl-PL"
            default:
                chosenLanguage = "en-US"
        }
        
        return chosenLanguage
    }
    
    func getLabelChosenLanguageString(filterList: [Skin]) -> String {
        
        let displayName = filterList[0].displayName
        
        var baseName = ""
        
        switch self.language[0] {
        case "fr", "fr-CA", "de", "vi", "es", "pt-PT", "pt-BR", "pl":
            let list = displayName!.split(separator: " ")
            baseName = String(list[0])
        case "ja":
            baseName = String(Array(displayName!)[6...])
        default:
            let list = displayName!.split(separator: " ")
            baseName = String(list[1])
        }
        
        return baseName
    }
    
    
}
