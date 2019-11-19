//
//  RecordingViewController.swift
//  Recording App
//
//  Created by Ufuk Türközü on 18.11.19.
//  Copyright © 2019 Özgün Yildiz. All rights reserved.
//

import UIKit
import AVFoundation
import CoreFoundation

class RecordingViewController: UIViewController, AVAudioPlayerDelegate, AVAudioRecorderDelegate {
    
    var audioRecorder = AVAudioRecorder()

    @IBOutlet weak var recordButtonO: UIButton!
    @IBAction func recordButtonA(_ sender: Any) {
       
        let audioSession: AVAudioSession = AVAudioSession.sharedInstance()

        //ask for permission
        if audioSession.responds(to: #selector(AVAudioSession.requestRecordPermission(_:))) {
            AVAudioSession.sharedInstance().requestRecordPermission({(granted: Bool)-> Void in
                if granted {
                    print("granted")

                    //set category and activate recorder session
                    try! audioSession.setCategory(AVAudioSession.Category.playAndRecord)
                    try! audioSession.setActive(true)


                    //get documnets directory
                    let documentsDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
                    let fullPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
                    

                    //create AnyObject of settings
                    let settings = [AVFormatIDKey : kAudioFormatAppleIMA4,
                        AVSampleRateKey : 44100.0,
                        AVNumberOfChannelsKey : 2,
                        AVEncoderBitRateKey : 320000,
                        AVLinearPCMBitDepthKey : 16,
                        AVEncoderAudioQualityKey : AVAudioQuality.max.rawValue] as [String : Any]

                    //record
                    try self.audioRecorder = AVAudioRecorder(URL: fullPath, settings: settings)

                } else{
                    print("not granted")
                }
                } as! PermissionBlock as! PermissionBlock)
        }
    }
    @IBOutlet weak var saveButtonO: UIButton!
    @IBAction func saveButtonA(_ sender: Any) {
    }
    @IBOutlet weak var deleteButtonO: UIButton!
    @IBAction func deleteButtonA(_ sender: Any) {
    }
    @IBOutlet weak var timerLabel: UILabel!
    
/*    var soundRecorder : AVAudioRecorder!
        var SoundPlayer : AVAudioPlayer!
        
        var fileName = "audioFile.m4a"
        
        override func viewDidLoad() {
            super.viewDidLoad()
            // Do any additional setup after loading the view, typically from a nib.
            setupRecorder()
        }

        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }
        
        func setupRecorder(){
            
            
            let recordSettings = [AVFormatIDKey : kAudioFormatAppleLossless,
                AVEncoderAudioQualityKey : AVAudioQuality.max.rawValue,
                AVEncoderBitRateKey : 320000,
                AVNumberOfChannelsKey : 2,
                AVSampleRateKey : 44100.0 ] as [String : Any]
            
            let error : NSError?
            
            soundRecorder = try! AVAudioRecorder(url: getFileURL()! as URL, settings: recordSettings)
            
                soundRecorder.delegate = self
                soundRecorder.prepareToRecord()
            
            
        }
        
        func getCacheDirectory() -> String {
            
            let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
            
            return paths[0]
            
        }
        
        func getFileURL() -> NSURL? {
            let path = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(fileName)
            
            let filePath = NSURLRequest(url: path!)
            
            return path as NSURL?
        }
    }

 */
    func record() {
        //init
        

    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


}
