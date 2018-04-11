//
//  DemoVC.h
//  WWDC
//
//  Created by Maxim Eremenko on 3/31/18.
//  Copyright © 2018 Maxim Eremenko. All rights reserved.
//

import UIKit

class DemoVC: UIViewController {

    var eventHandler: DemoModuleInput?
    
    fileprivate let contentView = DemoView()
    
    fileprivate lazy var quickController = DemoController(collection: contentView.collection(type: .quick))
    fileprivate lazy var insertionController = DemoController(collection: contentView.collection(type: .insertion))
    fileprivate lazy var bubbleController = DemoController(collection: contentView.collection(type: .bubble))
    
    let timer = DemoTimer()
    let guideHandler = DemoGuideManager()
    
    override func loadView() {
        self.view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        eventHandler?.viewDidSetup()
        
        guideHandler.handler = { [weak self] guideState in
            guard let strong = self else { return }
            strong.contentView.update(guideState: guideState)
        }
        
        let quick = playbackHandler(type: .quick, controller: quickController)
        contentView.quickView.playbackView.handler = quick
        
        let insertion = playbackHandler(type: .insertion, controller: insertionController)
        contentView.insertionView.playbackView.handler = insertion
        
        let bubble = playbackHandler(type: .bubble, controller: bubbleController)
        contentView.bubbleView.playbackView.handler = bubble
        
        contentView.insertionView.resetButton.handler = { [weak self] in
            self?.timer.stop(type: .insertion)
            self?.insertionController.reset()
        }
        
        contentView.quickView.resetButton.handler = { [weak self] in
            self?.timer.stop(type: .quick)
            self?.quickController.reset()
        }
        
        contentView.bubbleView.resetButton.handler = { [weak self] in
            self?.timer.stop(type: .bubble)
            self?.bubbleController.reset()
        }
        
        contentView.profileButton.handler = {
            SceneManager.shared.presentProfile()
        }
    }
}

private extension DemoVC {
    
    func playbackHandler(type: AlgorithmType,
                         controller: DemoController) -> DemoActionHanlder {
        
        return { [weak self] action in
            guard let strong = self else { return }
            
            strong.guideHandler.nextState(after: .pressPlayButton)
            
            controller.sortCompletion = { [weak self] in
                self?.timer.stop(type: type)
                self?.contentView.handle(sortCompletion: type)
            }
            
            switch action {
            case .play:
                strong.timer.start(action: action, for: type, { [weak strong] type, action in
                    guard let sSelf = strong else { return }
                    sSelf.perform(action: action, controller: controller)
                })
            case .pause:
                strong.timer.stop(type: type)
            case .backward:
                strong.timer.stop(type: type)
                strong.perform(action: action, controller: controller)
            case .forward:
                strong.timer.stop(type: type)
                strong.perform(action: action, controller: controller)
            }
        }
    }
    
    private func perform(action: DemoAction, controller: DemoController) {
        
        switch action {
        case .play:
            controller.showNext()
        case .pause: break
        case .backward:
            controller.showPrevious()
        case .forward:
            controller.showNext()
        }
    }
}

extension DemoVC: DemoUserInterfaceInput {
    
    func display(queue: TransactionQueue<Int>, type: AlgorithmType) {
        
        switch type {
        case .quick:
            quickController.update(with: queue)
        case .insertion:
            insertionController.update(with: queue)
        case .bubble:
            bubbleController.update(with: queue)
        }
    }
}
