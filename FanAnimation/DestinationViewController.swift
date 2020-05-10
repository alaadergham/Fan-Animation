//
//  DestinationViewController.swift
//  FanAnimation
//
//  Created by Alaa Dergham on 4/28/20.
//  Copyright © 2020 Alaa Dergham. All rights reserved.
//

import UIKit

class DestinationViewController: UIViewController {
    var fromText = "";
    @IBAction func dissmessViewController(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
        
    }
    @IBOutlet weak var textLabel: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textLabel.text = "From: "+fromText
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   
    
}
