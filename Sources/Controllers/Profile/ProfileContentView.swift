//
//  ProfileContentView.swift
//  WWDC
//
//  Created by Maxim Eremenko on 4/1/18.
//  Copyright © Maxim Eremenko. All rights reserved.
//

import UIKit

struct ProfileContentViewConstants {
    static let avatarSide = 130
    static let collectionHeight = 220
    static let itemSize = CGSize(width: 200, height: ProfileContentViewConstants.collectionHeight)
}

class ProfileContentView: UIView {
    
    let userImageView = UIImageView()
    let usernameLabel = UILabel()
    let infoLabel = UILabel()
    let infoMiddleLabel = UILabel()
    let againButton = UIButton()
    var againBlock : ((()->Void)?)
    let pageControl = UIPageControl()
    var collectionView : UICollectionView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.configureViews()
    }
    
    func update(numberOfPages: Int) {
        self.pageControl.numberOfPages = numberOfPages
    }
    
    func update(currentPage: Int) {
        self.pageControl.currentPage = currentPage
    }
    
    func updateWith(againBlock: @escaping Empty) {
        self.againBlock = againBlock
    }
}

private extension ProfileContentView {
    
    func configureViews() {
        
        backgroundColor = UIColor.clear
        
        addSubview(userImageView)
        addSubview(usernameLabel)
        addSubview(infoLabel)
        addSubview(infoMiddleLabel)
        addSubview(againButton)
        addSubview(pageControl)
        
        let avatarSide = ProfileContentViewConstants.avatarSide
        userImageView.image = UIImage(named: "profile_avatar")
        userImageView.updateToAvatarTheme(side: CGFloat(avatarSide))
        userImageView.snp.makeConstraints { (make: ConstraintMaker) in
            make.top.equalTo(self).offset(24)
            make.width.equalTo(avatarSide)
            make.height.equalTo(avatarSide)
            make.centerX.equalTo(self.snp.centerX)
        }
        
        let insets = UIEdgeInsetsMake(0, 26, 0, 30)
        usernameLabel.text = String.loc("profile.username.label.title")
        usernameLabel.numberOfLines = 0
        usernameLabel.font = UIFont.semibold(size: 28)
        usernameLabel.textColor = Colors.green
        usernameLabel.textAlignment = .center

        usernameLabel.font = UIFont.semibold(size: 17)
        usernameLabel.snp.makeConstraints { (make: ConstraintMaker) in
            make.top.equalTo(self.userImageView.snp.bottom).offset(20)
            make.left.right.equalTo(self).inset(insets)
            make.height.equalTo(24)
        }
        
        infoLabel.text = String.loc("profile.info.label.title")
        infoLabel.numberOfLines = 0
        infoLabel.font = UIFont.regular(size: 18)
        infoLabel.textColor = UIColor.white
        infoLabel.textAlignment = .center

        infoLabel.snp.makeConstraints { (make: ConstraintMaker) in
            make.top.equalTo(self.usernameLabel.snp.bottom).offset(-10)
            make.left.right.equalTo(self).inset(insets)
            make.height.equalTo(240)
        }
        
        self.attachCollection()
        self.attachPageControl()
        
        let infoMiddleInsets = UIEdgeInsetsMake(0, 32, 0, 32)
        infoMiddleLabel.text = String.loc("profile.middle.info.label.title")
        infoMiddleLabel.numberOfLines = 0
        infoMiddleLabel.font = UIFont.regular(size: 18)
        infoMiddleLabel.textColor = UIColor.white
        infoMiddleLabel.textAlignment = .center
        
        infoMiddleLabel.snp.makeConstraints { (make: ConstraintMaker) in
            make.top.equalTo(self.pageControl.snp.bottom).offset(30)
            make.left.right.equalTo(self).inset(infoMiddleInsets)
            make.height.equalTo(440)
        }
        
        let againTitle = String.loc("profile.again.button.title")
        againButton.setTitle(againTitle, for: .normal)
        againButton.applyNativeStyle()
        againButton.titleLabel?.font = UIFont.semibold(size: 17)
        
        againButton.handler = {
            self.againBlock?()
        }
        againButton.snp.makeConstraints { (make) in
            make.top.equalTo(self.infoMiddleLabel.snp.bottom).offset(35)
            make.size.equalTo(UIButton.Constant.defaultSize)
            make.centerX.equalTo(self.snp.centerX)
        }
    }
}


private extension ProfileContentView {
    
    func attachPageControl() {
        let pageInsets = UIEdgeInsetsMake(0, 40, 0, 40)
        pageControl.snp.makeConstraints { (make: ConstraintMaker) in
            make.left.right.equalTo(self).inset(pageInsets)
            make.height.equalTo(8)
            make.top.equalTo((self.collectionView?.snp.bottom)!).offset(13)
        }
        pageControl.isUserInteractionEnabled = false
        pageControl.currentPageIndicatorTintColor = Colors.blue
        pageControl.pageIndicatorTintColor = UIColor.white
    }
    
    func attachCollection() {
        
        self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.layout())
        self.collectionView?.backgroundColor = UIColor.clear
        self.collectionView?.showsHorizontalScrollIndicator = false
        self.collectionView?.showsVerticalScrollIndicator = false
        self.collectionView?.isPagingEnabled = false
        self.collectionView?.isScrollEnabled = true
        
        self.addSubview(self.collectionView!)
        
        self.collectionView?.snp.makeConstraints({ (make) in
            make.left.right.equalTo(self)
            make.top.equalTo(self.infoLabel.snp.bottom).offset(20)
            make.height.equalTo(ProfileContentViewConstants.collectionHeight)
        })
    }
    
    func layout() -> UICollectionViewFlowLayout {
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = ProfileContentViewConstants.itemSize
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = UIEdgeInsetsMake(0, 5, 0, 5)
        layout.scrollDirection = .horizontal
        
        return layout
    }
}

extension UIImageView {
    
    func updateToAvatarTheme(side: CGFloat) {
        
        let cornerRadius = side / 2
        self.layer.cornerRadius = CGFloat(ceilf(Float(cornerRadius)))
        self.layer.masksToBounds = true
        self.contentMode = .scaleAspectFill
    }
}
