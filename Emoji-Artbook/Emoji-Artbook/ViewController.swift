//
//  ViewController.swift
//  Emoji-Artbook
//
//  Created by Monte's Pro 13" on 4/11/16.
//  Copyright © 2016 MonteThakkar. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet weak var trayView: UIView!
    
    var trayOriginalCenter: CGPoint!
    var trayCenterWhenOpen: CGPoint!
    var trayCenterWhenClosed: CGPoint!
    
    var newlyCreatedFace: UIImageView!
    var faceOriginalCenter: CGPoint!
    var newlyCreatedFaceOriginalCenter: CGPoint!
    
    var faceScale: CGFloat! = CGFloat(1.0)
    
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
    
    @IBAction func onSmileyPanGesture(panGestureRecognizer: UIPanGestureRecognizer) {
        let translation = panGestureRecognizer.translationInView(newlyCreatedFace)

        if panGestureRecognizer.state == UIGestureRecognizerState.Began {
            let imageView = panGestureRecognizer.view as! UIImageView
            newlyCreatedFace = UIImageView(image: imageView.image)
            newlyCreatedFace.frame = CGRectMake(0, 0, 60, 60)
            view.addSubview(newlyCreatedFace)
            newlyCreatedFace.center = imageView.center
            newlyCreatedFace.center.y += trayView.frame.origin.y
            faceOriginalCenter = newlyCreatedFace.center
            
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.newlyCreatedFace.transform = CGAffineTransformMakeScale(self.faceScale, self.faceScale)
            })
            
            print("New smiley created")
        } else if panGestureRecognizer.state == UIGestureRecognizerState.Changed {
            newlyCreatedFace.center = CGPoint(x: faceOriginalCenter.x + translation.x, y: faceOriginalCenter.y + translation.y - 90)
        } else if panGestureRecognizer.state == UIGestureRecognizerState.Ended {
            print("panning ended")
            
            self.newlyCreatedFace.userInteractionEnabled = true
            var newPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: "onCustomPan:")
            var pinchGestureRecognizer = UIPinchGestureRecognizer(target: self, action: "onCustomPinch:")
            var rotateGestureRecognizer = UIRotationGestureRecognizer(target: self, action: "onCustomRotate:")
            
            self.newlyCreatedFace.addGestureRecognizer(newPanGestureRecognizer)
            pinchGestureRecognizer.delegate = self
            self.newlyCreatedFace.addGestureRecognizer(pinchGestureRecognizer)
            self.newlyCreatedFace.addGestureRecognizer(rotateGestureRecognizer)
            
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.newlyCreatedFace.transform = CGAffineTransformMakeScale(self.faceScale, self.faceScale)
            })
        }
    }
    
    func onCustomPan(panGestureRecognizer: UIPanGestureRecognizer) {
        
        // Absolute (x,y) coordinates in parent view
        var point = panGestureRecognizer.locationInView(view)
        
        // Relative change in (x,y) coordinates from where gesture began.
        var translation = panGestureRecognizer.translationInView(view)
        var velocity = panGestureRecognizer.velocityInView(view)
        
        var imageView = panGestureRecognizer.view as! UIImageView
        
        if panGestureRecognizer.state == UIGestureRecognizerState.Began {
            newlyCreatedFaceOriginalCenter = imageView.center
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                imageView.transform = CGAffineTransformMakeScale(self.faceScale + 1.4, self.faceScale + 1.4)
            })
            
        } else if panGestureRecognizer.state == UIGestureRecognizerState.Changed {
            imageView.center = CGPoint(x: translation.x + newlyCreatedFaceOriginalCenter.x, y: translation.y + newlyCreatedFaceOriginalCenter.y)
        } else if panGestureRecognizer.state == UIGestureRecognizerState.Ended {
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                imageView.transform = CGAffineTransformMakeScale(self.faceScale, self.faceScale)
            })
        }
    }
    
    func onCustomPinch(pinchGestureRecognizer: UIPinchGestureRecognizer) {
        print("Pinch!")
        faceScale = pinchGestureRecognizer.scale
        var velocity = pinchGestureRecognizer.velocity
        
        var imageView = pinchGestureRecognizer.view as! UIImageView
        imageView.transform = CGAffineTransformMakeScale(faceScale, faceScale)
    }
    
    func onCustomRotate(rotateGestureRecognizer: UIRotationGestureRecognizer) {
        print("rotate?")
        var rotation = rotateGestureRecognizer.rotation
        var velocity = rotateGestureRecognizer.velocity
        
        var imageView = rotateGestureRecognizer.view as! UIImageView
        imageView.transform = CGAffineTransformRotate(imageView.transform, CGFloat(Double(rotation) * M_PI / 180))
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer!, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer!) -> Bool {
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

