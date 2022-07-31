//
//  ViewController.swift
//  SPMediaController
//
//  Created by Salvatore Petrolo on 19/08/17.
//  Copyright © 2017 Salvatore Petrolo. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController, UITextFieldDelegate{
    
    let spCommandClientSender: SPCommandClientSender = SPCommandClientSender()
    let DEFAULT_IP_ADDRESS : String = "192.168.1.6"
    
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var nextTrackButton: UIButton!
    @IBOutlet weak var previousTrackButton: UIButton!
    @IBOutlet weak var shuffleButton: UIButton!
    @IBOutlet weak var repeaatButton: UIButton!
    @IBOutlet weak var volumeDownButton: UIButton!
    @IBOutlet weak var volumeUpButton: UIButton!
    @IBOutlet weak var ipAddressField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ipAddressField.delegate = self
        ipAddressField.text = DEFAULT_IP_ADDRESS
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if (string == "\n") {
            textField.resignFirstResponder()
            return false
        }
        return true
    }
    

    @IBAction func onPlayPauseButtonPressed(_ sender: Any) {
        sendString(str: "playpause")
    }
    
    @IBAction func onNextTrackButtonPressed(_ sender: Any) {
         sendString(str: "nexttrack")
    }
    
    @IBAction func onPreviousTrackButtonPressed(_ sender: Any) {
        sendString(str: "previoustrack")
    }
    
    @IBAction func onShuffleButtonPressed(_ sender: Any) {
        sendString(str: "shuffle")
    }
    
    @IBAction func onRepeatButtonPressed(_ sender: Any) {
        sendString(str: "repeat")
    }
    
    @IBAction func onVolumeDownButtonPressed(_ sender: Any) {
        sendString(str: "volumedown")
    }
    
    
    @IBAction func onVolumeUpButtonPressed(_ sender: Any) {
        sendString(str: "volumeup")
    }
    
    
    @IBAction func onStopServerButtonPressed(_ sender: Any) {
        sendString(str: "stop")
    }
    
    @IBAction func onCloseServerButtonPressed(_ sender: Any) {
        sendString(str: "close")
    }
    
    @IBAction func onUpButtonPressed(_ sender: Any) {
        sendString(str: "up")
    }
    
    
    @IBAction func onDownButtonPressed(_ sender: Any) {
        sendString(str: "down")
    }
    
    @IBAction func onPageUpButtonPressed(_ sender: Any) {
        sendString(str: "page_up")
    }
    
    @IBAction func onPageDownButtonPressed(_ sender: Any) {
        sendString(str: "page_down")
    }
    
    @IBAction func onCloseProgramButtonPressed(_ sender: Any) {
        sendString(str: "close_program")
    }
    
    private func sendString(str: String)
    {
        let ip : String = ipAddressField.text!
        if checkIpAddres(ip: ip)
        {
            spCommandClientSender.connect(host: ip, port: 2905)
            let writtenBytes: Int = spCommandClientSender.sendCommand(word:str)
            if(writtenBytes > 0)
            {
                print("Command Successfully Sent")
            }
            else
            {
                print("Error Sending Command")
            }
            spCommandClientSender.close()
            print("here")
            return
        }
        showInvalidIpAlert()
    }
    
    private func showInvalidIpAlert(){
        let alert = UIAlertController(title: "Warning", message: "Invalid Ip", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    private func checkIpAddres(ip: String) -> Bool
    {
        for c in ip.unicodeScalars{
            if c != "."{
                if CharacterSet.letters.contains(c){
                    return false
                }
            }
        }
        return true
    }

}

