//
//  BottomSheetExample.swift
//  SwiftBottomSheet
//
//  Created by Massimiliano Famà on 09/07/21.
//

import Foundation
import UIKit

class BottomSheetExample: BottomSheet {
    
    
    @IBOutlet weak var label: UILabel!
    
    // MARK: - Functions
    override func viewDidLoad(){

    }
    
    public func initialize(label: String){
        self.label.text = label
        show()
    }

    @IBAction func hideAction(_ sender: Any) {
        hide()
    }
    
}
    
