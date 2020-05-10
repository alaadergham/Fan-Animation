//
//  MainTabBarViewController.swift
//  FanAnimation
//
//  Created by Alaa Dergham on 11/12/17.
//  Copyright © 2017 Alaa Dergham. All rights reserved.
//

import UIKit



class MainTabBarViewController: UITabBarController,TriangleWrapperProtocol{
    /// identifying the source
    var fromTriangle = ""
    
    /// handle the behaviour of touchUpInside for triangles of the the fan
    ///
    /// - Parameter triangleName: String to define the source
    func didClickTriangle(triangleName: String) {
        
        fromTriangle = triangleName
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "fromMainTabBarToFirst", sender: self)
        }
        
    }
    
    var fanOpened : Bool = false
    var fanButton : UIButton?
    var fanView : TriangleWrapper?
    var fanViewClose : TriangleWrapperClose?
    var backgroundViewForFading : UIView?
    /// choose the hight of the fan button
    var tabBarHeight : CGFloat = 70
    let screenWidth = UIScreen.main.bounds.size.width
    let screenHeight = UIScreen.main.bounds.size.height
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpFanButton()
        
    }
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /// setup the Fan button
    func setUpFanButton(){
        if UIDevice().userInterfaceIdiom == .phone {
            if UIScreen.main.nativeBounds.height == 2436 {   // for iPhone X
                tabBarHeight += 44
            }
        }
        
        fanButton = UIButton(frame: CGRect(origin: CGPoint(x: view.bounds.size.width/2 - 32, y: view.bounds.size.height - tabBarHeight), size:CGSize(width: 64, height: 64)))
        fanButton?.layer.cornerRadius = (fanButton?.frame.size.height)!/2
        fanButton?.backgroundColor = .clear
        fanButton?.setImage(UIImage(named:"fanImg"), for: .normal)
        fanButton?.addTarget(self, action: #selector(fanAction(_:)), for: .touchUpInside)
        view.addSubview(fanButton!)
        view.layoutIfNeeded()
    }
    
    /// mange the behaviour of fan animation
    ///
    /// - Parameter sender: (fan button itself)
    @objc func fanAction(_ sender : UIButton){
        
        if !fanOpened {
            fanButton?.setImage(UIImage(named: "fanImg"), for: .normal)
            fanOpened = true
            fanView = TriangleWrapper(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight), radius: Double(screenWidth/2), tabBarHeight: tabBar.frame.size.height)
            tabBarController?.tabBar.layer.zPosition = (fanView?.layer.zPosition)! + 1
            backgroundViewForFading = UIView(frame: (fanView?.frame)!)
            backgroundViewForFading?.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
            selectedViewController?.view.addSubview(backgroundViewForFading!)
            selectedViewController?.view.addSubview(fanView!)
            
            
            
            fanView?.delegate = self
            UIView.setAnimationsEnabled(true)
            fanButton?.isUserInteractionEnabled = false
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: {
                self.backgroundViewForFading?.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.5)
            }, completion: { success in
                self.fanButton?.isUserInteractionEnabled = true
            })
        } else {
            closeFan()
        }
    }
    /// closing the fan
    @objc func closeFan(){
        if fanOpened {
            fanButton?.setImage(UIImage(named: "fanImg"), for: .normal)
            fanOpened = false
            fanViewClose = TriangleWrapperClose(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight), radius: Double(screenWidth/2), tabBarHeight: tabBar.frame.size.height)
            tabBarController?.tabBar.layer.zPosition = (fanViewClose?.layer.zPosition)! + 1
            self.backgroundViewForFading?.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.5)
            fanButton?.isUserInteractionEnabled = false
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveLinear, animations: {
                self.backgroundViewForFading?.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
            }, completion: {[weak self] finished in
                self?.backgroundViewForFading?.removeFromSuperview()
                self?.fanButton?.isUserInteractionEnabled = true
            })
            fanView?.removeFromSuperview()
            selectedViewController?.view.addSubview(fanViewClose!)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is DestinationViewController
        {
            let vc = segue.destination as? DestinationViewController
            vc?.fromText = fromTriangle
        }
    }
}


extension MainTabBarViewController : UITabBarControllerDelegate{
    // UITabBarDelegate
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        //print("Selected item")
    }
    
    // UITabBarControllerDelegate
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if fanOpened {
            closeFan()
        }
    }
    
    public func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        let fromView: UIView = tabBarController.selectedViewController!.view
        let toView  : UIView = viewController.view
        if fromView == toView {
            return false
        }
        if fanOpened {
            UIView.transition(from: fromView, to: toView, duration: 0.5, options: UIViewAnimationOptions.transitionCrossDissolve) { (finished:Bool) in
            }
        } else {
            UIView.transition(from: fromView, to: toView, duration: 0.3, options: UIViewAnimationOptions.transitionCrossDissolve) { (finished:Bool) in
            }
        }
        return true
    }
    
}

