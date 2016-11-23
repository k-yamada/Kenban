//
//  KeyMapper.swift
//  Kenban
//
//  Created by 山田 和弘 on 2016/10/18.
//  Copyright © 2016年 kyamada. All rights reserved.
//

import Foundation
import Carbon
import Cocoa

class KeyMapper {
    var lastKeyDownCode: UInt16?
    let mouseModeKeyCode: Int = kVK_ANSI_D
    var isInMouseMode: Bool = false
    
    init() {
        if acquirePrivileges() == false {
            NSApplication.sharedApplication().terminate(self)
        }
        addMonitorsForEvents()
//        addActiveKeyBind()
    }
    
    func addMonitorsForEvents() {
        NSEvent.addGlobalMonitorForEventsMatchingMask([.KeyDown], handler: {(event: NSEvent) in
//            print(event)
            self.onKeyDown(event)
        })
        
        NSEvent.addGlobalMonitorForEventsMatchingMask([.KeyUp], handler: {(event: NSEvent) in
//            print(event)
            self.onKeyUp(event)
        })
        
        NSEvent.addGlobalMonitorForEventsMatchingMask([.FlagsChanged], handler: {(event: NSEvent) in
//            print(event)
            self.onFlagsChanged(event)
        })
    }
    
    func removeKeyBind(){
        HotKeys.unregister(UInt32(kVK_ANSI_H + activeFlag))
        HotKeys.unregister(UInt32(kVK_ANSI_J + activeFlag))
        HotKeys.unregister(UInt32(kVK_ANSI_K + activeFlag))
        HotKeys.unregister(UInt32(kVK_ANSI_L + activeFlag))
        HotKeys.unregister(UInt32(kVK_Escape + activeFlag))
    }
    
    func addActiveKeyBind() {
        HotKeys.register(UInt32(kVK_ANSI_D), modifiers: UInt32(controlKey), block:{
            (id:EventHotKeyID) in
            print("---Activate---")
            NSApplication.maximizeWindow()
            self.addHitKeyBind()
            //            self.addClickBind()
            //            self.addMoveKeyBind()
            self.addCancelKeyBind()
        })
    }
    
    func addHitKeyBind() {
        // HotKey to move the cursor to the left
        HotKeys.register(UInt32(kVK_ANSI_H), modifiers: UInt32(activeFlag), block:{
            (id:EventHotKeyID) in
            print("move left")
            self.moveMouse(NSPoint(x: -10, y: 0))
        })
        
        // HotKey to move the cursor down
        HotKeys.register(UInt32(kVK_ANSI_J), modifiers: UInt32(activeFlag), block:{
            (id:EventHotKeyID) in
            print("move down")
            self.moveMouse(NSPoint(x: 0, y: 10))
        })
        
        // HotKey to move the cursor up
        HotKeys.register(UInt32(kVK_ANSI_K), modifiers: UInt32(activeFlag), block:{
            (id:EventHotKeyID) in
            self.moveMouse(NSPoint(x: 0, y: -10))
        })
        
        // HotKey to move the cursor to the right
        HotKeys.register(UInt32(kVK_ANSI_L), modifiers: UInt32(activeFlag), block:{
            (id:EventHotKeyID) in
            print("move right")
            self.moveMouse(NSPoint(x: 10, y: 0))
        })
        
        // HotKey to click
        
        // HotKey to right click
        
    }
    
    func addCancelKeyBind() {
        HotKeys.register(UInt32(kVK_Escape), modifiers: UInt32(activeFlag), block:{
            (id:EventHotKeyID) in
            print("---Cancel--")
            self.hideWindow()
            self.removeKeyBind();
        })
    }
    
    func acquirePrivileges() -> Bool {
        let trusted = kAXTrustedCheckOptionPrompt.takeUnretainedValue()
        let privOptions: CFDictionary? = [String(trusted): true] as CFDictionary
        let accessEnabled = AXIsProcessTrustedWithOptions(privOptions)
        if accessEnabled != true {
            print("You need to enable the access in the System Preferences")
        }
        return accessEnabled == true
    }
    
    func onKeyDown(event: NSEvent) {
        lastKeyDownCode = event.keyCode
        if Int(event.keyCode) == mouseModeKeyCode {
            isInMouseMode = true
        }
        
//        if isInMouseMode {         if Int(event.keyCode) == kVK_ANSI_H {
//                var mouseLocation = NSEvent.mouseLocation()
        
//                mouseLocation.x = mouseLocation.x - 1
//                CGEvent.init(mouseEventSource: nil, mouseType: .mouseMoved, mouseCursorPosition: mouseLocation, mouseButton: .left)?.post(tap: .cghidEventTap)
//            }
//        }
    }
    
    func onKeyUp(event: NSEvent) {
        if Int(event.keyCode) == mouseModeKeyCode {
            isInMouseMode = false
        }
    }
    
    func onFlagsChanged(event: NSEvent) {
        //print(event.modifierFlags)
        
        // on modifier key up
        if event.keyCode == lastKeyDownCode {
            // CommandLeft to Eisuu
            if Int(event.keyCode) == kVK_Command {
                postKeyDownAndUp(CGKeyCode(kVK_JIS_Eisu))
            }
            
            // CommandRight To Kana
            if Int(event.keyCode) == kVK_RightCommand {
                postKeyDownAndUp(CGKeyCode(kVK_JIS_Kana))
            }
        }
        lastKeyDownCode = event.keyCode
    }
    
    private func postKeyDownAndUp(keyCode: CGKeyCode) {
        CGEventPost(.CGHIDEventTap, CGEventCreateKeyboardEvent(nil, keyCode, true))
        CGEventPost(.CGHIDEventTap, CGEventCreateKeyboardEvent(nil, keyCode, false))
    }
    
    private func postKeyEvent(keyCode: CGKeyCode, keyDown: Bool) {
        CGEventPost(.CGHIDEventTap, CGEventCreateKeyboardEvent(nil, keyCode, keyDown))
    }
    
    private func moveMouse(diffPoint: NSPoint) {
        var mouseLocation = CGEventGetLocation(CGEventCreate(nil))
        mouseLocation.x = mouseLocation.x + diffPoint.x
        mouseLocation.y = mouseLocation.y + diffPoint.y
        postMouseMoveEvent(mouseLocation)
    }
    
    private func postMouseMoveEvent(mouseLocation: NSPoint) {
        
        CGEventPost(.CGHIDEventTap, CGEventCreateMouseEvent(nil, .MouseMoved, mouseLocation, .Left))
    }
    

    
    private func hideWindow(){
        let window = NSApplication.firstWindow()
        window.setIsVisible(false)
        window.orderOut(self)
    }
}
