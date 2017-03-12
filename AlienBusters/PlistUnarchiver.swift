//
//  PlistUnarchiver.swift
//  AlienBusters
//
//  Created by Aleksander Makedonski on 3/12/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

import Foundation

class PlistUnarchiver{
    

    
    static func loadSectionFromBatrackInfoDict(withSectionName sectionName: String) -> [String: Any]?{
        if let batTrackInfoDict = getTrackInfoDictionaryFor(trackName: "BatTrack") as? [String: Any]?{
            if let sectionInfoDict = batTrackInfoDict?[sectionName] as? [String: Any]?{
                return sectionInfoDict
            }
        }
        
        return nil
    }

    static func getTrackInfoDictionaryFor(trackName: String) -> [String: Any]?{
        if let plistDict = getDataFromPlistWithName(plistName: "SceneTransitionText") as? [String: Any]?{
            if let trackInfoDict = plistDict?[trackName] as? [String:Any]?{
                return trackInfoDict
            }
            }
        
        return nil
    }
    
    //Get Root Dictionary from pList file
    static private func getDataFromPlistWithName(plistName: String) -> [String: Any]?{
        if let path = Bundle.main.url(forResource: plistName, withExtension: "plist"){
            if let data = try? Data(contentsOf: path){
                if let plistDict = try? PropertyListSerialization.propertyList(from: data, options: .mutableContainers, format: nil) as? [String: Any]{
                    return plistDict
                }
                
            }
            
        }
        
        return nil
    }
    
    
}
