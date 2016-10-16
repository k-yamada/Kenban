//
//  AppDelegate.swift
//  Kenban
//
//  Created by 山田 和弘 on 2016/10/14.
//  Copyright © 2016年 kyamada. All rights reserved.
//

import Cocoa
import Carbon

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    let statusItem = NSStatusBar.system().statusItem(withLength: -2)
    var lastKeyDownCode: UInt16?

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        
        if let button = statusItem.button {
            button.image = NSImage(named: "ic_keyboard")
            button.action = #selector(menuTapped)
        }
        
        if acquirePrivileges() == false {
            NSApplication.shared().terminate(self)
        }
        
        // keyboard listeners
        NSEvent.addGlobalMonitorForEvents(matching: [.keyDown], handler: {(event: NSEvent) in
            print(event)
            self.onKeyDown(event: event)
        })
        
        NSEvent.addGlobalMonitorForEvents(matching: [.keyUp], handler: {(event: NSEvent) in
            print(event)
            self.onKeyUp(event: event)
        })
        
        NSEvent.addGlobalMonitorForEvents(matching: [.flagsChanged], handler: {(event: NSEvent) in
            print(event)
            self.onFlagsChanged(event: event)
        })
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    func menuTapped(sender: AnyObject) {
        print("menu tapped")
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
    }
    
    func onKeyUp(event: NSEvent) {
    }
    
    func onFlagsChanged(event: NSEvent) {
        print(event.modifierFlags)
        
        // on modifier key up
        if event.keyCode == lastKeyDownCode {
            // CommandLeft to Eisuu
            if Int(event.keyCode) == kVK_Command {
                postKeyDownAndUp(keyCode: CGKeyCode(kVK_JIS_Eisu))
            }

            // CommandRight To Kana
            if Int(event.keyCode) == kVK_RightCommand {
                postKeyDownAndUp(keyCode: CGKeyCode(kVK_JIS_Kana))
            }
        }
        lastKeyDownCode = event.keyCode
    }
    
    private func postKeyDownAndUp(keyCode: CGKeyCode) {
        CGEvent.init(keyboardEventSource: nil, virtualKey: keyCode, keyDown: true)?.post(tap: .cghidEventTap)
        CGEvent.init(keyboardEventSource: nil, virtualKey: keyCode, keyDown: false)?.post(tap: .cghidEventTap)
    }
    
    private func postKeyEvent(keyCode: CGKeyCode, keyDown: Bool) {
        CGEvent.init(keyboardEventSource: nil, virtualKey: keyCode, keyDown: keyDown)?.post(tap: .cghidEventTap)
    }
}

