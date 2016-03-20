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

public extension UITextField {
    
    public func rac_textSignalProducer() -> SignalProducer<String, NoError> {
        return rac_textSignal()
            .toSignalProducer()
            .map({ ($0 as? String) ?? "" })
            .flatMapError({ _ in SignalProducer<String, NoError>.empty })
    }
    
    public func rac_textSignalProducerForEvents(events:UIControlEvents) -> SignalProducer<String, NoError> {
        
        return rac_signalForControlEvents(events)
            .toSignalProducer()
            .map({ ($0 as? UITextField)?.text ?? "" })
            .flatMapError({ _ in SignalProducer<String, NoError>.empty })
    }
    
}