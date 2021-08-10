//
//  ViewController.swift
//  iTunes&LastfmApp
//
//  Created by Дмитрий Кузнецов on 12.06.2021.
//

import UIKit
import CoreGraphics

class ViewController: UIViewController {
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var presenter: SearchViewPresenterProtocol!
    
    private var activityIndicator: UIActivityIndicatorView!
    private var button: UIButton!
    private let cellIdentifier = "CategoryCollectionViewCell"
    
    deinit {
        print("deinit ViewController")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter = SearchViewPresenter(view: self)
        
        setupCollectionViewBackground()
        setupActivityIndicator()
        setupButtonResult()
        setupToHideKeyboardOnTapOnView()
        
        let collectionCellNib = UINib(nibName: cellIdentifier, bundle: nil)
        collectionView.register(collectionCellNib, forCellWithReuseIdentifier: cellIdentifier)
        
        searchBar.delegate = self
    }
    
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
    
    @objc func touchButton(_ sender: UIButton) {
        presenter.removeSearchText()
        presenter.getSearchText(searchBar.text, searchLimit: SearchLimit.max)
        activityIndicator.startAnimating()
        sender.isHidden = true
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func setupToHideKeyboardOnTapOnView() {
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
    
    private func setupButtonResult() {
        button = UIButton(type: .system)
        button.backgroundColor = .blue
        button.tintColor = .white
        button.setTitle("Загрузить все", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 32)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.titleLabel?.minimumScaleFactor = 0.5
        button.isHidden = true
        
        button.layer.borderWidth = 3
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.cornerRadius = 10
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.addTarget(self, action: #selector(touchButton), for: .touchUpInside)
        
        view.addSubview(button)
        
        button.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        button.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -150).isActive = true
        //        button.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100)
        //            .isActive = true
        button.topAnchor.constraint(equalTo: view.topAnchor, constant: searchBar.frame.maxY+10)
            .isActive = true
        
    }
}



extension ViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            //presenter.removeSearchText()
        }
        button.isHidden = true
        presenter.removeSearchText()
        presenter.getSearchText(searchBar.text, searchLimit: SearchLimit.min)
        
        activityIndicator.startAnimating()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        button.isHidden = true
        activityIndicator.startAnimating()
        presenter.getSearchText(searchBar.text, searchLimit: SearchLimit.standart)
        searchBar.resignFirstResponder()
    }
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        presenter.mainModelForItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! CategoryCollectionViewCell
        
        let model = presenter.mainModelForItems.read()
        
        if !model.isEmpty {
            cell.setKindLabel(model[indexPath.item].kind)
            cell.setResultCountLabel("\(model[indexPath.item].cellModel.count)")
            cell.indexLabel.text = "\(indexPath.item)"
            cell.cellModel = model[indexPath.item].cellModel
        }
        return cell
    }
}

extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let count = collectionView.numberOfItems(inSection: indexPath.section)
        if (count == indexPath.item + 1)
            && button.isHidden
            && (!searchBar.isFirstResponder) {
            showButtonResult()
        }
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: UIScreen.main.bounds.width - 32, height: 150)
    }
}

extension ViewController: SearchViewProtocol {
    
    func collectionReloadData() {
        self.collectionView.reloadData()
        activityIndicator.stopAnimating()
    }
    
    func deleteRows() {
        
    }
    
    func showButtonResult() {
        button.isHidden = false
        button.alpha = 0
        let positionY = button.frame.origin.y
        button.frame.origin.y = 0
        UIView.animate(withDuration: 0.5, delay: 1) {
            self.button.alpha = 1
            self.button.frame.origin.y = positionY
        }
    }
}
