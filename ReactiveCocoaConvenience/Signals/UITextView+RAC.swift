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

public extension UITextView {
    
    public func rac_textSignalProducer() -> SignalProducer<String, NoError> {
        
        return rac_textSignal()
            .toSignalProducer()
            .map({ ($0 as? String) ?? "" })
            .flatMapError({ _ in SignalProducer<String, NoError>.empty })
    }
    
    
    
}

public extension NSNotificationCenter {
    
    public func rac_notificationSignalProducer(name: String, object: AnyObject?) -> SignalProducer<NSNotification, NoError> {
        
        return self.rac_addObserverForName(name, object: object)
            .toSignalProducer()
            .map({ $0 as! NSNotification })
            .flatMapError { _ in SignalProducer<NSNotification, NoError>.empty }
    }
}