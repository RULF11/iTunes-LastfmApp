//
//  ViewController.swift
//  iTunes&LastfmApp
//
//  Created by Дмитрий Кузнецов on 12.06.2021.
//

import UIKit


class SearchViewController: UIViewController {
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var presenter: SearchViewPresenterProtocol!
    
    private var activityIndicator: UIActivityIndicatorView!
    private let cellIdentifier = "CategoryCollectionViewCell"
    
    
    deinit {
        print("deinit ViewController")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter = SearchViewPresenter(view: self)
        
        setupCollectionViewBackground()
        setupActivityIndicator()
        setupToHideKeyboardOnTapOnView()
        
        let collectionCellNib = UINib(nibName: cellIdentifier, bundle: nil)
        collectionView.register(collectionCellNib, forCellWithReuseIdentifier: cellIdentifier)
        
        searchBar.delegate = self
    }
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        activityIndicator.frame = CGRect(x: collectionView.bounds.midX,
//                                         y: collectionView.bounds.midY,
//                                         width: 0,
//                                         height: 0)
//    }
    override func viewWillLayoutSubviews() {
        activityIndicator.frame = CGRect(x: collectionView.bounds.midX,
                                         y: collectionView.bounds.midY,
                                         width: 0,
                                         height: 0)
    }
    
    @IBAction func segmentedControlAction(_ sender: UISegmentedControl) {
        
        if sender.selectedSegmentIndex == 1 {
            dismiss(animated: true, completion: nil)
            UIApplication.shared.windows.first?.rootViewController = UIViewController()
        }
    }
}



extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        presenter.getSearchText(searchBar.text, limit: SearchLimit.min)
        activityIndicator.startAnimating()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        presenter.getSearchText(searchBar.text, limit: SearchLimit.standart)
        activityIndicator.startAnimating()
        searchBar.resignFirstResponder()
    }
}

extension SearchViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        presenter.mainModelForItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! CategoryCollectionViewCell
        
        let model = presenter.mainModelForItems.read()
        if indexPath.item+1 > model.count {
            print("И снова привет")
        }
        cell.setKindLabel(model[indexPath.item].kind)
        cell.setResultCountLabel("\(model[indexPath.item].cellModel.count)")
        cell.indexLabel.text = "\(indexPath.item)"
        cell.cellModel = model[indexPath.item].cellModel
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let cell = collectionView.dequeueReusableSupplementaryView(
            ofKind: UICollectionView.elementKindSectionFooter,
            withReuseIdentifier: "footer",
            for: indexPath) as! FooterCollectionView
        
        cell.delegate = self
        
        let numberOfItems = collectionView.numberOfItems(inSection: indexPath.section)
        let showAll = presenter.showAll
        
        if numberOfItems > 0 && !showAll {
            cell.isHidden = false
        } else {
            cell.isHidden = true
        }
        return cell
    }
}

extension SearchViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: UIScreen.main.bounds.width - 32, height: 150)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        30
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        CGSize(width: collectionView.bounds.width, height: 100)
    }
}

extension SearchViewController: SearchViewProtocol {
    
    func collectionReloadData() {
        collectionView.reloadData()
        activityIndicator.stopAnimating()
    }
    
    func showAlertController(with title: String, and message: String) {
        activityIndicator.stopAnimating()
        
        let alertVC = UIAlertController(title: title,
                                        message: message,
                                        preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "OK",
                                     style: .default,
                                     handler: nil)
        
        alertVC.addAction(OKAction)
        present(alertVC, animated: true, completion: nil)
    }
}


// MARK: - Exntesion for setup UI
extension SearchViewController {
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    private func setupToHideKeyboardOnTapOnView() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    private func setupCollectionViewBackground() {
        let gradient = CAGradientLayer()
        let firstColor = #colorLiteral(red: 0.7641357183, green: 0.9994270205, blue: 1, alpha: 1).cgColor
        let secondColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).cgColor
        gradient.colors = [firstColor, secondColor]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        gradient.frame = view.bounds
        
        let backgroundView = UIView(frame: collectionView.bounds)
        backgroundView.layer.addSublayer(gradient)
        collectionView.backgroundView = backgroundView
    }
    
    private func setupActivityIndicator() {
        activityIndicator = UIActivityIndicatorView()
        activityIndicator.color = .blue
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = .large
        collectionView.addSubview(activityIndicator)
    }
}


extension SearchViewController: CollectionReusableViewDelegate {
    func press() {
        presenter.getSearchText(searchBar.text, limit: SearchLimit.max)
        activityIndicator.startAnimating()
    }
}
