//
//  AudioPlayer.swift
//  Socivy
//
//  Created by Taha Doğan Güneş on 23/12/14.
//  Copyright (c) 2014 TDG. All rights reserved.
//

import Foundation
import AVFoundation

enum ChatSound:String {
    case NewMessage = "codeccall"
    case ConnectionEstablished = "codecopen"
}

class AudioPlayer {
    
    var player = AVAudioPlayer()
    
    func play(sound:ChatSound){
        
        var alertSound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource(sound.rawValue, ofType: "wav")!)!
//        println(alertSound)
        var error = NSErrorPointer()
        
        AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, error: nil)
        AVAudioSession.sharedInstance().setActive(true, error: nil)
        
        
        player = AVAudioPlayer(contentsOfURL: alertSound, error: error)
        println(error)
        player.prepareToPlay()
        
        player.play()
    }
    
}