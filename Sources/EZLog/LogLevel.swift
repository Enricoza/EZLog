//
//  LogLevel.swift
//  
//
//  Created by Enrico Zannini on 13/12/25.
//

import Foundation

public enum LogLevel: Int {
    case trace = 0
    case debug = 100
    case info = 200
    case notice = 300
    case warn = 400
    case error = 800
    case fault = 900
}
