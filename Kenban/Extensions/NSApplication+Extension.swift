//
//  NSApplication+Extension.swift
//  Kenban
//
//  Created by 山田 和弘 on 2016/10/30.
//  Copyright © 2016年 kyamada. All rights reserved.
//

import Foundation
import AppKit

extension NSApplication {
    class func firstWindow() -> NSWindow {
        return NSApplication.sharedApplication().windows.first!
    }
    
    class func maximizeWindow() {
        let window = NSApplication.firstWindow()
        var windowFrame = window.frame
        windowFrame.size =  NSScreen.mainScreen()!.frame.size
        windowFrame.origin  = NSMakePoint(0, 0)
        
        window.setFrame(windowFrame,display: true)
        window.orderFront(self)
        window.center()
    }
}
