//
//  CollectionViewCell.swift
//  iTunes&LastfmApp
//
//  Created by Дмитрий Кузнецов on 16.06.2021.
//

import UIKit

class DetailCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var trackNameLabel: UILabel!
    
    private var currentCell: IndexPath!
    
    deinit {
        // For check
        print("DetailCollectionViewCell deinit")
    }

    
    override func awakeFromNib() {
        super.awakeFromNib()

        layer.cornerRadius = 10
        layer.borderWidth = 2
        layer.borderColor = UIColor.black.cgColor
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        
    }
    
    func setImage(_ urlString: String, at indexPath: IndexPath) {
        currentCell = indexPath
        DispatchQueue.global(qos: .utility).async {
            guard let url = URL(string: urlString) else { return }
            guard let imageData = try? Data(contentsOf: url) else { return }
            DispatchQueue.main.async {
                if self.currentCell == indexPath {
                    self.imageView.image = UIImage(data: imageData)
                }
            }
        }
    }
    
    func setArtistNameLabel(_ text: String) {
        DispatchQueue.main.async {
            self.artistNameLabel.text = text
        }
    }
    
    func setTrackNameLabel(_ text: String) {
        DispatchQueue.main.async {
            self.trackNameLabel.text = text
        }
    }
}
