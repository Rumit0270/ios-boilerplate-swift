//
//  Box.swift
//  ios-SwiftBoilerplate
//
//  Created by Mac on 1/3/20.
//
import Foundation

/// This is a class created as an wrapper of data to be used by view models
/// - Parameters:
/// - T: type which the Box Model will encapsulate

class Box<T> {
    
    typealias Listener = (T) -> Void
    var listener: Listener?
    
    /**
     Actual value wrapped by the Box class
    */
    var value: T {
        didSet {
            listener?(value)
        }
    }
    
    init(_ value: T) {
        self.value = value
    }
    
    /**
     Call this function for showing binding data with your view controller
     - Parameters:
     - listener: a callback function to invoke when the data value changes
     
     ### Usage Example: ###
     ````
     viewModel.data.bind { [unowned self] (data) in
     }
     ````
     */
    func bind(_ listener: @escaping Listener) {
        self.listener = listener
        self.listener?(value)
    }
}
