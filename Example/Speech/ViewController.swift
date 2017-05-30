//
//  ViewController.swift
//  Speech
//
//  Created by matteocrippa on 05/30/2017.
//  Copyright (c) 2017 matteocrippa. All rights reserved.
//

import UIKit
import Speech

class ViewController: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    Speech.shared.speak(text: "Hello it seems to work fine!! Awesome 11111!")
    
    
    // Do any additional setup after loading the view, typically from a nib.
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
}

