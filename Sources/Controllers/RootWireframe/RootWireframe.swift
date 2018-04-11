//
//  RootWireframe.swift
//  WWDC
//
//  Created by Maxim Eremenko on 4/1/18.
//  Copyright © 2018 Maxim Eremenko. All rights reserved.
//

import UIKit

class RootWireframe: UINavigationController {
    
    struct TransitionConstant {
        static let demoID = "demoID"
    }
    
    convenience init() {
        let welcomeVC = WelcomeVC()
        welcomeVC.view.hero.id = TransitionConstant.demoID
        self.init(rootViewController: welcomeVC)
        self.hero.isEnabled = true
    }
    
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isNavigationBarHidden = true
    }
}

extension RootWireframe {
    
    func presentDemoScreen() {
        
        let demoVC = DemoAssembly().wireframe.viewController ?? UIViewController()
        
        demoVC.hero.isEnabled = true
        demoVC.view.hero.modifiers = [.size(CGSize(width: 20, height: 20)), .duration(1), .useNoSnapshot]
        hero.navigationAnimationType = .fade
        pushViewController(demoVC, animated: true)
    }
    
    func presentProfile() {
        
        let profileVC = ProfileVC()
        pushViewController(profileVC, animated: true)
    }
    
    func backToProfile() {
        popViewController(animated: true)
    }
}
