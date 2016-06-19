//
//  UIStepper+RAC.swift
//  ReactiveCocoaConvenience
//
//  Created by Josh Campion on 19/06/2016.
//  Copyright © 2016 Josh Campion Development. All rights reserved.
//

import Foundation

import ReactiveCocoa
import Result

/// Adds convenience methods for typed `SignalProducers` from RACSignal methods with `NoError` types for binding straight to `MutableProperty`s.
public extension UIStepper {
    
    /// - returns: A `SignalProducer` for the changing value of the stepper
    public func valueSignalProducer() -> SignalProducer<Double, NoError> {
        
        return rac_signalForControlEvents(.ValueChanged)
            .toSignalProducer()
            .map({ ($0 as! UIStepper).value })
            .flatMapError({ _ in SignalProducer<Double, NoError>.empty })
    }
    
}