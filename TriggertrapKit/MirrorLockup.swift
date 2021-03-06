//
//  MirrorLockup.swift
//  Triggertrap
//
//  Created by Valentin Kalchev on 02/07/2015.
//  Copyright (c) 2015 Triggertrap Limited. All rights reserved.
//

/**
Unwrappable module, combination of specific pattern of modules:
Pulse -> Delay
*/
public struct MirrorLockup: Unwrappable {
    
    public let name = "Mirror Lockup"
    public let type: UnwrappableType = .MirrorLockup
    
    public var modules: [Modular]
    public var currentModule: Int
    public var completionHandler: CompletionHandler = { (success) -> Void in }
    
    private let pulse: Pulse
    private let delay: Delay
    
    /**
    - parameter pulse: module during which the audio buffer stays active
    - parameter delay: module during which the audio buffer is inactive
    */
    public init(pulse: Pulse, delay: Delay) {
        self.pulse = pulse
        self.delay = delay
        self.modules = [self.pulse, self.delay]
        self.currentModule = 0
    } 
}

