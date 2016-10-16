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
        super.init(contentRect: contentRect, styleMask: style, backing: bufferingType, defer: flag)
        
        
        // z-index
        self.level = Int(CGWindowLevelForKey(CGWindowLevelKey.statusWindow)) +
            Int(CGWindowLevelForKey(CGWindowLevelKey.dockWindow)) +
            Int(CGWindowLevelForKey(CGWindowLevelKey.popUpMenuWindow)) +
        Int(CGWindowLevelForKey(CGWindowLevelKey.mainMenuWindow))
        
        
        self.animationBehavior = .none
        
        self.alphaValue = 1.0
        
        self.isOpaque = false
        //        self.hidesOnDeactivate = true
        self.backgroundColor = NSColor.clear
        self.titleVisibility = .hidden
    }
    
    override func keyDown(with event: NSEvent) {
        
        NSLog("isARepeat: \(event.isARepeat)")
        NSLog("keyCode: \(event.keyCode)")
        NSLog("type: \(event.type.rawValue)")
        super.keyDown(with: event)
        
//        if event.modifierFlags.contains(NSEventModifierFlags.command) {
//            super.keyDown(with: event)
//            return
//        }

    }
    
    override var canBecomeKey: Bool {
        return false
    }
    override var canBecomeMain: Bool{
        return false
    }
}
