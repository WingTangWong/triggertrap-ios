//
//  ManualFocusViewController.swift
//  TriggertrapSLR
//
//  Created by Valentin Kalchev on 27/01/2015.
//  Copyright (c) 2015 Triggertrap Ltd. All rights reserved.
//

import UIKit

class ManualFocusViewController: OnboardingViewController {
    
    // Grey view
    
    @IBOutlet var separatorLine: UIView!
    @IBOutlet var greyViewInformationLabel: UILabel! // For transition
    @IBOutlet var greyViewPraiseLabel: UILabel! // For transition
    @IBOutlet var pageControl: UIPageControl!
    @IBOutlet var informationView: UIView!
    
    // White view
    
    @IBOutlet var plugView: UIView! // For transition
    @IBOutlet var plugImageView: UIImageView!
    @IBOutlet var phoneImageView: UIImageView! // For transition 
    @IBOutlet var dongleCableView: DongleCableView!
    @IBOutlet var dongleView: UIView!
    @IBOutlet var dongleBodyTopImageView: UIImageView!
    
    @IBOutlet var cameraCableView: DongleCableView!
    @IBOutlet var cameraView: UIImageView!
    @IBOutlet var cameraConnectorView: UIView!
    @IBOutlet var cameraConnectorBodyImageView: UIImageView!
    @IBOutlet var cameraConnectorPlugImageView: UIImageView!
    @IBOutlet var dongleCoilImageView: UIImageView!
    
    @IBOutlet var popoutShapeView: UIView!
    @IBOutlet var manualSwitch: UISwitch!
    
    @IBOutlet var dismissButton: UIButton!
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        updateDongleCableView()
        updateCameraCableView()
    } 
    
    func updateDongleCableView() {
        let plugCenter = dongleCableView.convertPoint(plugImageView.center, fromView: plugView)
        let dongleCenter = dongleCableView.convertPoint(dongleBodyTopImageView.center, fromView: dongleView)
        
        dongleCableView.point1 = CGPoint(x: plugCenter.x, y: plugCenter.y + plugImageView.frame.size.height / 2 + 2)
        dongleCableView.point2 = CGPoint(x: dongleCenter.x, y: dongleCenter.y - dongleBodyTopImageView.frame.size.height / 2 - 2)
        dongleCableView.bezierType = DongleCableView.BezierPathType.Dongle
        dongleCableView.addShapeLayer()
    }
    
    func updateCameraCableView() {
        
        let plugCenter = cameraCableView.convertPoint(cameraConnectorBodyImageView.center, fromView: cameraConnectorView)
        
        cameraCableView.point1 = CGPoint(x: plugCenter.x + 5, y: plugCenter.y + cameraConnectorBodyImageView.frame.size.height / 2 + 2)
        cameraCableView.point2 = CGPoint(x: dongleCoilImageView.frame.origin.x + 6, y: dongleCoilImageView.frame.origin.y + dongleCoilImageView.frame.size.height - 6)
        cameraCableView.bezierType = DongleCableView.BezierPathType.Camera
        cameraCableView.addShapeLayer()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // Half a seconds before the switch is turned on
        
        let delayTime = dispatch_time(DISPATCH_TIME_NOW,
            Int64(0.5 * Double(NSEC_PER_SEC)))
        
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            self.turnSwitchOn()
        }
    }
    
    private func turnSwitchOn() {
        manualSwitch.setOn(true, animated: true)
    }
}
