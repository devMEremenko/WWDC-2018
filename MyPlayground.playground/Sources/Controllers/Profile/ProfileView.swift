//
//  ProfileView.swift
//  WWDC
//
//  Created by Maxim Eremenko on 4/1/18.
//  Copyright © Maxim Eremenko. All rights reserved.
//

import UIKit

struct ProfileViewConstants {
    
    static var contentSize: CGSize {
        return CGSize(width: ScreenConstant.screenSize.width, height: 1320)
    }
}

class ProfileView: UIView {
    
    let scrollView = WWScrollView(contentSize: ProfileViewConstants.contentSize)
    let profileContentView = ProfileContentView()
    let backgroundImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.configureViews()
    }
    
    func update(numberOfPages: Int) {
        self.profileContentView.update(numberOfPages: numberOfPages)
    }
    
    func update(currentPage: Int) {
        self.profileContentView.update(currentPage: currentPage)
    }
    
    func collectionView() -> UICollectionView? {
        return self.profileContentView.collectionView
    }
    
    func updateWith(againBlock: @escaping Empty) {
        self.profileContentView.updateWith(againBlock: againBlock)
    }
}

private extension ProfileView {
    
    func configureViews() {
        
        addSubview(backgroundImageView)
        addSubview(scrollView)
        
        backgroundImageView.image = UIImage.background
        backgroundImageView.snp.makeConstraints { maker in
            maker.edges.equalToSuperview()
        }
        
        let insets = UIEdgeInsetsMake(1, 0, 0, 0)
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.snp.makeConstraints { (make: ConstraintMaker) in
            make.edges.equalTo(self).inset(insets)
        }
        
        scrollView.contentView.addSubview(profileContentView)
        
        profileContentView.snp.makeConstraints { (make: ConstraintMaker) in
            make.edges.equalTo(self.scrollView.contentView)
        }
    }
}
