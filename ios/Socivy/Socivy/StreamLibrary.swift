//
//  StreamLibrary.swift
//  Socivy
//
//  Created by Taha Doğan Güneş on 22/12/14.
//  Copyright (c) 2014 TDG. All rights reserved.
//

import Foundation

class Communicator: LowLevelStreamDelegate  {
    let port:UInt32 = 1234
    let address:CFString = "127.0.0.1"
    var lowLevelSteam: LowLevelStream
    
    // connection handlers
    var onRecieve:(string:String)->()
    var onInterrupt:()->()
    
    init(onRecieve:(string:String)->(),onInterrupt:()->()){
        self.lowLevelSteam = LowLevelStream(address: self.address,port: self.port)

        self.onInterrupt = onInterrupt
        self.onRecieve = onRecieve
    }
    
    func startConnection(){
        self.lowLevelSteam.delegate = self

        self.lowLevelSteam.startConnection()

    }
    
    func send(message:String){
        self.lowLevelSteam.write(message)

    }
    
    func connectionInterrupted(){
        Logger.sharedInstance.log(self, message: "connection interrupted")
        self.onInterrupt()
    }
    func connectionReceive(string:String){
        Logger.sharedInstance.log(self, message: "received: \(string)")
        self.onRecieve(string: string)
    }
}

protocol LowLevelStreamDelegate {
    func connectionInterrupted()
    func connectionReceive(string:String)
}

class LowLevelStream: NSObject, NSStreamDelegate, Printable{
    
    var inputStream: NSInputStream
    var outputStream: NSOutputStream
    var delegate: LowLevelStreamDelegate?
    
    let bufferSize = 1024
    override var description: String {
        return "lls"
    }
    
    init(address:CFString, port:UInt32){
        var readStream:  Unmanaged<CFReadStream>?
        var writeStream: Unmanaged<CFWriteStream>?
        
        CFStreamCreatePairWithSocketToHost(nil, address, port, &readStream, &writeStream)
        
        self.inputStream = readStream!.takeRetainedValue()
        self.outputStream = writeStream!.takeRetainedValue()
        
    }
    
    func startConnection(){
        self.inputStream.delegate = self
        self.outputStream.delegate = self


        self.inputStream.scheduleInRunLoop(NSRunLoop.currentRunLoop(), forMode: NSDefaultRunLoopMode)
        self.outputStream.scheduleInRunLoop(NSRunLoop.currentRunLoop(), forMode: NSDefaultRunLoopMode)
        
        self.inputStream.open()
        self.outputStream.open()

        
    }
    
    func write(text:String){
        Logger.sharedInstance.log(self, message:"writing to stream: \(text)")
        var data:NSData = NSData(data: text.dataUsingEncoding(NSASCIIStringEncoding, allowLossyConversion: false)!)

        self.outputStream.write(UnsafePointer(data.bytes), maxLength: data.length)
    }
    
    func stream(theStream: NSStream, handleEvent streamEvent: NSStreamEvent) {
        
        Logger.sharedInstance.log(self, message:"Event code received: \(streamEvent.rawValue)")
        
        switch (streamEvent){
        case NSStreamEvent.OpenCompleted:
            Logger.sharedInstance.log(self, message:"Stream opened")
            break
            
        case NSStreamEvent.HasBytesAvailable:
            if  theStream == self.inputStream {
                var buffer = Array<UInt8>(count: self.bufferSize, repeatedValue: 0)

                var length = 0;
                
                while self.inputStream.hasBytesAvailable {
                    length = self.inputStream.read(&buffer, maxLength: self.bufferSize)
                    
                    if length > 0{
                        var output = NSString(bytes: &buffer, length: length, encoding: NSASCIIStringEncoding)
                        
                        if output != nil {
                            Logger.sharedInstance.log(self, message:output!)
                            self.delegate?.connectionReceive(output!)
                            
                        }
                        
                    }

                }
            }
            break
            
        case NSStreamEvent.ErrorOccurred:
            Logger.sharedInstance.log(self, message: "ErrorOccured")
            self.delegate?.connectionInterrupted()
            break
            
        case NSStreamEvent.EndEncountered:
            Logger.sharedInstance.log(self, message: "Stream end encountered")
            
     
                theStream.close()
                theStream.removeFromRunLoop(NSRunLoop.currentRunLoop(), forMode: NSDefaultRunLoopMode)
                
            
                self.delegate?.connectionInterrupted()

            break
            
        case NSStreamEvent.HasSpaceAvailable:
            Logger.sharedInstance.log(self, message: "Has space event")
            break
        default:
            Logger.sharedInstance.log(self, message: "Unknown event")
            self.delegate?.connectionInterrupted()
        }
        
    }
}
