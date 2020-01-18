//
//  Logger.swift
//  ios-SwiftBoilerplate
//
//  Created by Mac on 1/9/20.
//

import Foundation
import XCGLogger

/// Use to log any info in the console.
/// Provides much more detail than the normal print() function while debugging.
let logger: XCGLogger = {
    
    let log = XCGLogger.default
    
    log.setup(level: .debug, showLogIdentifier: false, showFunctionName: true, showThreadName: true, showLevel: true, showFileNames: true, showLineNumbers: true, showDate: true, writeToFile: nil, fileLevel: nil)
    
    let emojiLogFormatter = PrePostFixLogFormatter()
    emojiLogFormatter.apply(prefix: " 🗯 ", postfix: " 🗯 ", to: .verbose)
    emojiLogFormatter.apply(prefix: " 🔹 ", postfix: " 🔹 ", to: .debug)
    emojiLogFormatter.apply(prefix: " ℹ️ ", postfix: " ℹ️ ", to: .info)
    emojiLogFormatter.apply(prefix: " ⚠️ ", postfix: " ⚠️ ", to: .warning)
    emojiLogFormatter.apply(prefix: " ‼️ ", postfix: " ‼️ ", to: .error)
    emojiLogFormatter.apply(prefix: " 💣 ", postfix: " 💣 ", to: .severe)
    
    log.formatters = [emojiLogFormatter]
    
    return log
}()
