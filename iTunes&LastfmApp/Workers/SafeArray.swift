//
//  SafeArray.swift
//  iTunes&LastfmApp
//
//  Created by Дмитрий Кузнецов on 15.08.2021.
//

import Foundation


class SafeArray<T> {
    
    deinit {
        print("deinit SafeArray")
    }
    
    var count: Int {
        var result = 0
        queue.sync { result = self.array.count }
        return result
    }
    
    private let queue = DispatchQueue(label: "mySafeArray", attributes: .concurrent)
    private var array: [T] = []
    
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

