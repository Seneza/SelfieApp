//
//  FIlteredImageCell.swift
//  SnapFace
//
//  Created by Gaston Seneza on 9/12/16.
//  Copyright © 2016 baebeat. All rights reserved.
//

import UIKit
import GLKit

class FIlteredImageCell: UICollectionViewCell {
    static let reuseIdentifier = String(FIlteredImageCell.self)
    
    var eaglContext: EAGLContext!
    var ciContext: CIContext!
   
    lazy var glkView: GLKView = {
        let view = GLKView(frame: self.contentView.frame, context: self.eaglContext)
        view.delegate = self
        return view
    }()
    
    var image: CIImage!
    
    override func layoutSubviews() {
        contentView.addSubview(glkView)
        glkView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activateConstraints([
            glkView.topAnchor.constraintEqualToAnchor(contentView.topAnchor),
            glkView.rightAnchor.constraintEqualToAnchor(contentView.rightAnchor),
            glkView.bottomAnchor.constraintEqualToAnchor(contentView.bottomAnchor),
            glkView.leftAnchor.constraintEqualToAnchor(contentView.leftAnchor)
            ])
    }
}

extension FIlteredImageCell: GLKViewDelegate {
    func glkView(view: GLKView, drawInRect rect: CGRect) {
        let drawableRectSize = CGSize(width: glkView.drawableWidth, height: glkView.drawableHeight)
        let drawableRect  = CGRect(origin: CGPointZero, size: drawableRectSize)
        ciContext.drawImage(image, inRect: drawableRect, fromRect: image.extent)
    }
}
