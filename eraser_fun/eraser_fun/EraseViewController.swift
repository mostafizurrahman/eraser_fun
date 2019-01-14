//
//  ViewController.swift
//  eraser_fun
//
//  Created by Mostafizur Rahman on 13/1/19.
//  Copyright © 2019 Mostafizur Rahman. All rights reserved.
//

import UIKit

class EraseViewController: UIViewController {

    @IBOutlet weak var dimensionSlider: UISlider!
    @IBOutlet weak var progressLabel:UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var eraserView: EraserView!
    @IBOutlet weak var widthLayout: NSLayoutConstraint!
    @IBOutlet weak var heightLayout: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.widthLayout.constant = UIScreen.main.bounds.width * 0.9
        self.heightLayout.constant = self.widthLayout.constant
        self.view.layoutIfNeeded()
        self.eraserView.eraserDelegate = self
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func changeDimension(_ sender: Any) {
        self.eraserView.dimension = Int(self.dimensionSlider.value)
    }
    
}

extension EraseViewController:EraserDelegate {
    func didEndErasing() {
        
    }
    
    func didCompleted(Percentage percent: Float) {
        self.progressView.progress = percent
        self.progressLabel.text = String(format: "%.2f", percent * 100.0)+"%"
    }
}
