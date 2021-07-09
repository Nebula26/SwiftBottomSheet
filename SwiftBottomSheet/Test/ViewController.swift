//
//  ViewController.swift
//  SwiftBottomSheet
//
//  Created by Massimiliano Famà on 09/07/21.
//

import UIKit

class ViewController: UIViewController {
    
    private var bottomSheet: BottomSheetExample!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        bottomSheet = .instantiate(controller: self, withShadow: true, withPanGesture: true)
        bottomSheet.remainingPanView = 50
        //Instantiate bottomsheet
    }

    @IBAction func openBottomSheet(_ sender: Any) {
        bottomSheet.initialize(label: "Testing bottomsheet")
    }
    
}

