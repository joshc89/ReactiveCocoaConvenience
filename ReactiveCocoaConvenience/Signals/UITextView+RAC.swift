//
//  UITextView+RAC.swift
//  ReactiveCocoaConvenience
//
//  Created by Josh Campion on 19/03/2016.
//  Copyright © 2016 Josh Campion Development. All rights reserved.
//

import UIKit

import ReactiveCocoa
import Result

/// Adds convenience methods for typed `SignalProducers` from RAC Signal methods with `NoError` types for binding straight to `MutableProperty`s.
public extension UITextView {
    
    /// - returns: A `SignalProducer` mapped from `rac_textSignal()`.
    public func rac_textSignalProducer() -> SignalProducer<String, NoError> {
        
        return rac_textSignal()
            .toSignalProducer()
            .map({ ($0 as? String) ?? "" })
            .flatMapError({ _ in SignalProducer<String, NoError>.empty })
    }
    
    
    
}