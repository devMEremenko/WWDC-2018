//
//  DemoAssembly.h
//  WWDC
//
//  Created by Maxim Eremenko on 3/31/18.
//  Copyright © 2018 Maxim Eremenko. All rights reserved.
//

import UIKit

class DemoAssembly {
    
    let wireframe = DemoWireframe()
    
    private let vc = DemoVC()
    private let presenter = DemoPresenter()
    private let interactor = DemoInteractor()
    
    init() {
        vc.eventHandler = presenter
        presenter.userInterface = vc
        presenter.wireframe = wireframe
        presenter.interactor = interactor

        wireframe.viewController = vc
        wireframe.moduleInterface = presenter

        interactor.output = presenter
    }
}
