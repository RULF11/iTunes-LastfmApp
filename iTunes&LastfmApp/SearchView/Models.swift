//
//  Models.swift
//  iTunes&LastfmApp
//
//  Created by Дмитрий Кузнецов on 17.06.2021.
//

import Foundation

struct MainViewiTunesModel {
    let kind: String
    var cellModel: [CollectionCelliTunesModel]
    
    init(kind: String, cellModel: [CollectionCelliTunesModel]) {
        self.kind = kind
        self.cellModel = cellModel
    }
    
    static func createModel(_ model: [BusinessJSONModel]) -> [MainViewiTunesModel] {
        
        var mainModelForItems: [MainViewiTunesModel] = []
        var rememberIndexDict: [String: Int] = [:]
        
        for element in model {
        
            let kind = MainViewiTunesModel.convertToRusKind(element.kind)
            
            if let index = rememberIndexDict[kind] {
                mainModelForItems[index].cellModel
                    .append(CollectionCelliTunesModel(from: element))
            } else {
                rememberIndexDict[kind] = mainModelForItems.count
                mainModelForItems
                    .append(MainViewiTunesModel(kind: kind,
                                          cellModel: [CollectionCelliTunesModel(from: element)]))
            }
        }
        return mainModelForItems
    }
    
    static private func convertToRusKind(_ kind: String?) -> String {
        switch kind {
        case "book": return "Книга"
        case "album": return "Альбом"
        case "coached-audio": return "Песня"
        case "feature-movie": return "Фильм"
        case "interactive-booklet": return "Брошюра"
        case "music-video": return "Клип"
        case "pdf podcast": return "PDF подкаст"
        case "podcast-episode": return "Подкаст-эпизод"
        case "software-package": return "ПО"
        case "song": return "Песня"
        case "tv-episode": return "ТВ эпизод"
        case "artist": return "Артист"
        case "podcast": return "Подскаст"
        default: return "Другое"
        }
    }
}



struct CollectionCelliTunesModel {
    let imageURL: String
    let artistName: String
    let trackCensoredName: String
    
    init(imageURL: String, artistName: String, trackCensoredName: String) {
        self.imageURL = imageURL
        self.artistName = artistName
        self.trackCensoredName = trackCensoredName
    }
    
    init(from model: BusinessJSONModel) {
        self.artistName = model.artistName ?? ""
        self.imageURL = model.artworkUrl100 ?? ""
        self.trackCensoredName = model.trackCensoredName ?? ""
    }
}

