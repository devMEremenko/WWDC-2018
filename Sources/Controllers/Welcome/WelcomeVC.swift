//
//  WelcomeVC.swift
//  WWDC
//
//  Created by Maxim Eremenko on 4/1/18.
//  Copyright © 2018 Maxim Eremenko. All rights reserved.
//

import UIKit

class WelcomeVC: UIViewController {
    
    let contentView = WelcomeView()
    
    override func loadView() {
        self.view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hero.isEnabled = true
        contentView.hero.id = "1"
        contentView.hero.modifiers = [.fade]
        
        contentView.nextButton.handler = {
            SceneManager.shared.presentDemoScreen()
        }
    }
}
