//
//  ViewController.swift
//  Kenban
//
//  Created by 山田 和弘 on 2016/10/14.
//  Copyright © 2016年 kyamada. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear() {
        view.layer?.backgroundColor = NSColor.clearColor().CGColor
    }

}

