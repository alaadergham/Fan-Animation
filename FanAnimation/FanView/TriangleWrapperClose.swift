//
//  TriangleWrapperClose.swift
//  FanAnimation
//
//  Created by Alaa Dergham on 11/13/17.
//  Copyright © 2017 Alaa Dergham. All rights reserved.
//

import UIKit

class TriangleWrapperClose: UIView {
    
    var radius : Double?
    var tabBarHeight : CGFloat?
    
    init(frame: CGRect, radius : Double, tabBarHeight : CGFloat) {
        super.init(frame: frame)
        if Cache.system.layoutLanguage == .arabic{
            transform = CGAffineTransform(scaleX: -1, y: 1)
        }
        backgroundColor = .clear
        self.radius = radius
        self.tabBarHeight = tabBarHeight
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        let screenHeight = UIScreen.main.bounds.height
        let fanCenter = CGPoint(x: center.x, y: screenHeight - tabBarHeight!)
        let point1 = CGPoint(x: fanCenter.x + CGFloat(radius! * cos(1.25 * .pi)), y: fanCenter.y + CGFloat(radius! * -sin(1.25 * .pi)))
        let point2 = CGPoint(x: fanCenter.x + CGFloat(radius! * cos(0.75 * .pi)), y: fanCenter.y + CGFloat(radius! * -sin(0.75 * .pi)))
        let point3 = CGPoint(x: fanCenter.x + CGFloat(radius! * cos(0.5 * .pi)), y: fanCenter.y + CGFloat(radius! * -sin(0.5 * .pi)))
        let point4 = CGPoint(x: fanCenter.x + CGFloat(radius! * cos(0.25 * .pi)), y: fanCenter.y + CGFloat(radius! * -sin(0.25 * .pi)))
        let points = [point1, point2, point3, point4];
        
        for i in (0..<points.count).reversed(){
            let point = points[0]
            let path = UIBezierPath()
            path.move(to: fanCenter)
            path.addLine(to: point)
            path.addArc(withCenter: fanCenter, radius: CGFloat(radius!), startAngle: -(1.25 * .pi), endAngle: -.pi, clockwise: true)
            path.close()
            // Setting CAShapelayer
            let color = UIColor(hue: 0, saturation: 0, brightness: 0.85, alpha: 1)
            let triangleLayer = CAShapeLayer()
            triangleLayer.fillColor = color.cgColor
            triangleLayer.shadowColor = UIColor.black.cgColor
            triangleLayer.shadowRadius = 5
            triangleLayer.shadowOpacity = 0.5
            triangleLayer.shadowOffset = CGSize.zero
            triangleLayer.name = "triangle\(i+1)"
            // Animation
            triangleLayer.anchorPoint = CGPoint(x: 1, y: 0)
            
            CATransaction.begin()
            let animation = CABasicAnimation(keyPath: "transform.rotation")
            animation.duration = 0.6
            animation.fromValue = CGFloat(.pi * (0.25 * Double(4 - i)))
            animation.toValue = CGFloat(-.pi * 0.25)
            if (i == 0 ){
                animation.delegate = self
            }
            
            triangleLayer.bounds = path.cgPath.boundingBox
            triangleLayer.position = fanCenter
            triangleLayer.path = path.cgPath
            triangleLayer.add(animation, forKey: "SpinAnimation")
            layer.addSublayer(triangleLayer)
            
            CATransaction.commit()
            
        }
    }
    
    
}

extension TriangleWrapperClose: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        removeFromSuperview()
    }
}

