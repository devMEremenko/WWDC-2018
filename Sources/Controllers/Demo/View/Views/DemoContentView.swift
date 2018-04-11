//
//  DemoContentView.swift
//  WWDC
//
//  Created by Maxim Eremenko on 3/31/18.
//  Copyright © 2018 Maxim Eremenko. All rights reserved.
//

import UIKit

class DemoContentView: UIView {

    var collection: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = DemoConstant.itemSize
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.backgroundColor = .clear
        collection.forLastBaselineLayout.layer.speed = 0.28
        return collection
    }()
    
    let playbackView = DemoPlaybackView()
    let resetButton = UIButton(type: .custom)
    let algoNameLabal = UILabel()
    let completionLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
}

extension DemoContentView {
    
    func update(type: AlgorithmType) {
        switch type {
        case .insertion:
            algoNameLabal.text = String.loc("algorithm.name.insertion")
        case .quick:
            algoNameLabal.text = String.loc("algorithm.name.quick")
        case .bubble:
            algoNameLabal.text = String.loc("algorithm.name.bubble")
        }
    }
    
    func presentCompletionAnimation() {
        
        UIView.animate(withDuration: 1,
                       delay: 0,
                       usingSpringWithDamping: 2,
                       initialSpringVelocity: 0.5,
                       options: .beginFromCurrentState,
                       animations: {
                        self.completionLabel.alpha = self.completionLabel.alpha > 0 ? 0 : 1
        }) { _ in
            UIView.animate(withDuration: 1, delay: 1, options: [], animations: {
                self.completionLabel.alpha = 0
            }, completion: nil)
        }
    }
}

private extension DemoContentView {
    
    func setup() {
        
        addSubview(collection)
        addSubview(playbackView)
        addSubview(resetButton)
        addSubview(algoNameLabal)
        addSubview(completionLabel)
        
        collection.snp.makeConstraints { maker in
            maker.left.equalTo(self).offset(offset)
            maker.right.equalTo(self).offset(-offset)
            maker.top.equalTo(self).offset(offset)
            maker.height.equalTo(DemoConstant.collectionHeight)
        }

        playbackView.snp.makeConstraints { maker in
            maker.left.bottom.right.equalTo(self)
            maker.top.equalTo(self.collection.snp.bottom).offset(30)
        }

        resetButton.setImage(UIImage.reload, for: .normal)
        resetButton.imageEdgeInsets = UIEdgeInsetsMake(27, 27, 27, 27)
        resetButton.snp.makeConstraints { maker in
            maker.size.equalTo(CGSize(width: 80, height: 80))
            maker.right.equalToSuperview().offset(-10)
            maker.centerY.equalTo(self.playbackView.snp.centerY)
        }

        algoNameLabal.font = UIFont.semibold(size: 18)
        algoNameLabal.textColor = UIColor.white
        algoNameLabal.snp.makeConstraints { maker in
            maker.left.equalToSuperview().offset(offset / 1.6)
            maker.bottom.equalTo(self.collection.snp.top).offset(-18)
            maker.width.equalTo(200)
            maker.height.equalTo(30)
        }
        
        completionLabel.alpha = 0
        completionLabel.textAlignment = .right
        completionLabel.text = "Sorted!"
        completionLabel.textColor = UIColor.random()
        completionLabel.font = UIFont.semibold(size: 22)
        completionLabel.snp.makeConstraints { maker in
            maker.right.equalToSuperview().offset(-offset)
            maker.bottom.equalTo(self.collection.snp.top).offset(-18)
            maker.width.equalTo(200)
            maker.height.equalTo(30)
        }
    }
    
    private var offset: CGFloat {
        let itemsWidth = DemoConstant.itemSize.width * CGFloat(DemoConstant.itemsCount)
        let insets = DemoConstant.minimumInteritemSpacing * CGFloat(DemoConstant.itemsCount - 1)
        return (ScreenConstant.screenSize.width - itemsWidth - insets) / 2
    }
}
