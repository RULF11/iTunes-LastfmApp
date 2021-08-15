//
//  CollectionViewCellNew.swift
//  iTunes&LastfmApp
//
//  Created by Дмитрий Кузнецов on 17.06.2021.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var kindLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var resultCountLabel: UILabel!
    @IBOutlet weak var indexLabel: UILabel!
    
    var currentIndexPath: IndexPath!
    var cellModel: [CollectionCelliTunesModel] = []
    
    private let cellIdentifier = "DetailCollectionViewCell"
    
    deinit {
        print("CategoryCollectionViewCell deinit")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        backgroundColor = #colorLiteral(red: 0.9152072072, green: 1, blue: 0.9186634421, alpha: 1)
        collectionView.backgroundColor = .none
        layer.cornerRadius = 8
        layer.borderWidth = 2
        let collectionCellNib = UINib(nibName: cellIdentifier, bundle: nil)
        collectionView.register(collectionCellNib, forCellWithReuseIdentifier: cellIdentifier)
    }
    
    override func prepareForReuse() {
        cellModel = []
        collectionView.reloadData()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let text = String(cellModel.count)
        setResultCountLabel(text)
    }
    
    func setKindLabel(_ text: String) {
        kindLabel.text = text
    }
    
    func setResultCountLabel(_ text: String) {
        let currentCellIndex = collectionView.indexPathsForVisibleItems.first?.item
        if let currentCellIndex = currentCellIndex {
            resultCountLabel.text = "\(currentCellIndex+1)/\(text)"
        } else {
            resultCountLabel.text = "\(text)"
        }
    }
}

extension CategoryCollectionViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellIdentifier, for: indexPath) as! DetailCollectionViewCell
        
        let modelCell = cellModel[indexPath.item]
        cell.setImage(modelCell.imageURL, at: indexPath)
        cell.setArtistNameLabel(modelCell.artistName)
        cell.setTrackNameLabel(modelCell.trackCensoredName)
        
        currentIndexPath = indexPath
        
        return cell
    }
}


extension CategoryCollectionViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //CGSize(width: collectionView.bounds.width - 48, height: 50)
        CGSize(width: collectionView.bounds.width - 20, height: collectionView.bounds.height - 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }
}

