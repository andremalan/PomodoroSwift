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
    
    @IBOutlet var statusMenu: NSMenu?
    var statusBar = NSStatusBar.systemStatusBar()
    var statusBarItem: NSStatusItem = NSStatusBar.systemStatusBar().statusItemWithLength(-1)
    
    var startTime = NSTimeInterval()
    var timer = NSTimer()
    
    let ring = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("ring", ofType: "wav"))
    var ringPlayer: AVAudioPlayer?
    
    let tick = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("tick", ofType: "wav"))
    var tickPlayer: AVAudioPlayer?
    
    var running = false
    

    func applicationDidFinishLaunching(aNotification: NSNotification?) {
        // Insert code here to initialize your application
    }

    func applicationWillTerminate(aNotification: NSNotification?) {
        // Insert code here to tear down your application
    }

    
    override func awakeFromNib() {
        statusBarItem.menu = statusMenu
        statusBarItem.title = "25:00"
        statusBarItem.highlightMode = true
        
        statusBarItem.target = self
        statusBarItem.action = "startCountdown"
        
        var ringError : NSError?
        ringPlayer = AVAudioPlayer(contentsOfURL: ring, error: &ringError)
        ringPlayer?.prepareToPlay()

        
        var tickError : NSError?
        tickPlayer = AVAudioPlayer(contentsOfURL: tick, error: &tickError)
        tickPlayer?.prepareToPlay()

        
    }
    
    func startCountdown() {
        if !running {
            running = true
            startTime = NSDate.timeIntervalSinceReferenceDate();
            statusBarItem.title = "25:00"
        
            updateTime() // first time I run it manually so it doesn't skip a second
            timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "updateTime", userInfo: nil, repeats: true)
        }
    }
    
    func updateTime() {
        var currentTime = NSDate.timeIntervalSinceReferenceDate()
        var elapsedTime: NSTimeInterval = currentTime - startTime
        var timeToDisplay = (NSTimeInterval)(pomodoroInterval) - elapsedTime // counting down

        var minutes = (UInt8)(timeToDisplay / 60.0)
        var seconds = (UInt8)(timeToDisplay - (NSTimeInterval(minutes) * 60))
        
        if minutes <= 0 && seconds <= 0 {
            running = false
            timer.invalidate();
            
            ringPlayer?.play()
            
            statusBarItem.title = "25:00"
        } else {
    
            var strMinutes = minutes > 9 ? String(minutes) : "0" + String(minutes)
            var strSeconds = seconds > 9 ? String(seconds) : "0" + String(seconds)
        
            statusBarItem.title = "\(strMinutes):\(strSeconds)"
            
            tickPlayer?.play()

        }
    }
    

}

