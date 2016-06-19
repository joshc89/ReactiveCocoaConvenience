//
//  UISlider+RAC.swift
//  ReactiveCocoaConvenience
//
//  Created by Josh Campion on 19/06/2016.
//  Copyright © 2016 Josh Campion Development. All rights reserved.
//

import Foundation

import ReactiveCocoa
import Result

/// Adds convenience methods for typed `SignalProducers` from RACSignal methods with `NoError` types for binding straight to `MutableProperty`s.
public extension UISlider {
    
    /// - returns: A `SignalProducer` for the changing value of the stepper
    public func rac_signalProducerForValue() -> SignalProducer<Float, NoError> {
        
        return rac_signalForControlEvents(.ValueChanged)
            .toSignalProducer()
            .map({ ($0 as! UISlider).value })
            .flatMapError({ _ in SignalProducer<Float, NoError>.empty })
    }
    
}