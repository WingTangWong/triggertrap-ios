//
//  SoundSensorViewController.swift
//  TriggertrapSLR
//
//  Created by Ross Gibson on 19/08/2014.
//  Copyright (c) 2014 Triggertrap Ltd. All rights reserved.
//

import UIKit

class SoundSensorViewController: SensorViewController {
    
    // MARK: - Outlets
    
    @IBOutlet var circularSlider: TTCircularSlider!
    @IBOutlet var circularSoundLevel: TTCircularSlider!
    @IBOutlet var nameLabel: UILabel!
    
    // MARK: - Properties
    
    private var sensitivityValue: Float = 0.0
    private var audioListener: AudioListener!
    private var isTriggering = false
    private var shouldPopNameLabel = false
    
    // MARK: - Lifecycle 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        // Empty 'previousSoundThreshold' will mean a value of 0 which will set the circularSlider to its default value
        // if user is able to set the value to 0, then next time they re-open the app, the circularSlider will have its default value (0.6), not 0
        circularSlider.minimumValue = 0.001
        circularSlider.maximumValue = 1.0
        
        circularSoundLevel.minimumValue = 0.0
        circularSoundLevel.maximumValue = 1.0
        circularSoundLevel.lineWidth = 12.0
        circularSoundLevel.thumbImage = nil
        circularSoundLevel.userInteractionEnabled = false
        
        OutputDispatcher.sharedInstance.audioPlayer.start()
        audioListener = AudioListener()
        
        let previousSoundThreshold: Float? = NSUserDefaults.standardUserDefaults().floatForKey("lastUsedSoundThreshold")
        
        if previousSoundThreshold != 0.0 {
            sensitivityValue = NSUserDefaults.standardUserDefaults().floatForKey("lastUsedSoundThreshold")
            circularSlider.value = sensitivityValue
            print("\(sensitivityValue)")
        } else {
            sensitivityValue = 0.6
            circularSlider.value = sensitivityValue
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        audioListener.delegate = self
        audioListener.startSession()
        
        circularSlider.delegate = self
        WearablesManager.sharedInstance.delegate = self
    }
    
    override func willMoveToParentViewController(parent: UIViewController?) {
        super.willMoveToParentViewController(parent)
        WearablesManager.sharedInstance.delegate = nil
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Remove the audio listener if this mode is not active
        guard let activeViewController = sequenceManager.activeViewController where activeViewController is SoundSensorViewController else {
            
            // Check the audio listener has not been deallocated
            if let _ = self.audioListener {
                audioListener.delegate = nil
                audioListener.endSession()
            }
            circularSlider.delegate = nil
            return
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        circularSlider.setNeedsDisplay()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Actions
    
    @IBAction func shutterButtonTouchUpInside(sender : UIButton) {
        
        if sequenceManager.activeViewController == nil {
            
            if sufficientVolumeToTrigger() {
                
                if audioListener.recordPermissionGranted() {
                    
                    sequenceManager.activeViewController = self
                    
                    waitingForSensorResetDelay = false
                    startShutterButtonAnimation()
                    isTriggering = true
                    
                    prepareForSequence()

                } else {
                    showPermissionDeniedAlert()
                }
            }
            
        } else {
            isTriggering = false
            sequenceManager.cancel() 
            popNameLabelText(false)
        }
    }
    
    // MARK: - Overrides
    
    override func willDispatch(dispatchable: Dispatchable) {
        super.willDispatch(dispatchable)
        popNameLabelText(true)
    }
    
    override func didDispatch(dispatchable: Dispatchable) {
        super.didDispatch(dispatchable)
        popNameLabelText(false)
    }
    
    private func popNameLabelText(popLabel: Bool) {
        if popLabel {
            shouldPopNameLabel = true
            pop(nameLabel, fromScale: 1.0, toScale: 2.6)
            nameLabel.textColor = UIColor.triggertrap_primaryColor(1.0)
        } else {
            if shouldPopNameLabel == true {
                shouldPopNameLabel = false
                pop(nameLabel, fromScale: 2.6, toScale: 1.0)
                nameLabel.textColor = UIColor.triggertrap_foregroundColor(1.0)
            }
        }
    }
    
    // MARK: - Private
    
    private func showPermissionDeniedAlert() {
        
        // Show alert that microphone permission is not set or disabled
        ShowAlertInViewController(self, title: NSLocalizedString("I can't hear you", comment: "I can't hear you"), message: NSLocalizedString("I can't hear you .. Is microphone permission disabled, perhaps?", comment: "I can't hear you .. Is microphone permission disabled, perhaps?"), cancelButton: NSLocalizedString("OK", comment: "OK")) 
    }
    
    // MARK: - Theme
    
    override func performThemeUpdate() {
        super.performThemeUpdate()
        
        circularSlider.minimumTrackTintColor = UIColor.triggertrap_primaryColor()
        circularSlider.maximumTrackTintColor = UIColor.triggertrap_naturalColor()
        
        switch AppTheme() {
        case .Normal:
            circularSlider.thumbImage = "slider-thumb"
            break
        case .Night:
            circularSlider.thumbImage = "slider-thumb_night"
            break
        }
        
        circularSoundLevel.minimumTrackTintColor = UIColor.triggertrap_primaryColor()
        circularSoundLevel.maximumTrackTintColor = UIColor.triggertrap_naturalColor()
        
        nameLabel.textColor = UIColor.triggertrap_foregroundColor()
    }
}

extension SoundSensorViewController: AudioListenerDelegate {
    
    // MARK: - Audio Listener Delegate
    
    func audioLevelsUpdated(listner: AudioListener!, averageLevel: Float, peakLevel: Float) {

        self.circularSoundLevel.value = peakLevel
        
        if self.isTriggering && peakLevel > self.sensitivityValue {
            self.triggerNow()
        }
    }
}

extension SoundSensorViewController: CicularSliderDelegate {
    
    // MARK: - Cicular Slider Delegate
    
    func circularSliderValueChanged(newValue: NSNumber!) {
        sensitivityValue = newValue.floatValue
        
        NSUserDefaults.standardUserDefaults().setFloat(sensitivityValue, forKey: "lastUsedSoundThreshold")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
}

extension SoundSensorViewController: WearableManagerDelegate {
    func watchDidTrigger() {
        self.shutterButtonTouchUpInside(UIButton())
    }
}