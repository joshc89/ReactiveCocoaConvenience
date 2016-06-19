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

/// Struct for holding all the keys used in `objc_getAssociatedObject(...)` and `objc_setAssociatedObject(...)` for the associated ReactiveCocoa property extensions.
public struct AssociationKey {

    // MARK: UIView Properties
    
    /// The key used for the `rac_hidden` property on `UIView`s.
    public static var hidden:UInt8 = 0
    /// The key used for the `rac_alpha` property on `UIView`s.
    public static var alpha:UInt8 = 0
    
    // MARK: UIControl Properties
    
    /// The key used for the `rac_enabled` property on `UIControl`s.
    public static var enabled:UInt8 = 0
    
    /// The key used for the `rac_value` property on `UIStepper`s and `UISlider`.
    public static var value:UInt8 = 0
    
    
    // MARK: Text Properties
    
    /// The key used for the `rac_Text` property on `UILabel`s, `UITextField`s and `UITextView`s.
    public static var text:UInt8 = 0
    
    /// The key used for the `rac_attributedText` property on `UILabel`s, `UITextField`s and `UITextView`s.
    public static var attributedText:UInt8 = 0
    
}

/**
 
 A utility function for creating lazily-constructed associated properties
 
 - note: Original Source: [Colin Eberhart's "Reactive Twitter Search"](https://github.com/ColinEberhardt/ReactiveTwitterSearch/blob/master/ReactiveTwitterSearch/Util/UIKitExtensions.swift)
 
 - parameter host: The object the property is to be associated with.
 - parameter key: The address of the key this value is associated with.
 - parameter factory: Closure defining the initial value.
 
 */
public func lazyAssociatedProperty<T: AnyObject>(host: AnyObject, key: UnsafePointer<Void>, factory: ()->T) -> T {

    var associatedProperty = objc_getAssociatedObject(host, key) as? T
    
    if associatedProperty == nil {
        associatedProperty = factory()
        objc_setAssociatedObject(host, key, associatedProperty,
                                 .OBJC_ASSOCIATION_RETAIN)
    }
    
    return associatedProperty!
}

/**
 
 Lazily-constructed associated property for a ReactiveCocoa `MutableProperty` of a given type.
 
 - note: Original Source: [Colin Eberhart's "Reactive Twitter Search"](https://github.com/ColinEberhardt/ReactiveTwitterSearch/blob/master/ReactiveTwitterSearch/Util/UIKitExtensions.swift)
 
 - seealso: `lazyAssociatedProperty(_:key:factory:)`.
 
 - parameter host: The object the property is to be associated with.
 - parameter key: The address of the key this value is associated with.
 - parameter setter: Closure defining how the new value from a `.Next` event of this `MutableProperty` should be set on the original object.
 - parameter getter: Close defining how the initial value of this `MutableProperty` should be set.
 
 */
public func lazyMutableProperty<T>(host: AnyObject, key: UnsafePointer<Void>, setter: T -> (), getter: () -> T) -> MutableProperty<T> {
        return lazyAssociatedProperty(host, key: key) {
            
            let property = MutableProperty<T>(getter())
            property.producer
                .startWithNext({ setter($0) })
            return property
        }
}