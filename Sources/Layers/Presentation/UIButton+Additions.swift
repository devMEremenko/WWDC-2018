//
//  UIButton+Additions.swift
//  WWDC
//
//  Created by Maxim Eremenko on 3/31/18.
//  Copyright © 2018 Maxim Eremenko. All rights reserved.
//

import UIKit

struct ClosureWrapper {
    
    let closure: Empty
    init(closure: @escaping Empty) {
        self.closure = closure
    }
}

extension UIButton {
    
    private struct AssociatedKeys {
        static var actionWrapper = "actionWrapper"
    }
    
    var handler: Empty? {
        
        get {
            let object = objc_getAssociatedObject(self, &AssociatedKeys.actionWrapper)
            guard let wrapper = object as? ClosureWrapper else { return nil }
            return wrapper.closure
        }
        
        set (newValue) {
            
            let policy = objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC
            
            if let closure = newValue {
                let wrapper = ClosureWrapper(closure: closure)
                objc_setAssociatedObject(self, &AssociatedKeys.actionWrapper, wrapper, policy)
                addTarget(self, action: #selector(UIButton.actionSelected), for: .touchUpInside)
                
            } else {
                objc_setAssociatedObject(self, &AssociatedKeys.actionWrapper, nil, policy)
                removeTarget(self, action: #selector(UIButton.actionSelected), for: .touchUpInside)
            }
        }
    }
    
    @objc private func actionSelected() {
        handler?()
    }
}
