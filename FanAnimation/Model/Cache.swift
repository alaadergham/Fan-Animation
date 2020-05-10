//
//  Cache.swift
//  AkrabElaik
//
//  Created by Temp_Majd on 11/4/17.
//  Copyright © 2017 Syraitel. All rights reserved.
//

import Foundation

enum Language : String{
    /// returns 1 as String for English
    case english = "1"
    
    /// returns 0 as String for Arabic
    case arabic = "0"
}

struct Cache{
    
    public static let defaults = UserDefaults(suiteName: "fan")!
    static let key = "cache"
    
    /** store all data regarding application
     */
    struct system{
        
        static let key = Cache.key + "/system"
        
        static let languageKey = system.key + "/appLanguage"
        
        private static let startingLanguage = system.language
        
        static var language : Language{
            if let languageValue = defaults.string(forKey: languageKey){
                return Language(rawValue: languageValue)!
            }
            return .english
        }
        
        static var layoutLanguage : Language{
            return startingLanguage
        }
        
    }
}

