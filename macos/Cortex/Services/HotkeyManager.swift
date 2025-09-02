//
//  HotkeyManager.swift
//  Cortex
//
//  Created by Hadi Ahmad on 7/31/25.
//

import Carbon.HIToolbox
import Cocoa
import OSLog

private let logger = Logger(subsystem: "com.yourcompany.Cortex", category: "Hotkey")
private var globalHotKeyRef: EventHotKeyRef?

@MainActor
func registerGlobalHotkey() {
    let hotKeyID = EventHotKeyID(signature: OSType("CRTX".fourCharCodeValue), id: 1)

    // Cmd + Shift + P
    let keyCode = UInt32(kVK_ANSI_P)
    let modifiers: UInt32 = UInt32(cmdKey | shiftKey)

    let status = RegisterEventHotKey(keyCode, modifiers, hotKeyID, GetApplicationEventTarget(), 0, &globalHotKeyRef)
    if status == noErr {
        logger.info("Global hotkey registered")
    } else {
        logger.error("Failed to register global hotkey: \(status)")
    }

    InstallEventHandler(GetApplicationEventTarget(), { (_, eventRef, _) -> OSStatus in
        var hotKeyID = EventHotKeyID()
        GetEventParameter(eventRef, EventParamName(kEventParamDirectObject), EventParamType(typeEventHotKeyID), nil, MemoryLayout<EventHotKeyID>.size, nil, &hotKeyID)

        if hotKeyID.signature == OSType("CRTX".fourCharCodeValue) {
            OverlayWindowController.shared.toggle()
            logger.info("Hotkey triggered")
        }

        return noErr
    }, 1, [EventTypeSpec(eventClass: OSType(kEventClassKeyboard), eventKind: UInt32(kEventHotKeyPressed))], nil, nil)
}

func unregisterGlobalHotkey() {
    if let hotKey = globalHotKeyRef {
        UnregisterEventHotKey(hotKey)
        logger.info("Global hotkey unregistered")
        globalHotKeyRef = nil
    }
}

extension String {
    var fourCharCodeValue: FourCharCode {
        return utf8.reduce(0) { ($0 << 8) + FourCharCode($1) }
    }
}
