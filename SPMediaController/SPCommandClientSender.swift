//
//  ViewController.swift
//  SPMediaController
//
//  Created by Salvatore Petrolo on 19/08/17.
//  Copyright © 2017 Salvatore Petrolo. All rights reserved.
//

import Foundation

class SPCommandClientSender: NSObject, StreamDelegate {
    
    private var host:String?
    
    private var port:Int?
    
    private var inputStream: InputStream?
    
    private var outputStream: OutputStream?
    
    private var dataReadCallback:((_ dataReceived:String)->Void)?
    
    
    func connect(host: String, port: Int) {
        
        self.host = host
        self.port = port
        
        
        Stream.getStreamsToHost(withName: host, port: port, inputStream: &self.inputStream, outputStream: &self.outputStream)
        
        
        if self.inputStream != nil && self.outputStream != nil {
           
            self.inputStream!.delegate = self
            self.outputStream!.delegate = self
            
            self.inputStream!.schedule(in: .main, forMode: RunLoopMode.defaultRunLoopMode)
            self.outputStream!.schedule(in: .main, forMode: RunLoopMode.defaultRunLoopMode)
            
            self.inputStream!.open()
            self.outputStream!.open()
        }
        
    }
    
    
    func stream(aStream: Stream, handleEvent eventCode: Stream.Event) {
        
        if aStream != inputStream {
            return
        }
        
        if eventCode == .hasBytesAvailable {
            self.read()
        }
    }
    
    
    private func read() -> String {
        var buffer = [UInt8](repeating: 0, count: 1024)
        var output: String = ""
        while (self.inputStream!.hasBytesAvailable){
            let bytesRead: Int = inputStream!.read(&buffer, maxLength: buffer.count)
            if bytesRead >= 0 {
                output += NSString(bytes: UnsafePointer(buffer), length: bytesRead, encoding: String.Encoding.utf8.rawValue)! as String
            }
        }
        self.dataReadCallback!(output)
        return output
    }
    
    func sendCommand(word:String) -> Int{
        if self.outputStream == nil {
            NSException(name: NSExceptionName(rawValue: "Not connected to the server"), reason: "Make sure to connect first", userInfo: nil).raise()
        }
        
        
        let data:NSData = word.data(using: String.Encoding.utf8, allowLossyConversion: false)! as NSData
        
        let bytesWritten:Int = self.outputStream!.write(UnsafePointer<UInt8>(data.bytes.assumingMemoryBound(to: UInt8.self)), maxLength: data.length)
        return bytesWritten
    }
    
    
    func onDataReceived(dataReadCallback:@escaping ((_ dataReceived:String) -> Void)) {
        self.dataReadCallback = dataReadCallback
    }
    

    func close() -> Bool {
        
        if ( self.inputStream == nil) || (self.outputStream == nil) {return false }
        
        self.inputStream?.remove(from: .main, forMode: RunLoopMode.defaultRunLoopMode)
        self.outputStream?.remove(from: .main, forMode: RunLoopMode.defaultRunLoopMode)
        
        inputStream?.close()
        outputStream?.close()
        
        inputStream = nil
        outputStream = nil
        
        return true
    }
}
