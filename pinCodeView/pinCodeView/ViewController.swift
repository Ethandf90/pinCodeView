//
//  ViewController.swift
//  pinCodeView
//
//  Created by Fei Dong on 2017-07-31.
//  Copyright © 2017 Ethan Dong. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        let frame = Utility.percentageFrame(x: 0.05, y: 0.17, width: 0.6, height: 0.08)
        // 'count' decides number of digits
        let pinView = PinInputView(frame: frame, count: 5)
        pinView.delegate = self
        
        view.addSubview(pinView)
        
        pinView.becomeFirstResponder()
    }
    
}

extension ViewController: pinCodeViewDelegate {
    // will be called after inputing all digits
    func pinInputView(view: PinInputView, didFinishWithCode code: String) {
        
        // for testing, make all underline red
        view.onError()
        
        print("code: \(code)")
    }
}

