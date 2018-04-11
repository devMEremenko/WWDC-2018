//
//  DemoPlaybackView.swift
//  WWDC
//
//  Created by Maxim Eremenko on 3/31/18.
//  Copyright © 2018 Maxim Eremenko. All rights reserved.
//

import UIKit

typealias DemoActionHanlder = (DemoAction) -> ()

enum DemoAction: Int {
    case play
    case pause
    case backward
    case forward
    
    static var count: Int { return 4 }
}

class DemoPlaybackView: UIView {
    
    struct Constant {
        
        static var buttonSize: CGSize { return CGSize(width: 80, height: 80) }
        static var padding: CGFloat {
            let fullWidth = ScreenConstant.screenSize.width
            let buttonsWidth = buttonSize.width * CGFloat(DemoAction.count)
            return (fullWidth - buttonsWidth) / 2
        }
    }
    
    let backwardButton = UIButton(type: .custom)
    let playButton = UIButton(type: .custom)
    let pauseButton = UIButton(type: .custom)
    let forwardButton = UIButton(type: .custom)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    var handler: DemoActionHanlder?
}

private extension DemoPlaybackView {
    
    func setup() {
        
        addSubview(backwardButton)
        addSubview(playButton)
        addSubview(pauseButton)
        addSubview(forwardButton)
        
        setupLayout()
        setupActions()
    }
    
    private func setupActions() {
        
        backwardButton.handler = { [weak self] in
            self?.handler?(.backward)
        }
        
        playButton.handler = { [weak self] in
            self?.handler?(.play)
        }
        
        pauseButton.handler = { [weak self] in
            self?.handler?(.pause)
        }
        
        forwardButton.handler = { [weak self] in
            self?.handler?(.forward)
        }
    }
    
    private func setupLayout() {
        
        backwardButton.setTitle("Backward", for: .normal)
        playButton.setTitle("Play", for: .normal)
        pauseButton.setTitle("Pause", for: .normal)
        forwardButton.setTitle("Forward", for: .normal)
        
        backwardButton.setImage(UIImage.backward, for: .normal)
        playButton.setImage(UIImage.play, for: .normal)
        pauseButton.setImage(UIImage.pause, for: .normal)
        forwardButton.setImage(UIImage.forward, for: .normal)
        
        let insets = UIEdgeInsetsMake(18, 18, 18, 18)
        backwardButton.imageEdgeInsets = insets
        playButton.imageEdgeInsets = insets
        pauseButton.imageEdgeInsets = insets
        forwardButton.imageEdgeInsets = insets
        
        backwardButton.snp.makeConstraints { maker in
            maker.left.equalTo(self.snp.left).offset(Constant.padding)
            maker.centerY.equalTo(self.snp.centerY)
            maker.size.equalTo(Constant.buttonSize)
        }
        
        playButton.snp.makeConstraints { maker in
            maker.left.equalTo(self.backwardButton.snp.right)
            maker.centerY.equalTo(self.snp.centerY)
            maker.size.equalTo(Constant.buttonSize)
        }
        
        pauseButton.snp.makeConstraints { maker in
            maker.left.equalTo(self.playButton.snp.right)
            maker.centerY.equalTo(self.snp.centerY)
            maker.size.equalTo(Constant.buttonSize)
        }
        
        forwardButton.snp.makeConstraints { maker in
            maker.left.equalTo(self.pauseButton.snp.right)
            maker.centerY.equalTo(self.snp.centerY)
            maker.size.equalTo(Constant.buttonSize)
        }
    }
}
