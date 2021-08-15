//
//  SearchViewPresenter.swift
//  iTunes&LastfmApp
//
//  Created by Дмитрий Кузнецов on 02.08.2021.
//

import Foundation


protocol SearchViewPresenterProtocol: class {
    init(view: SearchViewProtocol)
    var mainModelForItems: SafeArray<MainViewiTunesModel> { get }
    var showAll: Bool { get }
    func getSearchText(_ text: String?, limit: SearchLimit)
}

protocol SearchViewProtocol: class {
    func collectionReloadData()
    func showAlertController(with title: String, and message: String)
}


class SearchViewPresenter: SearchViewPresenterProtocol {
    
    deinit {
        NetworkManager.shared = nil
        print("deinit SearchViewPresenter")
    }
    
    weak var view: SearchViewProtocol!
    var mainModelForItems = SafeArray<MainViewiTunesModel>()
    private var currentSearchText: String?
    var showAll: Bool {
        let text = DataManager.shared.readData(forKey: DataManager.keyForData) as? String
        if currentSearchText == text {
            return true
        }
        return false
    }
    
    required init(view: SearchViewProtocol) {
        self.view = view
    }
    
    func getSearchText(_ text: String?, limit: SearchLimit) {
        guard let text = text else {
            return
        }
        if limit == .max {
            DataManager.shared.writeData(text, forKey: DataManager.keyForData)
        }
        currentSearchText = text
        getDataFromNetwork(text, searchLimit: limit)
    }
    
    private func getDataFromNetwork(_ searchText: String, searchLimit: SearchLimit) {
    
                
        NetworkManager
            .shared
            .getDataFromiTunes(searchSystem: .iTunes(searchText: searchText,
                                                     searchLimit: searchLimit)) { [weak self] (NetworkResponse) in
            
            guard self?.currentSearchText == searchText else { return }
            
            switch NetworkResponse {
            case .error(let errorText):
                DispatchQueue.main.async {
                    self?.view.showAlertController(with: "Ошибка", and: errorText)
                }
            case .success(let model):
                guard let results = model.results else { return }
                self?.mainModelForItems.removeAll()
                self?.mainModelForItems.append(MainViewiTunesModel.createModel(results))
                //проверка работоспособности
//                var aaa = MainViewModel.createModel(results)
//                for _ in 1...1 {
//                    aaa += aaa
//                }
//
//                self?.mainModelForItems.append(aaa.sorted { $0.kind > $1.kind })
//                print(aaa.count)
                DispatchQueue.main.async {
                    if self?.mainModelForItems.count ?? 0 > 0 {
                        self?.view.collectionReloadData()
                    } else {
                        self?.view.showAlertController(with: "Ничего не найдено",
                                                       and: "")
                    }
                    self?.view.collectionReloadData()
                    print("done")
                }
            }
        }
    }
}



