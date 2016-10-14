
//
//  ViewController.swift
//  SnapFace
//
//  Created by Gaston Seneza on 9/6/16.
//  Copyright © 2016 baebeat. All rights reserved.
//

import UIKit

class PhotoController: UIViewController {

    lazy var cameraButton: UIButton = {
        let button = UIButton(type: .System)
        button.setTitle("Camera", forState: .Normal)
        button.tintColor = .whiteColor()
        button.backgroundColor = UIColor(red: 254/255.0, green: 123/255.0, blue: 135/255.0, alpha: 1.0)
        button.addTarget(self, action: #selector(PhotoController.presentImagePickerController), forControlEvents: .TouchUpInside)
        return button
    }()
    
    lazy var mediaPickerManager: MediaPickerManager = {
        let manager = MediaPickerManager(presentingViewController: self)
        manager.delegate = self
        return manager
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    //MARK: Layout
    
    override func viewWillLayoutSubviews() {
        view.addSubview(cameraButton)
        cameraButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activateConstraints([
            cameraButton.leftAnchor.constraintEqualToAnchor(view.leftAnchor),
            cameraButton.bottomAnchor.constraintEqualToAnchor(view.bottomAnchor),
            cameraButton.rightAnchor.constraintEqualToAnchor(view.rightAnchor),
            cameraButton.heightAnchor.constraintEqualToConstant(56.0)
            ])
    }

    //MARK: Image Picker Controller, i.e Selectors can only reference objective-c methods
    
    @objc private func presentImagePickerController() {
        mediaPickerManager.presentImagePickerController(animated: true)
    }
}

//MARK: -MediaPickerMAnagerDelegate
extension PhotoController: MediaPickerManagerDelegate {
    func mediaPickerManager(manager: MediaPickerManager, didFinishPickingImage image: UIImage) {
        
        let eaglContext = EAGLContext(API: .OpenGLES2)
        let ciContext = CIContext(EAGLContext: eaglContext)
        //instance of photofilter controller
        
        let photoFilterController = PhotoFilterController(image: image,context: ciContext, eaglContext: eaglContext)
        let navigationController = UINavigationController(rootViewController: photoFilterController)
        
        manager.dismissImagePickerController(animated: true) {
            self.presentViewController(navigationController, animated: true, completion: nil)
        }
    }
}

