//
//  View.swift
//  Independent Work One
//
//  Created by Тимур Салахиев on 21.11.2024.
//

import UIKit

enum FilterType : String, CaseIterable {
case Chrome = "CIPhotoEffectChrome"
case Fade = "CIPhotoEffectFade"
case Instant = "CIPhotoEffectInstant"
case Mono = "CIPhotoEffectMono"
case Noir = "CIPhotoEffectNoir"
case Process = "CIPhotoEffectProcess"
case Tonal = "CIPhotoEffectTonal"
case Transfer =  "CIPhotoEffectTransfer"
}

class MainView: UIView{
    

    let dataSource = PhotosCollectionViewDataSource()
    
    private lazy var segmentedControl : UISegmentedControl = {
        let items = ["параллельно","последовательно"]
        let segmentedControl = UISegmentedControl(items: items)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.addTarget(self, action: #selector(segmentChanged(_:)), for: .valueChanged)

        
        return segmentedControl
    }()
    

    private lazy var photosCollectionView : UICollectionView = {
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumLineSpacing = 4
        flowLayout.minimumInteritemSpacing = 2
        
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        
        collectionView.backgroundColor = .systemGray6
        collectionView.isScrollEnabled = true
        collectionView.delegate = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.layer.cornerRadius = 10
        
        
        collectionView.register(PhotosCollectionViewCell.self, forCellWithReuseIdentifier: PhotosCollectionViewCell.reuseIdentifier)
        
        return collectionView
    }()
    
    
    
    private lazy var calculateButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("начать вычисления", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(startCalculations), for: .touchUpInside)

        
        return button
    }()

    private lazy var cancelButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("отмена", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(cancelCalculations), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var statusLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        
        
        return label
    }()
    
    private lazy var progressView : UIProgressView = {
        let progressView = UIProgressView()
        progressView.translatesAutoresizingMaskIntoConstraints = false
        
        return progressView
    }()
    
    var task: Task<Void, Never>?

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        configureView()
        configurePhotosCollectionView(dataSource: dataSource)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    @objc private func startCalculations() {
            statusLabel.text = "Вычисления..."
            progressView.progress = 0.0
            
            task = Task {
                for i in 1...20 {
                    if Task.isCancelled {
                        statusLabel.text = "Вычисления отменены"
                        return
                    }
                    
                    let factorial = await calculateFactorial(of: i)
                    
                    DispatchQueue.main.async {
                        self.statusLabel.text = "Факториал \(i) = \(factorial)"
                        self.progressView.progress = Float(i) / 20.0
                    }
                    
                    
                    try? await Task.sleep(nanoseconds: 500_000_000)
                }
            }
        }
        
        @objc private func cancelCalculations() {
            task?.cancel()
        }
        
        private func calculateFactorial(of number: Int) async -> Int {
            return (1...number).reduce(1, *)
        }




    
    @objc func segmentChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0{
            DispatchQueue.main.async {
                for i in 0...self.dataSource.dataSource.count - 1{
                    var photo = self.dataSource.dataSource[i]
                    photo = photo.addFilter(filter: FilterType.allCases.randomElement()!)
                    self.dataSource.dataSource[i] = photo
                }

            }
        }
        else{
            let operationQueue = OperationQueue()
            operationQueue.maxConcurrentOperationCount = 1

            for i in 0...self.dataSource.dataSource.count - 1{
                
                let operation = BlockOperation { [self] in
                    var photo = self.dataSource.dataSource[i]
                    photo = photo.addFilter(filter: FilterType.allCases.randomElement()!)
                    self.dataSource.dataSource[i] = photo
                    
                }
                operationQueue.addOperations([operation], waitUntilFinished: false)
                photosCollectionView.reloadData()
            }
        }
        photosCollectionView.reloadData()
    }
    


    
    func configurePhotosCollectionView(dataSource: UICollectionViewDataSource){
        photosCollectionView.dataSource = dataSource
    }
    
    func configureView(){
        self.addSubview(segmentedControl)
        self.addSubview(photosCollectionView)
        self.addSubview(calculateButton)
        self.addSubview(cancelButton)
        self.addSubview(statusLabel)
        self.addSubview(progressView)
        
        NSLayoutConstraint.activate([
            segmentedControl.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 25),
            segmentedControl.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            photosCollectionView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 25),
            photosCollectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            photosCollectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            photosCollectionView.bottomAnchor.constraint(equalTo: self.centerYAnchor, constant: 100),
            
            calculateButton.topAnchor.constraint(equalTo: photosCollectionView.bottomAnchor, constant: 25),
            calculateButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            cancelButton.topAnchor.constraint(equalTo: calculateButton.bottomAnchor, constant: 25),
            cancelButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            statusLabel.topAnchor.constraint(equalTo: cancelButton.bottomAnchor, constant: 25),
            statusLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            statusLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            
            progressView.topAnchor.constraint(equalTo: statusLabel.bottomAnchor, constant: 25),
            progressView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            progressView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            
        ])
    }

}

extension MainView: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width/3 - 4, height: collectionView.bounds.height/3)
    }
    
}

extension UIImage {
    func addFilter(filter : FilterType) -> UIImage {
        let filter = CIFilter(name: filter.rawValue)
        // convert UIImage to CIImage and set as input
        let ciInput = CIImage(image: self)
        filter?.setValue(ciInput, forKey: "inputImage")
        // get output CIImage, render as CGImage first to retain proper UIImage scale
        let ciOutput = filter?.outputImage
        let ciContext = CIContext()
        let cgImage = ciContext.createCGImage(ciOutput!, from: (ciOutput?.extent)!)
        //Return the image
        return UIImage(cgImage: cgImage!)
    }
}
