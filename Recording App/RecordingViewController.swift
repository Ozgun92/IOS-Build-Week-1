
import UIKit
import Foundation
import AVFoundation
import CoreFoundation

class RecordingViewController: UIViewController, AVAudioPlayerDelegate, AVAudioRecorderDelegate {

    @IBOutlet weak var recordButton: UIButton!
    @IBAction func recordTapped(_ sender: Any) {
        recordTapped()
    }
    @IBOutlet weak var saveButtonO: UIButton!
    @IBAction func saveButtonA(_ sender: Any) {
    }
    @IBOutlet weak var deleteButtonO: UIButton!
    @IBAction func deleteButtonA(_ sender: Any) {
    }
    @IBOutlet weak var timerLabel: UILabel!
    
    
    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    var mic = UIImage(named: "mic")
    var micFill = UIImage(named: "mic.fill")
    
    override func viewDidLoad() {
        recordingSession = AVAudioSession.sharedInstance()
        
           do {
                try recordingSession.setCategory(.playAndRecord, mode: .default)
            
                try recordingSession.setActive(true)
               recordingSession.requestRecordPermission() { [unowned self] allowed in            DispatchQueue.main.async {
                       if allowed {
                           self.loadRecordingUI()
                       } else {
                           // failed to record!
                       }
                   }
               }
           } catch {
               // failed to record!
       }
   }
    
    @objc func loadRecordingUI() {
        
        recordButton.setImage(mic, for: .normal)
        recordButton.addTarget(self, action: #selector(RecordingViewController.loadRecordingUI), for: .touchUpInside)
        view.addSubview(recordButton)
        print("Ready")
    }
    
    func startRecording() {
       
        let audioFilename = getDocumentsDirectory().appendingPathComponent("recording.m4a")

        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]

        do {
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder.delegate = self
            audioRecorder.record()
            recordButton.setImage(micFill, for: .normal)
            print("Recording")
        } catch {
            finishRecording(success: false)
        }
    }
    
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    @objc func finishRecording(success: Bool) {
        print("stop")
        audioRecorder.stop()
        audioRecorder = nil

        if success {
            recordButton.setImage(mic, for: .normal)
            print("succes")
        } else {
            recordButton.setImage(mic, for: .normal)
            // recording failed :(
            print("failed")
        }
    }
    
