//
//  NetworkManager.swift
//  iTunes&LastfmApp
//
//  Created by Дмитрий Кузнецов on 31.07.2021.
//

import Foundation

enum NetworkResponce {
    case error(String)
    case success(FullJSONModel)
}

enum searchSystem {
    case iTunes(searchText: String, searchLimit: SearchLimit)
}

class NetworkManager {
    
    static var shared: NetworkManager! = NetworkManager()
    
    private init() {}
    deinit {
        print("deinit NetworkManager")
    }
    
    func getDataFromiTunes(searchSystem: searchSystem,
                           complition: @escaping (NetworkResponce) -> Void) {
        
        let getRequestData = setupURLRequest(searchSystem)
        
        URLSession.shared.dataTask(with: getRequestData) { (data, _, error) in
            
            if let _ = error {
                complition(.error("Ошибка запроса, проверьте доступ к интернету"))
                return
            }
            
            guard let data = data else { return }
            do {
                let data = try JSONDecoder().decode(FullJSONModel.self, from: data)
                complition(.success(data))
            } catch {
                complition(.error("Ошибка получения данных"))
            }
        }.resume()
    }
    
    
    private func setupURLRequest(_ searchSystem: searchSystem) -> URLRequest {
        
        switch searchSystem {
        case .iTunes(let searchText, let searchLimit):
            
            var urlComponents = URLComponents(string: "https://itunes.apple.com/search")
            let queryItems = [URLQueryItem(name: "term", value: searchText),
                              URLQueryItem(name: "limit", value: searchLimit.rawValue)]
            
            urlComponents?.queryItems = queryItems
            let urlRequest = urlComponents?.url
            let getRequestData = URLRequest(url: urlRequest!)
            
            return getRequestData
        }
    }
}

