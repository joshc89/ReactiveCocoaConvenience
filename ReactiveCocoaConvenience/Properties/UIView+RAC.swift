//
//  UIView+RAC.swift
//  TestReactive
//
//  Created by Josh Campion on 24/02/2016.
//  Copyright © 2016 Josh Campion. All rights reserved.
//

import UIKit

import ReactiveCocoa

/// Adds convenience ReactiveCocoa `MutableProperty`s for commonly bound UIKit equivalents.
public extension UIView {
    
    /**
     
     ReactiveCocoa equivalent to `alpha`.
     
     - seealso: `lazyMutableProperty(_:key:setter:getter:)`
     */
    public var rac_alpha: MutableProperty<CGFloat> {
        return lazyMutableProperty(self, key: &AssociationKey.alpha, setter: { self.alpha = $0 }, getter: { self.alpha })
    }
    
    /**
     
     ReactiveCocoa equivalent to `hidden`.
     
     - seealso: `lazyMutableProperty(_:key:setter:getter:)`
     */
    public var rac_hidden: MutableProperty<Bool> {
        return lazyMutableProperty(self, key: &AssociationKey.hidden, setter: { self.hidden = $0 }, getter: { self.hidden  })
    }
}