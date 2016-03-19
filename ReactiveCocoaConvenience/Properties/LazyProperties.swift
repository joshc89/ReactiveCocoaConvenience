//
//  LazyProperties.swift
//  TestReactive
//
//  Created by Josh Campion on 23/02/2016.
//  Copyright © 2016 Josh Campion. All rights reserved.
//

import Foundation
import ObjectiveC
import ReactiveCocoa

public struct AssociationKey {

    // UIView
    public static var hidden:UInt8 = 0
    public static var alpha:UInt8 = 0
    
    // UIControl
    public static var enabled:UInt8 = 0
    
    // Text
    public static var text:UInt8 = 0
    
}

/// Method from [Colin Eberhart's "Reactive Twitter Search"](https://github.com/ColinEberhardt/ReactiveTwitterSearch/blob/master/ReactiveTwitterSearch/Util/UIKitExtensions.swift)
public func lazyAssociatedProperty<T: AnyObject>(host: AnyObject, key: UnsafePointer<Void>, factory: ()->T) -> T {

    var associatedProperty = objc_getAssociatedObject(host, key) as? T
        
        if associatedProperty == nil {
            associatedProperty = factory()
            objc_setAssociatedObject(host, key, associatedProperty,
                .OBJC_ASSOCIATION_RETAIN)
        }
    
        return associatedProperty!
}

/// Method from [Colin Eberhart's "Reactive Twitter Search"](https://github.com/ColinEberhardt/ReactiveTwitterSearch/blob/master/ReactiveTwitterSearch/Util/UIKitExtensions.swift)
public func lazyMutableProperty<T>(host: AnyObject, key: UnsafePointer<Void>, setter: T -> (), getter: () -> T) -> MutableProperty<T> {
        return lazyAssociatedProperty(host, key: key) {
            
            let property = MutableProperty<T>(getter())
            property.producer
                .startWithNext({ setter($0) })
            return property
        }
}