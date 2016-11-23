//
//  KeyCaptureWindow.swift
//  Kenban
//
//  Created by 山田 和弘 on 2016/10/15.
//  Copyright © 2016年 kyamada. All rights reserved.
//

import Cocoa
import Carbon

typealias Callback = (NSEvent) -> ()

class KeyCaptureWindow: NSWindow {
    override init(contentRect: NSRect, styleMask style: NSWindowStyleMask, backing bufferingType: NSBackingStoreType, defer flag: Bool) {
        super.init(contentRect: contentRect, styleMask: [NSBorderlessWindowMask, NSFullSizeContentViewWindowMask], backing: .Buffered, defer: false)
        
//        // z-index
        self.level = Int(CGWindowLevelForKey(CGWindowLevelKey.StatusWindowLevelKey)) +
            Int(CGWindowLevelForKey(CGWindowLevelKey.DockWindowLevelKey)) +
            Int(CGWindowLevelForKey(CGWindowLevelKey.PopUpMenuWindowLevelKey))
        self.animationBehavior = .None
        self.alphaValue = 1.0
        self.opaque = false
        self.backgroundColor = NSColor.clearColor()
        //self.backgroundColor = NSColor.redColor()
        self.titleVisibility = .Hidden
    }
    
    override var canBecomeKeyWindow: Bool {
        return false
    }
    
    override var canBecomeMainWindow: Bool {
        return false
    }
}
