//
//  ViewController.swift
//  Weather or Not
//
//  Created by Daniel Huang on 9/7/17.
//  Copyright © 2017 Daniel Huang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        Weather.forecast(withLocation: "47.20296790272209,-123.41670367098749") {
            (results:[Weather]) in
            
            for result in results {
                print("\(result)\n\n")
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

