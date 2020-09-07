//
//  ViewController.swift
//  iOSParallelDownloadingFrameworkExample
//
//  Created by BS-272 on 7/9/20.
//  Copyright © 2020 taifalmusabe. All rights reserved.
//

import UIKit
import iOSParallelDownloadingFramework

class ViewController: UIViewController {
    private let urls = ["https://i.imgur.com/UvqEgCv.png", "https://i.imgur.com/dZ5wRtb.png", "https://i.imgur.com/tPzTg7A.jpg"];
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let manager = ParallelDownloadingManger.sharedInstance
        manager.parallelDownloadingForURLs(urls) { (datas, errors) in
            print(datas)
            print(errors)
        }
        // Do any additional setup after loading the view, typically from a nib.
    }


}

