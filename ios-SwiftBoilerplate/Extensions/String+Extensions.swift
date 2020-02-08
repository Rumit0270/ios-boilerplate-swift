//
//  String+Extensions.swift
//  ios-SwiftBoilerplate
//
//  Created by Mac on 2/8/20.
//

import Foundation

extension String {
    func trim() -> String {
        return trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
}