    @objc func recordTapped() {
        print("recordTapped")
        if audioRecorder == nil {
            startRecording()
        } else {
        print("ende")
            finishRecording(success: true)
        }
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            finishRecording(success: false)
        }
    }
    
}
/*protocol AudioRecorder {

    func checkPermission(completion: ((Bool) -> Void)?)
    /// if url is nil audio will be stored to default url
    func record(to url: URL?)

    func stopRecording()
/// if url is nil audio will be played from default url
    func play(from url: URL?)

    func stopPlaying()

    func pause()

    func resume()
    }


final class AudioRecorderImpl: NSObject, AudioRecorder {
    
    @IBAction func recordBTN(_ sender: Any) {
        record(to: fileURL)
        
    }
    
    
    private let session = AVAudioSession.sharedInstance()
    private var player: AVAudioPlayer?
    private var recorder: AVAudioRecorder?
    private lazy var permissionGranted = false
    private lazy var isRecording = false
    private lazy var isPlaying = false
    private var fileURL: URL?
    private let settings = [
        AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
        AVSampleRateKey: 44100,
        AVNumberOfChannelsKey: 2,
        AVEncoderAudioQualityKey:AVAudioQuality.high.rawValue
      ]
   
    override init() {
        fileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("note.m4a")
      }
    
    func record(to url: URL?) {
        
        guard permissionGranted,
            let url = url ?? fileURL else { return }
        setupRecorder(url: url)
        if isRecording {
            stopRecording()
        }
        isRecording = true
        recorder?.record()
      }
   
    func stopRecording() {
        isRecording = false
        recorder?.stop()
    try? session.setActive(false)
      }
    
    func play(from url: URL?) {
        
        guard let url = url ?? fileURL else { return }
        setupPlayer(url: url)
        
        if isRecording {
            stopRecording()
        }
    
        if isPlaying {
            stopPlaying()
        }
        
        if FileManager.default.fileExists(atPath: url.path) {
            isPlaying = true
            setupPlayer(url: url)
            player?.play()
        }
      }
   
    func stopPlaying() {
        player?.stop()
      }
    
    func pause() {
        player?.pause()
      }
    func resume() {
    if player?.isPlaying == false {
          player?.play()
        }
      }
    
    func checkPermission(completion: ((Bool) -> Void)?) {
        func assignAndInvokeCallback(_ granted: Bool) {
            self.permissionGranted = granted
            completion?(granted)
            }
        switch session.recordPermission {
        case .granted:
            assignAndInvokeCallback(true)
        case .denied:
            assignAndInvokeCallback(false)
        case .undetermined:
            session.requestRecordPermission(assignAndInvokeCallback)
        }
      }
    }

    extension AudioRecorderImpl: AVAudioRecorderDelegate, AVAudioPlayerDelegate {
    }
    private extension AudioRecorderImpl {
    func setupRecorder(url: URL) {
    guard
          permissionGranted else { return }
    try? session.setCategory(.playback, mode: .default)
    try? session.setActive(true)
    let settings = [
          AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
          AVSampleRateKey: 44100,
          AVNumberOfChannelsKey: 2,
          AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        recorder = try? AVAudioRecorder(url: url, settings: settings)
        recorder?.delegate = self
        recorder?.isMeteringEnabled = true
        recorder?.prepareToRecord()
      }
    func setupPlayer(url: URL) {
        player = try? AVAudioPlayer(contentsOf: url)
        player?.delegate = self
        player?.prepareToPlay()
      }
    }

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
    
    @IBOutlet weak var recordButtonO: UIButton!
    @IBAction func recordButtonA(_ sender: Any) {
        record()
    }
    @IBOutlet weak var saveButtonO: UIButton!
    @IBAction func saveButtonA(_ sender: Any) {
    }
    @IBOutlet weak var deleteButtonO: UIButton!
    @IBAction func deleteButtonA(_ sender: Any) {
    }
    @IBOutlet weak var timerLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        check_record_permission()
    }

    func check_record_permission()
    {
        switch AVAudioSession.sharedInstance().recordPermission() {
        case AVAudioSessionRecordPermission.granted:
            isAudioRecordingGranted = true
            break
        case AVAudioSessionRecordPermission.denied:
            isAudioRecordingGranted = false
            break
        case AVAudioSessionRecordPermission.undetermined:
            AVAudioSession.sharedInstance().requestRecordPermission({ (allowed) in
                    if allowed {
                        self.isAudioRecordingGranted = true
                    } else {
                        self.isAudioRecordingGranted = false
                    }
            })
            break
        default:
            break
        }
    }

    func setup_recorder()
    {
        if isAudioRecordingGranted
        {
            let session = AVAudioSession.sharedInstance()
            do
            {
                try session.setCategory(.playAndRecord, mode: .default)
                try session.setActive(true)
                let settings = [
                    AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                    AVSampleRateKey: 44100,
                    AVNumberOfChannelsKey: 2,
                    AVEncoderAudioQualityKey:AVAudioQuality.high.rawValue
                ]
                audioRecorder = try AVAudioRecorder(url: getFileUrl(), settings: settings)
                audioRecorder.delegate = self
                audioRecorder.isMeteringEnabled = true
                audioRecorder.prepareToRecord()
            }
            catch let error {
                display_alert(msg_title: "Error", msg_desc: error.localizedDescription, action_title: "OK")
            }
        }
        else
        {
            display_alert(msg_title: "Error", msg_desc: "Don't have access to use your microphone.", action_title: "OK")
        }

}
    
   /* var audioRecorder = AVAudioRecorder()
    let audioSession: AVAudioSession = AVAudioSession.sharedInstance()
    let granted: Bool?
    
    func record() {
        //ask for permission
        if audioSession.responds(to: #selector(AVAudioSession.requestRecordPermission(_:))) {
                   AVAudioSession.sharedInstance().requestRecordPermission({(granted: Bool)-> Void in
                       if granted { print("granted")
                          
                           //set category and activate recorder session
                           try! self.audioSession.setCategory(AVAudioSession.Category.playAndRecord)
                           try! self.audioSession.setActive(true)
                           
                           //get documnets directory
                        
                           let fullPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0]
                           
                           let documentsDirectory: AnyObject = fullPath as AnyObject
                       

                           //create AnyObject of settings
                           let settings = [AVFormatIDKey : kAudioFormatAppleIMA4,
                               AVSampleRateKey : 44100.0,
                               AVNumberOfChannelsKey : 2,
                               AVEncoderBitRateKey : 320000,
                               AVLinearPCMBitDepthKey : 16,
                               AVEncoderAudioQualityKey : AVAudioQuality.max.rawValue] as [String : Any]

                        do {
                               try FileManager.default.createDirectory(atPath: fullPath, withIntermediateDirectories: false, attributes: nil)
                           } catch let error as NSError {
                               print(error.localizedDescription);
                           }

                       } else{
                           print("not granted")
                       }
                   } )
               }
    }
}
/*        var soundRecorder : AVAudioRecorder!
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
        
        func getFileURL() -> URL? {
            let path = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(fileName)
            
        //    let filePath = URLRequest(url: path)
            
            return path
        }
    }
*/
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    // override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    // }
*/
*/
