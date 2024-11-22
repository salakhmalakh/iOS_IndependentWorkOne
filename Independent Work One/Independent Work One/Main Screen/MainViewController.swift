//
//  ViewController.swift
//  Independent Work One
//
//  Created by Тимур Салахиев on 21.11.2024.
//

import UIKit

class MainViewController: UIViewController {
    
    lazy var mainView: MainView = MainView(frame: .zero)
    var photosCollectionViewDatasource = PhotosCollectionViewDataSource()
    var mainModel = MainModel()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        mainView.configurePhotosCollectionView(dataSource: photosCollectionViewDatasource)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    


}

