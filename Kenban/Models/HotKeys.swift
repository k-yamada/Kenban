//
//  HotKeys.swift
//  Kenban
//
//  Created by 山田 和弘 on 2016/10/18.
//  Copyright © 2016年 kyamada. All rights reserved.
//

import Foundation
import Carbon
class HotKeys {
    private let hotKey: UInt32
    private let block: (id:EventHotKeyID) -> ()
    private static var eventHandler: EventHandlerRef = nil
    private static var keycodeHotKeys:[UInt32:EventHotKeyRef] = [:]
    private static let signature:FourCharCode = UTGetOSTypeFromString("HotKeys")
    
    typealias action = (id:EventHotKeyID) -> Void
    private static var onceToken : dispatch_once_t = 0
    static var blocks = [UInt32:action]()
    
    private init(hotKeyID: UInt32, block: (id:EventHotKeyID) -> ()) {
        self.hotKey = hotKeyID
        self.block = block
        HotKeys.blocks[hotKey] = block
    }
    
    static func registerHandler() -> Bool {
        var eventHandler: EventHandlerRef = nil
        var eventType = EventTypeSpec(eventClass: OSType(kEventClassKeyboard), eventKind: UInt32(kEventHotKeyPressed))
        
        guard InstallEventHandler(GetApplicationEventTarget(), {(handlerRef: EventHandlerCallRef, eventRef: EventRef, ptr: UnsafeMutablePointer<Void>) -> OSStatus in
            var hotKeyID: EventHotKeyID = EventHotKeyID()
            let status = GetEventParameter(
                eventRef,
                EventParamName(kEventParamDirectObject),
                EventParamType(typeEventHotKeyID),
                nil,
                sizeof(EventHotKeyID),
                nil,
                &hotKeyID
            )
            
            if status != noErr || hotKeyID.signature != HotKeys.signature {
                return errSecBadReq
            }
            
            HotKeys.blocks[hotKeyID.id]!(id: hotKeyID)
            return noErr
            }, 1, &eventType, nil, &eventHandler) != noErr else {
                return false
        }
        HotKeys.eventHandler = eventHandler
        return  true
    }
    
    class func register(keycode: UInt32, modifiers: UInt32, block: (id:EventHotKeyID) -> ()) -> HotKeys? {
        dispatch_once(&onceToken) {
            let status = HotKeys.registerHandler()
            print("registerHandler: \(String(status))")
        }
        
        let id:UInt32 = keycode + modifiers
        
        if HotKeys.isRegister(id) {
            return nil
        }
        
        var hotKey: EventHotKeyRef = nil
        let hotKeyID = EventHotKeyID(signature:HotKeys.signature, id: id)
        RegisterEventHotKey(keycode, modifiers, hotKeyID, GetApplicationEventTarget(), OptionBits(0), &hotKey)
        HotKeys.keycodeHotKeys[id] = hotKey
        return HotKeys(hotKeyID: id, block: block)
    }
    
    
//    class func register(keycode: UInt32, modifiers: UInt32, block: (id:EventHotKeyID) -> ()) -> HotKeys? {
//        let id:UInt32 = keycode + modifiers
//        if HotKeys.isRegister(id) {
//            return nil
//        }
//        var hotKey: EventHotKeyRef = nil
//        let hotKeyID = EventHotKeyID(signature:HotKeys.signature, id: id)
//        RegisterEventHotKey(keycode, modifiers, hotKeyID, GetApplicationEventTarget(), OptionBits(0), &hotKey)
//        HotKeys.keycodeHotKeys[id] = hotKey
//        return HotKeys(hotKeyID: id, block: block)
//    }
//    
    static func unregister(id:UInt32) {
        if HotKeys.isRegister(id) {
            UnregisterEventHotKey(HotKeys.keycodeHotKeys[id]!)
            HotKeys.keycodeHotKeys[id] = nil
        }
    }
    
    static func unregisterAll() {
        for (keycode, _) in HotKeys.keycodeHotKeys {
            HotKeys.unregister(UInt32(keycode))
        }
    }
    
    static func isRegister(id:UInt32) -> Bool {
        return HotKeys.keycodeHotKeys[id] != nil
    }
}
