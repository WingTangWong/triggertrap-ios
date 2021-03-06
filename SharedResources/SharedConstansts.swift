//
//  SharedConstansts.swift
//  Triggertrap
//
//  Created by Valentin Kalchev on 22/09/2015.
//  Copyright © 2015 Triggertrap Limited. All rights reserved.
//

import UIKit

let iPhone = UIDevice.currentDevice().userInterfaceIdiom == .Phone
let iPad = UIDevice.currentDevice().userInterfaceIdiom == .Pad
let Unspecified = UIDevice.currentDevice().userInterfaceIdiom == .Unspecified

// MARK: - Storyboard Identifiers

let constStoryboardIdentifierInspiration = "Inspiration"
let constStoryboardIdentifierCableSelector = "CableSelector"
let constStoryboardIdentifierOnboarding = "Onboarding"

// MARK: - NSUserDefaults

let constSplashScreenIdentifier = "SplashScreen"
let constMobileKitIdentifier = "MobileKit"
let constUserDefaultsUserHasSeenTutorial = "UserHasSeenTutorial"
let constUserDefaultsScreenDimming = "ScreenDimming"
let constUserDefaultsscreenDimmingCurrentState = "screenDimmingCurrentState"
let constUserDefaultsBatteryThreshold = "BatteryThreshold"
let constUserDefaultsBatteryThresholdEnabled = "BatteryThresholdEnabled"
let constUserDefaultsWearablesEnabled = "WearablesEnabled"

// MARK: - Mixpanel

let constUserAcquired = "User Acquired"
let constUserActivated = "User Activated"

let constMixpanelDevelopmentToken = "MixpanelDevelopmentToken"
let constMixpanelProductionToken = "MixpanelProductionToken"
let constAnalyticsEventSessionCompleted = "Session Completed"
let constAnalyticsPropertySessionDuration = "Session Duration"
let constAnalyticsPropertyLanguage = "Language"
let constPhotoTaken = "Photo Taken"

// MARK: - Wearable

let constPebbleAppId = "PebbleAppId"
let constPebbleIsSelected = "PebbleIsSelected"
let constWatchDidTrigger = "WatchDidTrigger"
let constPebbleWatchStatusChanged = "PebbleWatchStatusChanged"

// MARK: - Timelapse Pro

let constTellMeMoreLink = "http://triggertrap.com/products/apps/triggertrap-timelapse-pro/"
let constViewInAppStoreLink = "https://itunes.apple.com/app/id946115908?mt=8"