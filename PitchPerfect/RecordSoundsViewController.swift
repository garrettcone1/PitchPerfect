//
//  ViewController.swift
//  PitchPerfect
//
//  Created by Garrett Cone on 11/6/16.
//  Copyright © 2016 Garrett Cone. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopRecordingButton: UIButton!
    
    var audioRecorder: AVAudioRecorder!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        stopRecordingButton.isEnabled = false
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // The function below is to have better Code Quality and not have so many repetitive lines of code of the same thing
    func setUIState(stopRecordButton: Bool, recordingButton: Bool, recordingText: String) {
        
        
        stopRecordingButton.isEnabled = stopRecordButton
        recordButton.isEnabled = recordingButton
        recordingLabel.text = recordingText
    }
    
    
    @IBAction func recordAudio(_ sender: Any) {
        print("Record Button pressed")
        /* Previous Code
        //recordingLabel.text = "Recording in progress"
        //stopRecordingButton.isEnabled = true
        //recordButton.isEnabled = false
            Shortened Version Below
        */
        setUIState(stopRecordButton: true, recordingButton: false, recordingText: "Recording in progress")
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURL(withPathComponents: pathArray)
        print(filePath!)
        
        let session = AVAudioSession.sharedInstance()
        do {
            try! session.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try! session.overrideOutputAudioPort(AVAudioSessionPortOverride.speaker)
        }
        
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }

    @IBAction func stopRecording(_ sender: Any) {
        print("Stop recording button pressed")
        /* Previous Code
         //recordingLabel.text = "Tap to Record"
         //stopRecordingButton.isEnabled = false
         //recordButton.isEnabled = true
         Shortened Version Below
         */
        
        setUIState(stopRecordButton: false, recordingButton: true, recordingText: "Tap to Record")
        
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("viewWillAppear called")
        
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        print("AVAudioRecorder finished saving recording")
        if (flag) {
            self.performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        } else {
            print("Saving of recording failed")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "stopRecording") {
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender as! NSURL
            playSoundsVC.recordedAudio = recordedAudioURL
        }
    }
}





