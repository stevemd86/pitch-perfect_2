//
//  RecordSoundsViewController.swift
//  pitchperfectfinal
//
//  Created by Steven David on 3/25/15.
//  Copyright (c) 2015 Steven David. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var recordingInProgress: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    
    @IBOutlet weak var tapToRecord: UILabel!

    var audioRecorder:AVAudioRecorder!
    var recordedAudio:RecordedAudio!
    
          // Do any additional setup after loading the view, typically from a nib.
    

    override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        stopButton.hidden = true
        recordButton.enabled = true
    }
    
    
    

    @IBAction func recordAudio(sender: UIButton) {
        
        tapToRecord.hidden = true
        stopButton.hidden = false
        recordingInProgress.hidden = false
        recordButton.enabled = false
        println("in recordAudio")
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
        
        let currentDateTime = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        let recordingName = formatter.stringFromDate(currentDateTime)+".wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        println(filePath)
        
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        
        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
        
        
    }
    
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        if(flag){
        
        recordedAudio = RecordedAudio(filePathUrl: recorder.url, title: recorder.url.lastPathComponent! )
  
            
        self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
            
        }else{
            println("Recording was not successfull")
            recordButton.enabled = true
            stopButton.hidden = true
            
        }
        
    }
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "stopRecording") {
            let PlaySoundsVC: PlaySoundsViewController = segue.destinationViewController as!
                PlaySoundsViewController
            let data = sender as! RecordedAudio
            PlaySoundsVC.receivedAudio = data
            
        }
    }
    

    @IBAction func stopAudio(sender: UIButton) {
        recordingInProgress.hidden = true
        audioRecorder.stop()
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)
    
    
    
    
    
    

        
    }

}

