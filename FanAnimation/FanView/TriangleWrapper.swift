//
//  TriangleWrapper.swift
//  FanAnimation
//
//  Created by Alaa Dergham on 11/12/17.
//  Copyright © 2017 Alaa Dergham. All rights reserved.
//

import UIKit

class TriangleWrapper: UIView {
    
    /// The delegate of TriangleWrapperProtocol.
    var delegate : TriangleWrapperProtocol?
    
    /// The radius of semi-circular fan
    var radius : Double?
    
    /// The height of tabBar that the fan will lies over
    var tabBarHeight : CGFloat?
    
    init(frame: CGRect, radius : Double, tabBarHeight : CGFloat) {
        super.init(frame: frame)
        if Cache.system.layoutLanguage == .arabic{
            transform = CGAffineTransform(scaleX: -1, y: 1)
        }
        backgroundColor = .clear
        self.radius = radius
        self.tabBarHeight = tabBarHeight
        let gesture = UITapGestureRecognizer(target: self, action: #selector(panned(_:)))
        addGestureRecognizer(gesture)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    /** touch-up inside the triangles detector
     */
    @objc func panned(_ sender : UITapGestureRecognizer){
        let point  = sender.location(in: self)
        let selectedTraingle = determainTriangle(point)
        delegate?.didClickTriangle(triangleName: "triangle\(selectedTraingle + 1)")
    }
    
    func determainTriangle(_ point : CGPoint) -> Int{
        let screenHeight = UIScreen.main.bounds.height
        let fanCenter = CGPoint(x: center.x, y: screenHeight - tabBarHeight!)
        let distance = sqrt(pow(point.x - fanCenter.x, 2) + pow(point.y - fanCenter.y, 2))
        if distance <= UIScreen.main.bounds.width/2 {
            let deltaX = point.x - fanCenter.x
            let theta = acos(deltaX / distance)
            if theta <= CGFloat(Double.pi / 4){
                return 3
            }
            if theta <= CGFloat(Double.pi / 2){
                return 2
            }
            if theta <=  CGFloat(3 * Double.pi / 4){
                return 1
            }
            return 0
        }
        return -1
    }
    
    
    /* overriding the draw(_ rect: CGRect) to draw semi-circular fan starting from layers to views
     */
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        //let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        let fanCenter = CGPoint(x: center.x, y: screenHeight - tabBarHeight!)
        let point1 = CGPoint(x: fanCenter.x + CGFloat(radius! * cos(.pi)), y: fanCenter.y +  CGFloat(radius! * sin(.pi)))
        let point2 = CGPoint(x: fanCenter.x + CGFloat(radius! * cos(0.75 * .pi)), y: fanCenter.y +  CGFloat(radius! * -sin(0.75 * .pi)))
        let point3 = CGPoint(x: fanCenter.x + CGFloat(radius! * cos(0.5 * .pi)), y: fanCenter.y +  CGFloat(radius! * -sin(0.5 * .pi)))
        let point4 = CGPoint(x: fanCenter.x + CGFloat(radius! * cos(0.25 * .pi)), y: fanCenter.y +  CGFloat(radius! * -sin(0.25 * .pi)))
        let points = [point1, point2, point3, point4]
        for i in 0..<points.count{
            let point = points[i]
            let path = UIBezierPath()
            path.move(to: fanCenter)
            path.addLine(to: point)
            path.addArc(withCenter: fanCenter, radius: CGFloat(radius!), startAngle: CGFloat(-(.pi - .pi * (Double(i) * 0.25))), endAngle: CGFloat(-(.pi - (.pi * Double(i + 1) * 0.25))), clockwise: true)
            path.close()
            
            // Setting CAShapelayer
            let color = UIColor(hue: 0.00, saturation: 0.00, brightness: 0.96, alpha: 1)
            //let colection right button
            let color1 = UIColor(hue: 0.00, saturation: 0.00, brightness: 0.93, alpha: 1)
            let color2 = UIColor(hue: 0.00, saturation: 0.00, brightness: 0.90, alpha: 1)
            let color3 = UIColor(hue: 0.00, saturation: 0.00, brightness: 0.84, alpha: 1)
            let colors = [color3, color2, color1, color]
            let triangleLayer = CAShapeLayer()
            triangleLayer.shadowColor = UIColor.black.cgColor
            triangleLayer.shadowRadius = 5
            triangleLayer.shadowOpacity = 0.5
            triangleLayer.shadowOffset = CGSize.zero
            triangleLayer.fillColor = colors[i].cgColor
            triangleLayer.name = "triangle\(i + 1)"
            
            //Animating
            if i == 2 || i == 3{
                triangleLayer.anchorPoint = CGPoint(x: 0, y: 1)
            }
            else{
                triangleLayer.anchorPoint = CGPoint(x: 1, y: 1)
            }
            CATransaction.begin()
            let animation = CABasicAnimation(keyPath: "transform.rotation")
            animation.duration = 0.1 * Double(i+1)
            animation.fromValue = CGFloat(-.pi * (0.25 * Double(i+1)))
            animation.toValue = 0
            if i == 3 {
                animation.delegate = self
            }
            triangleLayer.bounds = path.cgPath.boundingBox
            triangleLayer.position = fanCenter
            triangleLayer.add(animation, forKey: "SpinAnimation")
            triangleLayer.path = path.cgPath
            layer.addSublayer(triangleLayer)
            
            CATransaction.commit()
            
        }
    }
    
    /** adding icon images to the fan semi-circular view, positions are calculated relatively
     */
    func addImagesToFan(){
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        let imageWidth = screenWidth/7
        
        let imageView = UIImageView(frame:CGRect(x: (screenWidth/2) * 0.5 - imageWidth, y: (screenHeight - tabBarHeight!) - CGFloat(radius! * 0.2) - imageWidth , width: imageWidth
            , height: imageWidth * 1.13 ) )
        imageView.backgroundColor = UIColor.clear
        if Cache.system.layoutLanguage == .english {
            imageView.image = UIImage(named: "leftImg")
        } else {
            imageView.image = UIImage(named: "leftImg-ar")
            imageView.flipImage()
        }
        
        self.addSubview(imageView)
        
        
        
        let imageView1 = UIImageView(frame:CGRect(x: (screenWidth/2) * 0.3 + imageWidth, y: (screenHeight - tabBarHeight!) - CGFloat(radius! * 0.5) - imageWidth, width: imageWidth, height: imageWidth * 1.13) )
        imageView1.backgroundColor = UIColor.clear
        //imageView1.isUserInteractionEnabled = false
        if Cache.system.layoutLanguage == .english {
            imageView1.image = UIImage(named: "leftUpImg")
        } else {
            imageView1.image = UIImage(named: "leftUpImg-ar")
            imageView1.flipImage()
        }
        self.addSubview(imageView1)
        
        
        let imageView2 = UIImageView(frame:CGRect(x: screenWidth * 0.7 - imageWidth , y: (screenHeight - tabBarHeight!) - CGFloat(radius! * 0.5) - imageWidth, width: imageWidth, height: imageWidth * 1.13) )
        imageView2.backgroundColor = UIColor.clear
        if Cache.system.layoutLanguage == .english {
            imageView2.image = UIImage(named: "rightUpImg")
        } else {
            imageView2.image = UIImage(named: "rightUpImg-ar")
            imageView2.flipImage()
        }
        self.addSubview(imageView2)
        
        
        let imageView3 = UIImageView(frame:CGRect(x: screenWidth * 0.9 - imageWidth, y: (screenHeight - tabBarHeight!) - CGFloat(radius! * 0.5), width: imageWidth, height: imageWidth * 1.13) )
        imageView3.backgroundColor = UIColor.clear
        if Cache.system.layoutLanguage == .english {
            imageView3.image = UIImage(named: "rightImg")
        } else {
            imageView3.image = UIImage(named: "rightImg-ar")
            imageView3.flipImage()
        }
        self.addSubview(imageView3)
        
    }
    
}

// MARK: -Extensions
extension TriangleWrapper: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        addImagesToFan()
    }
}


// MARK: -Protocols
protocol TriangleWrapperProtocol {
    
    /**
     pass the touch-up event, inside the triangles, to the main TabBar to navigate to another views
     */
    func didClickTriangle(triangleName: String)
}
















