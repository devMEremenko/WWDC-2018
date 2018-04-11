//
//  DemoView.h
//  WWDC
//
//  Created by Maxim Eremenko on 3/31/18.
//  Copyright © 2018 Maxim Eremenko. All rights reserved.
//

import UIKit

struct DemoConstant {
    
    static var itemSize: CGSize { return CGSize(width: 100, height: 100) }
    static var itemsCount: Int { return 6 }
    static var minimumInteritemSpacing: CGFloat { return 10 }

    static var collectionHeight: CGFloat { return 120 }
    static var contentViewHeight: CGFloat { return 270 }
}

class DemoView: UIView {
    
    let quickView = DemoContentView()
    let insertionView = DemoContentView()
    let bubbleView = DemoContentView()
    let terminal = TerminalView()
    let profileButton = UIButton()
    
    fileprivate let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    fileprivate let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    let backgroundImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage.background)
        imageView.backgroundColor = .white
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
}

extension DemoView {
    
    func collection(type: AlgorithmType) -> UICollectionView {
        switch type {
        case .quick:
            return quickView.collection
        case .insertion:
            return insertionView.collection
        case .bubble:
            return bubbleView.collection
        }
    }
    
    func update(guideState: DemoGuideState) {
        terminal.update(guideState: guideState)
    }
    
    func handle(sortCompletion type: AlgorithmType) {
        switch type {
        case .insertion:
            insertionView.presentCompletionAnimation()
        case .quick:
            quickView.presentCompletionAnimation()
        case .bubble:
            bubbleView.presentCompletionAnimation()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        scrollView.contentSize = stackView.frame.size
    }
}

private extension DemoView {
    
    func setup() {
        
        addSubview(backgroundImageView)
        addSubview(terminal)
        addSubview(profileButton)
        addSubview(scrollView)
        scrollView.addSubview(stackView)
        
        stackView.addArrangedSubview(insertionView)
        stackView.addArrangedSubview(quickView)
        stackView.addArrangedSubview(bubbleView)
        
        scrollView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[stackView]|", options: NSLayoutFormatOptions.alignAllCenterX, metrics: nil, views: ["stackView": stackView]))
        scrollView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[stackView]", options: NSLayoutFormatOptions.alignAllCenterX, metrics: nil, views: ["stackView": stackView]))
        
        backgroundImageView.snp.makeConstraints { maker in
            maker.edges.equalToSuperview()
        }
        
        terminal.snp.makeConstraints { maker in
            maker.height.equalTo(56)
            maker.right.equalToSuperview().inset(UIEdgeInsetsMake(0, 100, 0, 120))
            maker.top.equalToSuperview().offset(40)
            maker.left.equalToSuperview().offset(37)
        }
        
        profileButton.titleLabel?.font = UIFont.semibold(size: 18)
        profileButton.setTitleColor(Colors.blue, for: .normal)
        profileButton.setTitle(String.loc("guide.profile.button"), for: .normal)
        profileButton.snp.makeConstraints { maker in
            let insets = UIEdgeInsetsMake(40, 0, 0, 10)
            maker.right.equalTo(self).inset(insets)
            maker.centerY.equalTo(self.terminal.snp.centerY)
            maker.size.equalTo(CGSize(width: 100, height: 80))
        }
        
        scrollView.snp.makeConstraints { maker in
            maker.top.equalTo(self).offset(120)
            maker.left.right.equalToSuperview()
            maker.bottom.equalTo(self).offset(-20)
        }

        insertionView.update(type: .insertion)
        insertionView.snp.makeConstraints { maker in
            maker.width.equalTo(ScreenConstant.screenSize.width)
            maker.height.equalTo(DemoConstant.contentViewHeight)
        }
        
        quickView.update(type: .quick)
        quickView.snp.makeConstraints { maker in
            maker.width.equalTo(ScreenConstant.screenSize.width)
            maker.height.equalTo(DemoConstant.contentViewHeight)
        }
        
        bubbleView.update(type: .bubble)
        bubbleView.snp.makeConstraints { maker in
            maker.width.equalTo(ScreenConstant.screenSize.width)
            maker.height.equalTo(DemoConstant.contentViewHeight)
        }
    }
}
