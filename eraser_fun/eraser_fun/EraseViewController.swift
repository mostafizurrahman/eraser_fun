//
//  ViewController.swift
//  eraser_fun
//
//  Created by Mostafizur Rahman on 13/1/19.
//  Copyright © 2019 Mostafizur Rahman. All rights reserved.
//

import UIKit

class EraseViewController: UIViewController {

    @IBOutlet weak var eraserView: EraserView!
    @IBOutlet weak var widthLayout: NSLayoutConstraint!
    @IBOutlet weak var heightLayout: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.widthLayout.constant = UIScreen.main.bounds.width * 0.9
        self.heightLayout.constant = self.widthLayout.constant
        self.view.layoutIfNeeded()
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }


}

