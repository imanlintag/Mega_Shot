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
    
    var lastBasketballY: CGFloat!
    var isCollide = false
    var gameEnded = false
    var isShoot = false
    var isInsideBasket = false;
    
    var touchPointBegin: CGPoint!
    var touchPointEnd: CGPoint!
    
    var actualScore: Int = 0
    var bestScore: Int = 0
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let defaults = UserDefaults.standard
        bestScore = defaults.integer(forKey: "basketBestScore")
        updateScore()
        updateHighScore()
        spawnBall()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: view)
            touchPointBegin = location
        }
        super.touchesBegan(touches, with: event)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: view)
            touchPointEnd = location
        }
        super.touchesEnded(touches, with: event)
        shoot()
    }
    
    func animateLabel() {
        if actualScore != 1 {
            
            UIView.animate(withDuration: 0.2, animations: {
                self.scoreLabel.transform = self.scoreLabel.transform.scaledBy(x: 0.2, y: 0.2)
            }, completion: { (Bool) in
                self.scoreLabel.text = "\(self.actualScore)"
                UIView.animate(withDuration: 0.2, animations: {
                    self.scoreLabel.transform = self.scoreLabel.transform.scaledBy(x: 5, y: 5)
                })
            })
        }
        else {
            self.scoreLabel.text = "\(self.actualScore)"
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
        resetGameProperties()
    }

    func resetGameProperties() {
        isCollide = false
        gameEnded = false
        isShoot = false
        isInsideBasket = false
        lastBasketballY = 0
    }
    
    func endGame() {
        UIView.animate(withDuration: 0.3, animations: {
            self.progBasketball.alpha = 0
        }, completion: {
            (value: Bool) in
            self.spawnBall()
        })
    }
    
    func shoot() {
        if !isShoot {
            animator.addBehavior(collision)
            animator.addBehavior(elasticity)
            animator.addBehavior(gravity)
            isShoot = true
        }
    }
    
    func updateScore() {
        if self.isInsideBasket {
            actualScore = actualScore + 1
        } else {
            updateHighScore()
            actualScore = 0
        }
        animateLabel()
        if actualScore == 0 {
            self.scoreLabel.isHidden = true
        } else {
            self.scoreLabel.isHidden = false
        }
    }
    
    func updateHighScore() {
        if bestScore < actualScore {
            bestScore = actualScore
            
            let defaults = UserDefaults.standard
            defaults.set(bestScore, forKey: "basketBestScore")
            print("save best score")
        }
        self.bestScoreLabel.text = "High Score : \(bestScore)"
    }

}
