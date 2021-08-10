//
//  NetworkManager.swift
//  iTunes&LastfmApp
//
//  Created by Дмитрий Кузнецов on 31.07.2021.
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

class NetworkManager {
    
    static var shared: NetworkManager! = NetworkManager()
    
    private init() {}
    
    func getData(searchText: String,
                 searchLimit: SearchLimit,
                 complition: @escaping (FullJSONModel) -> Void) {
        var urlComponents = URLComponents(string: "https://itunes.apple.com/search")
        urlComponents?.queryItems = [URLQueryItem(name: "term", value: searchText),
                                     URLQueryItem(name: "limit", value: searchLimit.rawValue)]
        
        let urlRequest = urlComponents?.url
        let getRequestData = URLRequest(url: urlRequest!)
        
        URLSession.shared.dataTask(with: getRequestData) { (data, _, error) in
            
            if let error = error {
                print("Requst error: \(error)")
                return
            }
            
            guard let data = data else { return }
            
            do {
                let data = try JSONDecoder().decode(FullJSONModel.self, from: data)
                complition(data)
            } catch let error {
                print(error)
            }
            
        }.resume()
    }
    
    deinit {
        print("deinit NetworkManager")
    }
}

