//
//  NetworkModels.swift
//  iTunes&LastfmApp
//
//  Created by Дмитрий Кузнецов on 15.08.2021.
//

import Foundation

struct BusinessJSONModel: Decodable {
    let artistId: Int?
    let artistName: String?
    let artistViewUrl: String?
    let artworkUrl100: String?
    let collectionCensoredName: String?
    let collectionViewUrl: String?
    let kind: String?
    let releaseDate: String?
    let trackCensoredName: String?
    let trackViewUrl: String?
    let wrapperType: String?
}

struct FullJSONModel: Decodable {
    let resultCount: Int?
    let results: [BusinessJSONModel]?
}

enum SearchLimit: String {
    case min = "25"
    case standart = "50"
    case max = "200"
}
