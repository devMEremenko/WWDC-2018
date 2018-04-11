//
//  ProfileBuilder.swift
//  WWDC
//
//  Created by Maxim Eremenko on 4/1/18.
//  Copyright © Maxim Eremenko. All rights reserved.
//

import UIKit

struct WWProfileConstants {
    static let numberOfPhotos = 6
}

class ProfileBuilder: NSObject {
    
    static func createModels() -> [PhotoDomainModel] {
        
        var models = [PhotoDomainModel]()
        
        for counter in 0 ..< WWProfileConstants.numberOfPhotos {
            let photoName = "profile_photo_" + "\(counter + 1)"
            let photoModel = PhotoDomainModel(image: UIImage(named: photoName))
            models.append(photoModel)
        }
        
        return models
    }
}
