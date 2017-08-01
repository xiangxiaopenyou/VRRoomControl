//
//  ViewController.swift
//  SwiftTest
//
//  Created by 项小盆友 on 2017/8/1.
//  Copyright © 2017年 项小盆友. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var mainImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        mainImageView.backgroundColor = UIColor .red;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

