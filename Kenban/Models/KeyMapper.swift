//
//  KeyMapper.swift
//  Kenban
//
//  Created by kyamada on 2016/10/18.
//  Copyright © 2016年 kyamada. All rights reserved.
//

import Foundation
import Carbon
import Cocoa

class KeyMapper {
    let defaultMovingDistance: CGFloat = 10
    var isEnabledFastMouseMove: Bool = false
    var lastKeyDownCode: UInt16?
    var isInMouseMode: Bool = false
    
    init() {
        if acquirePrivileges() == false {
            NSApplication.sharedApplication().terminate(self)
        }
        addMonitorsForEvents()
        addActiveKeyBind()
    }

    func addMonitorsForEvents() {
        NSEvent.addGlobalMonitorForEventsMatchingMask([.KeyDown, .FlagsChanged], handler: {(event: NSEvent) in
            switch event.type {
            case .FlagsChanged:
                self.onFlagsChanged(event)
            case .KeyDown:
                self.lastKeyDownCode = event.keyCode
            default:
                break
            }
        })

        NSEvent.addLocalMonitorForEventsMatchingMask(.KeyDown) { (event) -> NSEvent! in
            self.onKeyDown(event)
            return nil
        }
        
        NSEvent.addLocalMonitorForEventsMatchingMask(.KeyUp) { (event) -> NSEvent! in
            self.onKeyUp(event)
            return nil
        }
    }
    
    func addActiveKeyBind() {
        HotKeys.register(UInt32(kVK_ANSI_D), modifiers: UInt32(cmdKey), block:{
            (id:EventHotKeyID) in
            NSApp.activateIgnoringOtherApps(true)
            guard let window = NSApp.mainWindow else { return }
            window.setFrame(NSRect(x: 0, y: 0, width: 0, height: 0), display: true)
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
    
    private var movingDistance: CGFloat {
        return isEnabledFastMouseMove ? defaultMovingDistance * 10 : defaultMovingDistance
    }
    
    private func onKeyDown(event: NSEvent) {
        let mouseLocation = CGEventGetLocation(CGEventCreate(nil))
        switch Int(event.keyCode) {
        case kVK_ANSI_H:
            // move cursor left
            moveMouse(NSPoint(x: -movingDistance, y: 0))
        case kVK_ANSI_J:
            // move cursor
            moveMouse(NSPoint(x: 0, y: movingDistance))
        case kVK_ANSI_K:
            // move cursor up
            moveMouse(NSPoint(x: 0, y: -movingDistance))
        case kVK_ANSI_L:
            // move cursor right
            moveMouse(NSPoint(x: movingDistance, y: 0))
        case kVK_ANSI_V:
            // click left mouse button
            clickLeftMouseButton(mouseLocation) // click to activate window
            clickLeftMouseButton(mouseLocation)
        case kVK_ANSI_B:
            // click right mouse button
            clickRightMouseButton(mouseLocation)
        case kVK_ANSI_F:
            isEnabledFastMouseMove = true
        default:
            break
        }
    }
    
    private func onKeyUp(event: NSEvent) {
        switch Int(event.keyCode) {
        case kVK_ANSI_F:
            isEnabledFastMouseMove = false
        default:
            break
        }
    }
    
    private func onFlagsChanged(event: NSEvent) {
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
    
    private func clickLeftMouseButton(mouseLocation: NSPoint) {
        CGEventPost(.CGHIDEventTap, CGEventCreateMouseEvent(nil, .LeftMouseDown, mouseLocation, .Left))
        CGEventPost(.CGHIDEventTap, CGEventCreateMouseEvent(nil, .LeftMouseUp,   mouseLocation, .Left))
    }
    
    private func clickRightMouseButton(mouseLocation: NSPoint) {
        CGEventPost(.CGHIDEventTap, CGEventCreateMouseEvent(nil, .RightMouseDown, mouseLocation, .Left))
        CGEventPost(.CGHIDEventTap, CGEventCreateMouseEvent(nil, .RightMouseUp,   mouseLocation, .Left))
    }

    private func hideWindow(){
        let window = NSApplication.firstWindow()
        window.setIsVisible(false)
        window.orderOut(self)
    }
}
