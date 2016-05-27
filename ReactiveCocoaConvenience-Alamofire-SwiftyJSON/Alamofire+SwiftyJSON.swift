//
//  Alamofire+SwiftyJSON.swift
//  TestReactive
//
//  Created by Josh Campion on 19/03/2016.
//  Copyright © 2016 Josh Campion. All rights reserved.
//

import Foundation

import Alamofire
import SwiftyJSON

/// Extension to `Alamofire.Request` for adding a response serialized as a `SwiftyJSON` object.
public extension Request {
    
    /**
     Creates a response serializer that returns an object constructed from the response data using `JSON(data:options:error:)` with the specified reading options. Errors are passed as a `.Failed` event.
     
     - parameter options: The json reading options. `.AllowFragments` by default.
     
     - returns: A `JSON` object response serializer.
     */
    public static func swiftyJSONResponseSerializer(
        options options: NSJSONReadingOptions = .AllowFragments)
        -> ResponseSerializer<JSON, NSError>
    {
        return ResponseSerializer { _, response, data, error in
            guard error == nil else { return .Failure(error!) }
            
            if let response = response where response.statusCode == 204 { return .Success(JSON(NSNull())) }
            
            guard let validData = data where validData.length > 0 else {
                let failureReason = "JSON could not be serialized. Input data was nil or zero length."
                let error = Error.errorWithCode(.JSONSerializationFailed, failureReason: failureReason)
                return .Failure(error)
            }
            
            var jsonError:NSError?
            let json = JSON(data: validData, options: options, error: &jsonError)
            
            if let error = jsonError {
                return .Failure(error)
            } else {
                return .Success(json)
            }
        }
    }
    
    /**
     Adds a handler to be called once the request has finished.
     
     - parameter options: The json reading options. `.AllowFragments` by default.
     - parameter completionHandler: A closure to be executed once the request has finished. The closure takes a single argument, the Alamofire `Response<JSON, NSError>`.
     
     - returns: The request.
     */
    public func responseSwiftyJSON(
        options options: NSJSONReadingOptions = .AllowFragments,
        completionHandler: Response<JSON, NSError> -> Void)
        -> Self
    {
        return response(
            responseSerializer: Request.swiftyJSONResponseSerializer(options: options),
            completionHandler: completionHandler
        )
    }
}

/// Portocol defining a standard method of creating an object from a `SwiftyJSON` object.
public protocol JSONCreated {
    
    /// Initialise this object using a `SwiftyJSON` object. If the `JSON` object is incorrect, this should throw an error.
    init(json:JSON) throws
}

/// Adds convenience method for `String`.
public extension String {
    
    /**
     
     Convenience method for setting optional values from empty strings in `JSON` objects.
     
     - returns: self if self is not empty, nil otherwise.
     
    */
    public var nonEmpty:String? {
        return self.isEmpty ? nil : self
    }
}

/// Adds convenience method for `Array`.
public extension Array {
    
    /**
     
     Convenience method for setting optional values from empty arrays in `JSON` objects.
     
     - returns: self if self has count greater than 0, nil otherwise.
     
     */
    public var nonEmpty:Array<Element>? {
        return self.count > 0 ? self : nil
    }
}