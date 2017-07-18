//
//  ViewController.swift
//  Mega_Shot
//
//  Created by Iman Lintag on 7/16/17.
//  Copyright © 2017 Iman Lintag. All rights reserved.
//

import UIKit

class Ball : UIImageView {
    override var collisionBoundsType: UIDynamicItemCollisionBoundsType {
        return .ellipse
    }
}

class ViewController: UIViewController {

    @IBOutlet weak var basket: UIImageView!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var bestScoreLabel: UILabel!
    @IBOutlet weak var emoteLabel: UILabel!
    
    var progBasketball: Ball!
    var progBasketLine: UIImageView!
    
    var gravity: UIGravityBehavior!
    var animator: UIDynamicAnimator!
    var collision: UICollisionBehavior!
    var basketCollision: UICollisionBehavior!
    var elasticity: UIDynamicItemBehavior!
    var push: UIPushBehavior!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touches.first != nil {
        }
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            _ = touch.location(in: view)
        }

    }
    
    func createDynamicProperties() {
        if animator != nil {
            animator.removeAllBehaviors()
            animator = nil
        }
        
        animator = UIDynamicAnimator(referenceView: view)
        
        gravity = UIGravityBehavior(items: [progBasketball])
        
        elasticity = UIDynamicItemBehavior(items: [progBasketball])
        elasticity.elasticity = 0.7
        
        collision = UICollisionBehavior(items: [progBasketball])
        collision.translatesReferenceBoundsIntoBoundary = true
        
        basketCollision = UICollisionBehavior(items: [progBasketball])
        basketCollision.translatesReferenceBoundsIntoBoundary = true
        basketCollision.addBoundary(withIdentifier: "leftPanier" as NSCopying, from: CGPoint(x: 135, y: 268), to: CGPoint(x: 136, y: 268))
        basketCollision.addBoundary(withIdentifier: "rightPanier" as NSCopying, from: CGPoint(x: 231, y: 268), to: CGPoint(x: 232, y: 268))
    }

    func spawnPanierLine() {
        if progBasketLine != nil {
            progBasketLine.removeFromSuperview()
            progBasketLine = nil
        }
        
        progBasketLine = UIImageView(image: UIImage(named: "line"))
        
        let xPosition = basket.frame.origin.x + basket.frame.width - 154
        let yPosition = basket.frame.origin.y + basket.frame.height - 26.5
        let newFrame = CGRect(x: xPosition, y: yPosition, width: 97.5, height: 6)
        
        progBasketLine.frame = newFrame
        view.addSubview(progBasketLine)
    }
    
    func spawnBall() {
        if progBasketball != nil {
            progBasketball.removeFromSuperview()
            progBasketball = nil
        }
        
        let randMax: Int = Int(self.view.frame.size.width - 80)
        let xPosition = arc4random_uniform(UInt32(randMax))
        let xPositionFloat : CGFloat = CGFloat(xPosition)
        let newFrame = CGRect(x: xPositionFloat, y: 567.0, width: 80.0, height: 80.0)
        
        progBasketball = Ball(image: UIImage(named: "basketball"))
        progBasketball.frame = newFrame
        view.addSubview(progBasketball)
        
        createDynamicProperties()
    }

}
