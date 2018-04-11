//
//  DemoCell.swift
//  WWDC
//
//  Created by Maxim Eremenko on 3/31/18.
//  Copyright © 2018 Maxim Eremenko. All rights reserved.
//

import UIKit

class DemoCell: UICollectionViewCell, DeclarativeCell {
    
    typealias T = DemoCellModel<Int>
    let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textColor = .blue
        titleLabel.textAlignment = .center
        return titleLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func configure(_ model: DemoCellModel<Int>, path: IndexPath) {
        layer.borderColor = model.backgroundColor.cgColor
        guard let value = model.transaction.value else { return }
        titleLabel.text = String(value)
    }
    
    func animate() {
        
        guard let layerColor = layer.borderColor else { return }
        let color = UIColor(cgColor: layerColor)
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .beginFromCurrentState, animations: {
            self.contentView.backgroundColor = color
        }) { finished in
            UIView.animate(withDuration: 0.3, delay: 0, options: .beginFromCurrentState, animations: {
                self.contentView.backgroundColor = .clear
            })
        }
    }
}

private extension DemoCell {
    
    func setup() {
        layer.cornerRadius = 20
        layer.masksToBounds = true
        layer.borderWidth = 4
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { maker in
            maker.edges.equalTo(self.contentView)
        }
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        titleLabel.textColor = UIColor.white
        titleLabel.font = UIFont.semibold(size: 34)
    }
}

struct DemoCellModel<T> {
    
    let transaction: Transaction<T>
    let backgroundColor: UIColor
    
    init(_ transaction: Transaction<T>, _ backgroundColor: UIColor) {
        self.transaction = transaction
        self.backgroundColor = backgroundColor
    }
}
