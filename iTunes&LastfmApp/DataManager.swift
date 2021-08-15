//
//  DataManager.swift
//  iTunes&LastfmApp
//
//  Created by Дмитрий Кузнецов on 15.08.2021.
//

import Foundation

class DataManager {
    static let shared = DataManager()
    static let keyForData = "iTunes&LastFMSearch"
    
    private init() {}
    
    func writeData(_ data: Any?, forKey: String) {
        UserDefaults.standard.setValue(data, forKey: forKey)
    }
    
    func readData(forKey: String) -> Any? {
        UserDefaults.standard.object(forKey: forKey)
    }
}
