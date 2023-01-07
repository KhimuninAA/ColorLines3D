//
//  AppDelegate.swift
//  MacOS-ColorLines
//
//  Created by Алексей Химунин on 05.01.2023.
//

import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate, NSWindowDelegate {

    @IBOutlet var window: NSWindow!
    var rootView: RootView?

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        rootView = RootView()
        window.contentView = rootView
        window.delegate = self
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }

    func windowShouldClose(_ sender: NSWindow) -> Bool{
        sender.orderOut(self)
        return false
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool{
        return true
    }
}

