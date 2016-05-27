//
//  NSNotificationCenter+RAC.swift
//  ReactiveCocoaConvenience
//
//  Created by Josh Campion on 27/05/2016.
//  Copyright © 2016 Josh Campion Development. All rights reserved.
//

import Foundation

import ReactiveCocoa
import Result

/// Adds convenience methods for typed `SignalProducers` from RAC Signal methods with `NoError` types for binding straight to `MutableProperty`s.
public extension NSNotificationCenter {
    
    /// - returns: A `SignalProducer` mapped from `rac_addObserverForName(_:object:)`
    public func rac_notificationSignalProducer(name: String, object: AnyObject?) -> SignalProducer<NSNotification, NoError> {
        
        return self.rac_addObserverForName(name, object: object)
            .toSignalProducer()
            .map({ $0 as! NSNotification })
            .flatMapError { _ in SignalProducer<NSNotification, NoError>.empty }
    }
}