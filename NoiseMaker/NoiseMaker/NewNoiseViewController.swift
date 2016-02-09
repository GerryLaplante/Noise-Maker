//
//  NewNoiseViewController.swift
//  NoiseMaker
//
//  Created by Gerry Laplante on 10/13/15.
//  Copyright © 2015 Gerry Laplante. All rights reserved.
//

import UIKit
import AVFoundation
import CoreData

class NewNoiseViewController: UIViewController {
    
    required init(coder aDecoder: NSCoder){
        let baseString : String = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0] 
        self.audioUrl = NSUUID().UUIDString + ".m4a"
        let pathComponents = [baseString, self.audioUrl]
        
        let audioNSURL = NSURL.fileURLWithPathComponents(pathComponents)!
        
        let session = AVAudioSession.sharedInstance()
        
        do {
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord)
           } catch{}
        
        let recordSettings = [
            
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            
            AVSampleRateKey: 44100.0,
            
            AVNumberOfChannelsKey: 2 as NSNumber,
            
            AVEncoderAudioQualityKey: AVAudioQuality.High.rawValue
            
        ]
        
        do {
            self.noiseRecorder = try AVAudioRecorder(URL: audioNSURL, settings: recordSettings)
           } catch{}
        
        self.noiseRecorder.meteringEnabled = true
        
        self.noiseRecorder.prepareToRecord()
        // Super init is below
        super.init(coder: aDecoder)!
    }
    
    @IBOutlet weak var noiseTextField: UITextField!
    @IBOutlet weak var recordButton: UIButton!
    
    var noiseRecorder: AVAudioRecorder!
    var audioUrl: String
    var previousNoiseListViewController = NoiseListViewController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //begin code
    }
    
    
    @IBAction func cancelTapped(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func saveTapped(sender: AnyObject) {
        
        // Create sound object
        let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        let newNoise = NSEntityDescription.insertNewObjectForEntityForName("Noise", inManagedObjectContext: context) as! Noise
        newNoise.name = noiseTextField.text!
        newNoise.url = self.audioUrl
        
        // Save Sound to Core Data
        do {
            try context.save()
        }catch{}
        
        // Dismiss this NewViewController
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func recordTapped(sender: AnyObject) {
        if self.noiseRecorder.recording {
            self.noiseRecorder.stop()
            self.recordButton.setTitle("RECORD", forState: UIControlState.Normal)
        } else {
            let session = AVAudioSession.sharedInstance()
            do {
                try session.setActive(true)
               } catch{}
            self.noiseRecorder.record()
            self.recordButton.setTitle("Finish Recording", forState: UIControlState.Normal)
        }
        
    }
    
    
}
