//
//  AppDelegate.swift
//  PomodoroSwift
//
//  Created by Milan Dobrota on 8/17/14.
//  Copyright (c) 2014 Milan Dobrota. All rights reserved.
//

import Cocoa
import AVFoundation

class AppDelegate: NSObject, NSApplicationDelegate {
    
    let pomodoroInterval = 25 * 60
    let timeTitle = "25:00"
    
    @IBOutlet var statusMenu: NSMenu?
    var statusBar = NSStatusBar.systemStatusBar()
    var statusBarItem: NSStatusItem = NSStatusBar.systemStatusBar().statusItemWithLength(-1)
    var resetItem: NSStatusItem = NSStatusBar.systemStatusBar().statusItemWithLength(-1)
    
    var startTime = NSTimeInterval()
    var timer = NSTimer()
    
    let ring = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("ring", ofType: "wav")!)
    var ringPlayer: AVAudioPlayer?
    
    
    var running = false
    var firstPlay = true

    func applicationDidFinishLaunching(aNotification: NSNotification?) {
        // Insert code here to initialize your application
    }

    func applicationWillTerminate(aNotification: NSNotification?) {
        // Insert code here to tear down your application
    }

    
    override func awakeFromNib() {
        statusBarItem.menu = statusMenu
        statusBarItem.title = timeTitle
        statusBarItem.highlightMode = true
        
        statusBarItem.target = self
        statusBarItem.action = "playPause"
        
        resetItem.menu = statusMenu
        resetItem.title = "Reset"
        resetItem.highlightMode = true
        
        resetItem.target = self
        resetItem.action = "reset"
        
        var ringError : NSError?
        ringPlayer = AVAudioPlayer(contentsOfURL: ring, error: &ringError)
        ringPlayer?.prepareToPlay()

        


        
    }
    

    
    func playPause() {
        if !running {
            running = true
            if firstPlay {
                startTime = NSDate.timeIntervalSinceReferenceDate()
                firstPlay = false
            }
    
            statusBarItem.title = timeTitle
        
            updateTime() // first time I run it manually so it doesn't skip a second
            timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "updateTime", userInfo: nil, repeats: true)
            
        } else {
            reset()
            
        }
    }
    

    
    func updateTime() {
        var currentTime = NSDate.timeIntervalSinceReferenceDate()
        var elapsedTime: NSTimeInterval = currentTime - startTime
        var timeToDisplay = (NSTimeInterval)(pomodoroInterval) - elapsedTime // counting down
        if(timeToDisplay <= 0.0){
            reset()
        } else {
            var minutes = (UInt8)(timeToDisplay / 60.0)
            var seconds = (UInt8)(timeToDisplay - (NSTimeInterval(minutes) * 60))
    
            var strMinutes = minutes > 9 ? String(minutes) : "0" + String(minutes)
            var strSeconds = seconds > 9 ? String(seconds) : "0" + String(seconds)
        
            statusBarItem.title = "\(strMinutes):\(strSeconds)"

        }
    }
    func reset() {
        running = false
        timer.invalidate()
        startTime = NSTimeInterval()
        statusBarItem.title = timeTitle
        firstPlay = true
        
    }

}

