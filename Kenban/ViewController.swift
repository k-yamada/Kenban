//
//  ViewController.swift
//  Kenban
//
//  Created by kyamada on 2016/10/14.
//  Copyright © 2016年 kyamada. All rights reserved.
//

import Carbon
import Cocoa

class ViewController: NSViewController, NSWindowDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear() {
        view.window?.setFrame(NSRect(x: 0, y: 0, width: 0, height: 0), display: true)
    }
    
    override func viewDidAppear() {
    }
    
    override var acceptsFirstResponder: Bool {
        get {
            return true
        }
    }
}

