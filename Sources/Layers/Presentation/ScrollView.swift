//
//  WWScrollView.swift
//  WWDC
//
//  Created by Maxim Eremenko on 4/1/18.
//  Copyright © 2018 Maxim Eremenko. All rights reserved.
//

import UIKit

class WWScrollView: UIScrollView {
    
    let contentView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    convenience init(contentSize: CGSize) {
        self.init(frame: .zero)
        self.configureViews(with: contentSize)
    }
}

private extension WWScrollView {
    
    func configureViews(with contentSize: CGSize) {
        self.addSubview(contentView)
        
        contentView.snp.makeConstraints { (make: ConstraintMaker) in
            make.edges.equalTo(self)
            make.width.equalTo(self.snp.width)
            make.height.equalTo(contentSize.height).priority(ConstraintPriority.low)
        }
    }
}
