//
//  Models.swift
//  iTunes&LastfmApp
//
//  Created by Дмитрий Кузнецов on 17.06.2021.
//

import Foundation

//struct ModelForView {
//    let type: String
//    let imageURL: String
//    let name: String
//}

struct MainViewModel {
    let kind: String
    var cellModel: [CollectionCellModel]

    init(kind: String, cellModel: [CollectionCellModel]) {
//        self.kind = MainViewModel.convertToRusKind(kind)
        self.kind = kind
        self.cellModel = cellModel
    }
    
    static func createModel(_ model: [BusinessJSONModel]) -> [MainViewModel] {
        
        var mainModelForItems: [MainViewModel] = []
        var a: [String: Int] = [:]
        
        for element in model {
            
            
            let kind = MainViewModel.convertToRusKind(element.kind)
            
            if let index = a[kind] {
                mainModelForItems[index].cellModel
                    .append(CollectionCellModel(from: element))
            } else {
                a[kind] = mainModelForItems.count
                mainModelForItems
                    .append(MainViewModel(kind: kind,
                                          cellModel: [CollectionCellModel(from: element)]))
            }
        }
        return mainModelForItems
    }
    
    static private func convertToRusKind(_ kind: String?) -> String {
        switch kind {
        case "book": return "Книга"
        case "album": return "Альбом"
        case "coached-audio": return "coached-audio"
        case "feature-movie": return "feature-movie"
        case "interactive-booklet": return "interactive-booklet"
        case "music-video": return "music-video"
        case "pdf podcast": return "pdf podcast"
        case "podcast-episode": return "podcast-episode"
        case "software-package": return "software-package"
        case "song": return "Песня"
        case "tv-episode": return "tv-episode"
        case "artist": return "Артист"
//        case "podcast": return "podcast"
        default: return "Другое"
        }
    }
}

    

struct CollectionCellModel {
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

