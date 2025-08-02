//
//  HotkeyManager.swift
//  Cortex
//
//  Created by Hadi Ahmad on 7/31/25.
//

import Carbon.HIToolbox
import Cocoa

func registerGlobalHotkey() {
    var hotKeyRef: EventHotKeyRef?
    let hotKeyID = EventHotKeyID(signature: OSType("CRTX".fourCharCodeValue), id: 1)

    // Cmd + Shift + Space
    let keyCode = UInt32(kVK_ANSI_P) // Cmd + Shift + P
    let modifiers: UInt32 = UInt32(cmdKey | shiftKey)

    RegisterEventHotKey(keyCode, modifiers, hotKeyID, GetApplicationEventTarget(), 0, &hotKeyRef)
    print("Global hotkey registered.")

    InstallEventHandler(GetApplicationEventTarget(), { (_, eventRef, _) -> OSStatus in
        var hotKeyID = EventHotKeyID()
        GetEventParameter(eventRef, EventParamName(kEventParamDirectObject), EventParamType(typeEventHotKeyID), nil, MemoryLayout<EventHotKeyID>.size, nil, &hotKeyID)

        if hotKeyID.signature == OSType("CRTX".fourCharCodeValue) {
            OverlayWindowController.shared.toggle()
            print("Hotkey triggered.")
        }

        return noErr
    }, 1, [EventTypeSpec(eventClass: OSType(kEventClassKeyboard), eventKind: UInt32(kEventHotKeyPressed))], nil, nil)
}

extension String {
    var fourCharCodeValue: FourCharCode {
        return utf8.reduce(0) { ($0 << 8) + FourCharCode($1) }
    }
}
