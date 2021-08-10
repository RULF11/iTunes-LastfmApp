//
//  SearchViewPresenter.swift
//  iTunes&LastfmApp
//
//  Created by Дмитрий Кузнецов on 02.08.2021.
//

import Foundation

protocol SearchViewPresenterProtocol: class {
    init(view: SearchViewProtocol)
    
    var mainModelForItems: SafeArray<MainViewModel> { get }
    
    func getSearchText(_ text: String?, searchLimit: SearchLimit)
    func removeSearchText()
}

protocol SearchViewProtocol: class {
    func collectionReloadData()
    func deleteRows()
    func showButtonResult()
}


class SearchViewPresenter: SearchViewPresenterProtocol {
    
    deinit {
        NetworkManager.shared = nil
        print("deinit SearchViewPresenter")
    }
    weak var view: SearchViewProtocol!
    
    var mainModelForItems = SafeArray<MainViewModel>()
    private var currentSearchText: String!
    
    required init(view: SearchViewProtocol) {
        self.view = view
    }
    
    func getSearchText(_ text: String?, searchLimit: SearchLimit) {
        guard let text = text else { return }
        getDataFromNetwork(text, searchLimit: searchLimit)
    }
    
    
    func removeSearchText() {
        view.deleteRows()
        self.mainModelForItems.removeAll()
        view.collectionReloadData()
    }
    
    private func getDataFromNetwork(_ searchText: String, searchLimit: SearchLimit) {
        currentSearchText = searchText

        print("text: \(searchText)")
        
        let group = DispatchGroup()

        NetworkManager.shared.getData(searchText: searchText,
                                      searchLimit: searchLimit) { [weak self] (model) in

//            sleep(10)
            if self?.currentSearchText == searchText {

                guard let results = model.results else { return }
                self?.mainModelForItems.removeAll()

                var aaa = MainViewModel.createModel(results)

                for _ in 1...1 {
                    aaa += aaa
                }

                self?.mainModelForItems.append(aaa.sorted { $0.kind > $1.kind })
                print(aaa.count)
                DispatchQueue.main.async(group: group) {

                    self?.view.collectionReloadData()
                    print("done")
                }
                group.notify(queue: .main){
                    print("endUpdate ")
//                    self.view.showButtonResult()
                }
            }
        }
        
    }
}





class SafeArray<T> {
    
    deinit {
        print("deinit SafeArray")
    }
    
    private var array: [T] = []
    
    private let queue = DispatchQueue(label: "mySafeArray", attributes: .concurrent)

    
    var count: Int {
        var result = 0
        queue.sync { result = self.array.count }
        return result
    }
    func append(_ newArray: [T]) {
        queue.async(flags: .barrier) {
            self.array.append(contentsOf: newArray)
        }
    }
    
    func append(_ newElement: T) {
        queue.async(flags: .barrier) {
            self.array.append(newElement)
        }
    }
    
    func read() -> [T] {
        var array: [T] = []
        queue.sync {
            array = self.array
        }
        return array
    }
    
    func removeAll() {
        queue.async(flags: .barrier) {
            self.array.removeAll()
        }
    }
}

