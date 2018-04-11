//
//  TerminalView.swift
//  WWDC
//
//  Created by Maxim Eremenko on 3/31/18.
//  Copyright © 2018 Maxim Eremenko. All rights reserved.
//

import UIKit

class TerminalView: UIView {
    
    let textLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
}

extension TerminalView {
    
    func update(guideState: DemoGuideState) {
        
        UIView.transition(with: textLabel,
                          duration: 0.45,
                          options: .transitionCrossDissolve,
                          animations: {
                            self.textLabel.text = guideState.message
            }, completion: nil)
    }
}

private extension TerminalView {
    
    func setup() {
        
        layer.cornerRadius = 22
        layer.masksToBounds = true
        layer.borderColor = Colors.blue.cgColor
        layer.borderWidth = 4
        
        textLabel.textAlignment = .center
        textLabel.textColor = .white
        textLabel.font = UIFont.semibold(size: 20)

        addSubview(textLabel)
        textLabel.snp.makeConstraints { maker in
            maker.centerX.equalToSuperview()
            maker.centerY.equalToSuperview()
            maker.left.right.equalToSuperview()
        }
        
        update(guideState: .pressPlayButton)
    }
    
    private func setupAppearance() {
        backgroundColor = UIColor.color(92, 92, 92, 0.4)
    }
}
