//
//  CollectionReusableView.swift
//  iTunes&LastfmApp
//
//  Created by Дмитрий Кузнецов on 12.08.2021.
//

import UIKit
protocol CollectionReusableViewDelegate: class {
    func press()
}

class FooterCollectionView: UICollectionReusableView {
    
    @IBOutlet weak var button: UIButton!
    
    weak var delegate: CollectionReusableViewDelegate!
    
    @IBAction func pressedButton(_ sender: UIButton) {
        delegate.press()
        isHidden = true
    }
    
    deinit {
        print("deinit CollectionReusableView")
    }
}
