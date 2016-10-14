//
//  AppDelegate.swift
//  Kenban
//
//  Created by kyamada on 2016/10/14.
//  Copyright © 2016年 kyamada. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    @IBOutlet var statusMenu: NSMenu?
    let statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(-2)
    let keyMapper = KeyMapper()
    
    func applicationDidFinishLaunching(notification: NSNotification) {
        NSMenu.setMenuBarVisible(false)
        showStatusBarMenu()
    }
    
    func applicationWillTerminate(notification: NSNotification) {
        // Insert code here to tear down your application
    }
    
    func showStatusBarMenu(){
        statusItem.menu = self.statusMenu
        if let button = self.statusItem.button {
            button.image = NSImage(named: "ic_keyboard")
        }
        let menu = NSMenu()
        menu.addItem(NSMenuItem.separatorItem())
        menu.addItem(NSMenuItem(title: "Exit", action: #selector(AppDelegate.exitNow(_:)), keyEquivalent: "Q"))
        statusItem.menu = menu
    }
    
    @IBAction func exitNow(sender: AnyObject) {
        NSApplication.sharedApplication().terminate(self)
    }
}

