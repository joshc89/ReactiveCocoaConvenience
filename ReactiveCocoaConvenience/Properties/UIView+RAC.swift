//
//  UIView+RAC.swift
//  TestReactive
//
//  Created by Josh Campion on 24/02/2016.
//  Copyright © 2016 Josh Campion. All rights reserved.
//

import UIKit

import ReactiveCocoa

public extension UIView {
    
    public var rac_alpha: MutableProperty<CGFloat> {
        return lazyMutableProperty(self, key: &AssociationKey.alpha, setter: { self.alpha = $0 }, getter: { self.alpha })
    }
    
    public var rac_hidden: MutableProperty<Bool> {
        return lazyMutableProperty(self, key: &AssociationKey.hidden, setter: { self.hidden = $0 }, getter: { self.hidden  })
    }
}