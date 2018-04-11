//
//  ProfileVC.swift
//  WWDC
//
//  Created by Maxim Eremenko on 4/1/18.
//  Copyright © Maxim Eremenko. All rights reserved.
//

import UIKit

class ProfileVC: UIViewController {
    
    let contentView = ProfileView()
    let controller = ProfileController()
    
    override func loadView() {
        self.view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureModule()
    }
}

private extension ProfileVC {
    
    func configureModule() {
        
        let models = ProfileBuilder.createModels()
        self.controller.attach(collectionView: self.contentView.collectionView())
        self.controller.updateWith(models: models)
        self.controller.updateWith { (page: Int) in
            self.contentView.update(currentPage: page)
        }
        
        self.contentView.update(numberOfPages: models.count)
        self.contentView.updateWith(againBlock: {
            SceneManager.shared.backToProfile()
        })
    }
}
