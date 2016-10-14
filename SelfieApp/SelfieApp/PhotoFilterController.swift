//
//  PhotoFilterController.swift
//  SnapFace
//
//  Created by Gaston Seneza on 9/7/16.
//  Copyright © 2016 baebeat. All rights reserved.
//

import UIKit

class PhotoFilterController: UIViewController {

    private var mainImage: UIImage
    private let context: CIContext
    private let eaglContext: EAGLContext
    

    private let photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .ScaleAspectFit
        return imageView
    }()
    
    private lazy var filterHeaderLabel: UILabel = {
        let label = UILabel()
        label.text = "Select a filter"
        label.textAlignment = .Center
        return label
    }()
    
    lazy var filtersCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .Horizontal
        flowLayout.minimumLineSpacing = 10 //minimum of 10 points away from each other
        flowLayout.minimumInteritemSpacing = 1000
        flowLayout.itemSize = CGSize(width: 100, height: 100)
        
        let collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = .whiteColor()
        collectionView.registerClass(FIlteredImageCell.self, forCellWithReuseIdentifier: FIlteredImageCell.reuseIdentifier)
        
        collectionView.dataSource = self
        
        return collectionView
    }()
    
    private lazy var filteredImages: [CIImage] = {
        let filteredImageBuilder = FilteredImageBuilder(context: self.context,image: self.mainImage)
        return filteredImageBuilder.imageWithDefaultFilters()
    }()
    
    init(image: UIImage,context: CIContext, eaglContext: EAGLContext) {
        self.mainImage = image
        self.context = context
        self.eaglContext =  eaglContext 
        
        self.photoImageView.image = self.mainImage
        super.init(nibName: nil, bundle: nil)
    }
    //view controller initializer method
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    // Layout Code
    override func viewWillLayoutSubviews() {
        photoImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(photoImageView)
        
        filterHeaderLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(filterHeaderLabel)
        
        filtersCollectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(filtersCollectionView)
        
        NSLayoutConstraint.activateConstraints([
            filtersCollectionView.bottomAnchor.constraintEqualToAnchor(view.bottomAnchor),
            filtersCollectionView.leftAnchor.constraintEqualToAnchor(view.leftAnchor),
            filtersCollectionView.rightAnchor.constraintEqualToAnchor(view.rightAnchor),
            filtersCollectionView.heightAnchor.constraintEqualToConstant(200.0),
            filtersCollectionView.topAnchor.constraintEqualToAnchor(filterHeaderLabel.bottomAnchor),
            filterHeaderLabel.leftAnchor.constraintEqualToAnchor(view.leftAnchor),
            filterHeaderLabel.rightAnchor.constraintEqualToAnchor(view.rightAnchor),
            photoImageView.bottomAnchor.constraintEqualToAnchor(filtersCollectionView.topAnchor),
            photoImageView.topAnchor.constraintEqualToAnchor(view.topAnchor),
            photoImageView.leftAnchor.constraintEqualToAnchor(view.leftAnchor),
            photoImageView.rightAnchor.constraintEqualToAnchor(view.rightAnchor)
            ])
    }
}

//MARK: UICollectionView dataSource

extension PhotoFilterController: UICollectionViewDataSource {
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredImages.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(FIlteredImageCell.reuseIdentifier, forIndexPath: indexPath) as! FIlteredImageCell
        
        let ciImage = filteredImages[indexPath.item]
        cell.ciContext = context
        cell.eaglContext = eaglContext
        cell.image = ciImage
        return cell
    }
}
