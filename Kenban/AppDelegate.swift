//
//  AppDelegate.swift
//  Kenban
//
//  Created by 山田 和弘 on 2016/10/14.
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
        NSApplication.maximizeWindow()
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
        menu.addItem(NSMenuItem(title: "About Kenban", action: #selector(AppDelegate.showAbout(_:)), keyEquivalent: "A"))
        menu.addItem(NSMenuItem.separatorItem())
        menu.addItem(NSMenuItem(title: "Exit", action: #selector(AppDelegate.exitNow(_:)), keyEquivalent: "Q"))
        statusItem.menu = menu
    }
    
    @IBAction func showAbout(sender : AnyObject) {
//        let storyboard : NSStoryboard = NSStoryboard(name: "Main", bundle: nil)
//        self.aboutWindowController = storyboard.instantiateControllerWithIdentifier("AboutWindowController") as! AboutWindowController
//        self.aboutWindowController.showWindow(self)
    }
    
    @IBAction func exitNow(sender: AnyObject) {
        NSApplication.sharedApplication().terminate(self)
    }
    
    func menuTapped(sender: AnyObject) {
        print("menu tapped")
    }
}

