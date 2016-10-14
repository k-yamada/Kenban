//
//  NSApplication+Extension.swift
//  Kenban
//
//  Created by kyamada on 2016/10/30.
//  Copyright © 2016年 kyamada. All rights reserved.
//

import Foundation
import AppKit

extension NSApplication {
    class func firstWindow() -> NSWindow {
        return NSApplication.sharedApplication().windows.first!
    }
}
