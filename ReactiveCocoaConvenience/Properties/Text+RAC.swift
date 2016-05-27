//
//  Text+RAC.swift
//  ReactiveCocoaConvenience
//
//  Created by Josh Campion on 27/05/2016.
//  Copyright © 2016 Josh Campion Development. All rights reserved.
//

import Foundation

import ReactiveCocoa

/// Protocol defining common properties between `UITextField` and `UILabel` for setting text related attributes.
public protocol TextProperties: class {
    
    /// The text of this object.
    var text:String? { get set }
    
    /// An `NSAttributedString` representing the text of this object.
    var attributedText:NSAttributedString? { get set }
}

/// `UITextField` has automatic conformance to `TextProperties`.
extension UITextField: TextProperties { }

/// `UILabel` has automatic conformance to `TextProperties`.
extension UILabel: TextProperties { }

/// Adds convenience ReactiveCocoa `MutableProperty`s for commonly bound UIKit equivalents. Default implementations are given for objects conforming to `TextProperties`.
public protocol ReactiveTextProperties: class {
    
    /**
     
     ReactiveCocoa equivalent to `text`.
     
     - seealso: `lazyMutableProperty(_:key:setter:getter:)`
     */
    var rac_text: MutableProperty<String?>  { get }
    
    /**
     
     ReactiveCocoa equivalent to `text`.
     
     - seealso: `lazyMutableProperty(_:key:setter:getter:)`
     */
    var rac_attributedText: MutableProperty<NSAttributedString?> { get }
}



/// Adds convenience ReactiveCocoa `MutableProperty`s for commonly bound UIKit equivalents.
extension ReactiveTextProperties where Self:TextProperties {
    
    /// Conformance to `ReactiveTextProperties` using `lazyMutableProperty(_:key:setter:getter:)`.
    public var rac_text: MutableProperty<String?> {
        return lazyMutableProperty(self, key: &AssociationKey.text, setter: { self.text = $0 }, getter: { self.text })
    }
    
    /// Conformance to `ReactiveTextProperties` using `lazyMutableProperty(_:key:setter:getter:)`.
    public var rac_attributedText: MutableProperty<NSAttributedString?> {
        return lazyMutableProperty(self, key: &AssociationKey.attributedText, setter: { self.attributedText = $0 }, getter: { self.attributedText })
    }
}

/// Adds convenience ReactiveCocoa `MutableProperty`s for commonly bound UIKit equivalents.
extension UITextView: ReactiveTextProperties {
    
    /// Conformance to `ReactiveTextProperties` using `lazyMutableProperty(_:key:setter:getter:)`.
    public var rac_text: MutableProperty<String?> {
        return lazyMutableProperty(self, key: &AssociationKey.text, setter: { self.text = $0 }, getter: { .Some(self.text) })
    }
    
    /// Conformance to `ReactiveTextProperties` using `lazyMutableProperty(_:key:setter:getter:)`.
    public var rac_attributedText: MutableProperty<NSAttributedString?> {
        return lazyMutableProperty(self, key: &AssociationKey.attributedText, setter: { self.attributedText = $0 }, getter: { .Some(self.attributedText) })
    }
}