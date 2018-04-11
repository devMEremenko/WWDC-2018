//
//  WelcomeView.swift
//  WWDC
//
//  Created by Maxim Eremenko on 4/1/18.
//  Copyright © 2018 Maxim Eremenko. All rights reserved.
//

import UIKit

class WelcomeView: UIView {
    
    let backgroundImageView = UIImageView(image: UIImage.background)
    let nextButton = UIButton(type: .custom)
    let titleLabel = UILabel()
    let detailLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
}

private extension WelcomeView {
    
    func setup() {
        
        addSubview(backgroundImageView)
        addSubview(nextButton)
        addSubview(titleLabel)
        addSubview(detailLabel)
        
        backgroundImageView.snp.makeConstraints { maker in
            maker.edges.equalToSuperview()
        }
        
        titleLabel.text = String.loc("welcome.title.label")
        titleLabel.textColor = UIColor.white
        titleLabel.font = UIFont.semibold(size: 25)
        titleLabel.numberOfLines = 1
        titleLabel.textAlignment = .left
        titleLabel.snp.makeConstraints { maker in
            let insets = UIEdgeInsetsMake(40, 40, 0, 40)
            maker.top.left.right.equalTo(self).inset(insets)
            maker.height.equalTo(40)
        }
        
        detailLabel.text = String.loc("welcome.detail.label")
        detailLabel.textColor = UIColor.white
        detailLabel.font = UIFont.regular(size: 20)
        detailLabel.numberOfLines = 0
        detailLabel.snp.makeConstraints { maker in
            let insets = UIEdgeInsetsMake(100, 40, 0, 40)
            maker.top.left.right.equalTo(self).inset(insets)
        }
        
        nextButton.applyNativeStyle()
        nextButton.setTitle(String.loc("welcome.action.title"), for: .normal)
        nextButton.snp.makeConstraints { maker in
            maker.size.equalTo(UIButton.Constant.defaultSize)
            maker.centerX.equalToSuperview()
            maker.bottom.equalTo(self).offset(-140)
        }
    }
}
