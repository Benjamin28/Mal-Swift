//
//  ViewController.swift
//  Mal-Swift
//
//  Created by test on 1/6/17.
//  Copyright © 2017 benjamin28. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view, typically from a nib.
        
        var p: Parser = Parser(functionString: "2*x") 	
        p.parserPlot(start: 0.0, end: 5.0, totalSteps: 1000)
        print(p.getY())
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

