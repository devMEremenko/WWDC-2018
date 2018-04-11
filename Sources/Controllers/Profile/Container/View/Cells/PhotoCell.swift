//
//  PhotoCell.swift
//  WWDC
//
//  Created by Maxim Eremenko on 4/1/18.
//  Copyright © Maxim Eremenko. All rights reserved.
//

import UIKit

struct PhotoCellConstants {
    
    static let animationDuration = 0.4
}

class PhotoCell: UICollectionViewCell {
    
    let imageView = UIImageView()
    let infoLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.configureViews()
    }
    
    func updateWith(image: UIImage?) {
        self.imageView.image = image
    }
    
    func updateInfo(title: String?) {
        animatedUpdateInfo(title: title)
    }
}

private extension PhotoCell {
    
    func animatedUpdateInfo(title: String?) {
        
        let duration = PhotoCellConstants.animationDuration
        
        UIView.transition(with: self.infoLabel,
                          duration: duration,
                          options: [.transitionCrossDissolve, .beginFromCurrentState],
                          animations: {
                            self.infoLabel.text = title
                            self.infoLabel.alpha = 1.0
        }, completion: { finished in
            
            if finished {
                _ = [UIView .animate(withDuration: duration,
                                 delay: 1,
                                 options: [.transitionCrossDissolve, .beginFromCurrentState],
                                 animations: {
                                    self.infoLabel.alpha = 0
                }, completion: nil)]
            }
        })
    }
}

private extension PhotoCell {
    
    func configureViews() {
        self.contentView.clipsToBounds = true
        self.contentView.backgroundColor = UIColor.white
        self.contentView.addSubview(self.imageView)
        self.contentView.addSubview(self.infoLabel)

        self.imageView.contentMode = .scaleAspectFill
        self.imageView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.contentView)
        }
        
        infoLabel.alpha = 0
        infoLabel.textColor = UIColor.white
        infoLabel.textAlignment = .center
        infoLabel.font = UIFont.regular(size: 19)
        infoLabel.snp.makeConstraints { (make: ConstraintMaker) in
            make.centerX.equalTo(self.snp.centerX)
            make.top.equalTo(self).offset(22)
            make.height.equalTo(26)
            make.left.right.equalTo(self)
        }
    }
}
