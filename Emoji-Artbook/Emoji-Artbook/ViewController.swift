//
//  ViewController.swift
//  Emoji-Artbook
//
//  Created by Monte's Pro 13" on 4/11/16.
//  Copyright © 2016 MonteThakkar. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var trayView: UIView!
    
    var trayOriginalCenter: CGPoint!
    var trayCenterWhenOpen: CGPoint!
    var trayCenterWhenClosed: CGPoint!
    
    var newlyCreatedFace: UIImageView!
    var faceOriginalCenter: CGPoint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        trayCenterWhenOpen = trayView.center
        trayCenterWhenClosed = CGPoint(x: 160, y: 660)
    }
    
    @IBAction func onTrayPanGesture(panGestureRecognizer: UIPanGestureRecognizer) {
        let velocityY = panGestureRecognizer.velocityInView(trayView).y
        let xPoints = CGFloat(floatLiteral: 320.0)
        let duration: NSTimeInterval = (Double) (xPoints/velocityY)
        
        if panGestureRecognizer.state == UIGestureRecognizerState.Began {
            trayOriginalCenter = trayView.center
        } else if panGestureRecognizer.state == UIGestureRecognizerState.Changed && velocityY > 0 {
            UIView.animateWithDuration(duration, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 7.0, options: UIViewAnimationOptions.CurveLinear , animations: {
                self.trayView.center = self.trayCenterWhenClosed
                }, completion: nil)
        } else if panGestureRecognizer.state == UIGestureRecognizerState.Changed && velocityY < 0 {
            UIView.animateWithDuration(duration, animations: {
                self.trayView.center = self.trayCenterWhenOpen
            })
        }
    }
    
    @IBAction func onTrayTapGesture(tapGestureRecognizer: UITapGestureRecognizer) {
        if trayView.center == trayCenterWhenOpen {
            UIView.animateWithDuration(2.0, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 7.0, options: UIViewAnimationOptions.CurveLinear , animations: {
                self.trayView.center = self.trayCenterWhenClosed
                }, completion: nil)
            print("Closing tray")
        } else {
            UIView.animateWithDuration(0.4, animations: {
                self.trayView.center = self.trayCenterWhenOpen
            })
            print("Opening tray")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

