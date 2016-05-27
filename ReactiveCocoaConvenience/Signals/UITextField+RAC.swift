//
//  UITextField+RAC.swift
//  TestReactive
//
//  Created by Josh Campion on 23/02/2016.
//  Copyright © 2016 Josh Campion. All rights reserved.
//

import UIKit

import ReactiveCocoa
import Result

/// Adds convenience methods for typed `SignalProducers` from RACSignal methods with `NoError` types for binding straight to `MutableProperty`s.
public extension UIControl {
    
    /// - returns: A `SignalProducer` mapped from `rac_signalForControlEvents()` to the `UIControl` sending the event.
    public func rac_signalProducerForEvents(events:UIControlEvents) -> SignalProducer<UIControl, NoError> {
        
        return rac_signalForControlEvents(events)
            .toSignalProducer()
            .map({ $0 as! UIControl })
            .flatMapError({ _ in SignalProducer<UIControl, NoError>.empty })
    }
    
}

/// Adds convenience methods for typed `SignalProducers` from RACSignal methods with `NoError` types for binding straight to `MutableProperty`s.
public extension UITextField {
    
    /// - returns: A `SignalProducer` mapped from `rac_textSignal()`.
    public func rac_textSignalProducer() -> SignalProducer<String, NoError> {
        return rac_textSignal()
            .toSignalProducer()
            .map({ ($0 as? String) ?? "" })
            .flatMapError({ _ in SignalProducer<String, NoError>.empty })
    }
    
}