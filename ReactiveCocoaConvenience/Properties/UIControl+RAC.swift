//
//  UIControl+RAC.swift
//  TestReactive
//
//  Created by Josh Campion on 24/02/2016.
//  Copyright © 2016 Josh Campion. All rights reserved.
//

import UIKit

import ReactiveCocoa

public extension UIControl {
    
    public var rac_enabled: MutableProperty<Bool> {
        return lazyMutableProperty(self, key: &AssociationKey.enabled, setter: { self.enabled = $0 }, getter: { self.enabled })
    }
    
}