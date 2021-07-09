//
//  BottomSheet.swift
//  SwiftBottomSheet
//
//  Created by Massimiliano Famà on 09/07/21.
//

import Foundation
import UIKit

class BottomSheet: UIView {
    
    private var overlayView: UIView?
    private var defaultCenterY: CGFloat?
    private var defaultMaxY: CGFloat?
    private var panGesture: UIPanGestureRecognizer?
    private var controller: UIViewController!{
        didSet{
            
            controller.view.addSubview(self)
            
            translatesAutoresizingMaskIntoConstraints = false
    
            bottomAnchor.constraint(equalTo: controller.view.bottomAnchor, constant: 0).isActive = true
            leadingAnchor.constraint(equalTo: controller.view.leadingAnchor, constant: 0).isActive = true
            trailingAnchor.constraint(equalTo: controller.view.trailingAnchor, constant: 0).isActive = true
        
            isHidden = true
        }
    }
    
    override var isHidden: Bool{
        didSet{
            self.overlayView?.isHidden = isHidden
        }
    }
    
    ///Points reamining when view is dragged bottom. Default 100
    var remainingPanView: CGFloat = 100
    
    ///Enable pan gesture
    var isPanEnabled: Bool = false{
        didSet{
            if isPanEnabled{
                panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.draggedView(_:)))
                isUserInteractionEnabled = true
                addGestureRecognizer(panGesture!)
            }else{
                if let panGesture = panGesture{
                    removeGestureRecognizer(panGesture)
                }
            }
        }
    }
    
    ///Add overlay when bottomshet is open
    var overlay: Bool = false{
        didSet{
            overlayView = UIView(frame: controller.view.bounds)
            overlayView?.backgroundColor = .black.withAlphaComponent(0.5)
            overlayView?.isHidden = true
            controller.view.insertSubview(overlayView!, belowSubview: self)
        }
    }
    
    /**
     Instantiate bottomsheet view
     - Parameters:
         - controller: The viewcontroller where bottomsheet comes out
         - withShadow: Optional - Add default shadow to the bottomsheet - Default true
         - withPanGesture: Optional - Add pan gesture  to the bottomsheet - Default false
     - Returns: The bottomsheet view
    */
    class func instantiate<T: UIView>(controller: UIViewController, withShadow shadow: Bool = true, withPanGesture pan: Bool = false) -> T {
        let view =  Bundle(for: T.self).loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
        (view as? BottomSheet)?.controller = controller
        (view as? BottomSheet)?.viewDidLoad()
        (view as? BottomSheet)?.isPanEnabled = pan

        if shadow{
            (view as? BottomSheet)?.defaultShadow()
        }
      
        return view
    }
    
    func viewDidLoad(){}
    
    /**
     Show bottomsheet view
     - Parameters:
         - withDuration: Optional - animation duration - Default 0.5
         - delay: Optional - animation delay - Default 0
    */
    func show(withDuration duration: TimeInterval = 0.5, delay: TimeInterval = 0){
        //Workaround small device - reset Y
        if let maxY = defaultMaxY{
            frame = CGRect.init(x: 0, y: maxY, width: frame.width, height: frame.height)
        }else{
            defaultMaxY = frame.maxY
        }
        
        UIView.animate(
            withDuration: duration,
            delay: delay,
            options: [.curveEaseIn],
            animations: {
                self.center.y -= self.bounds.height
                self.layoutIfNeeded()
            }, completion: nil)
        isHidden = false
     }

    /**
     Hide bottomsheet view
     - Parameters:
         - withDuration: Optional - animation duration - Default 0.5
         - delay: Optional - animation delay - Default 0
    */
    func hide(withDuration duration: TimeInterval = 0.5, delay: TimeInterval = 0){
        layoutIfNeeded()
        UIView.animate(
            withDuration: duration,
            delay: delay,
            options: [.curveLinear],
            animations: {
                self.center.y += self.bounds.height
                self.layoutIfNeeded()
            },
            completion: {(_ completed: Bool) -> Void in
                self.isHidden = true
            })
    }
    
    
    
    //MARK: - Private functions
    
    @objc func draggedView(_ sender:UIPanGestureRecognizer){
        //Prevent pan over bottom constraint
        if defaultCenterY == nil{
            defaultCenterY = center.y
        }
        
        let translation = sender.translation(in: controller.view)
        let remainingView = frame.size.height / 2 - (center.y - UIScreen.main.bounds.height)
        if (remainingView > remainingPanView || translation.y < 0){
            if let centerY = defaultCenterY, center.y + translation.y > centerY{
                center = CGPoint(x: center.x, y: center.y + translation.y)
                sender.setTranslation(CGPoint.zero, in: controller.view)
            }else{
                center = CGPoint(x: center.x, y: defaultCenterY ?? center.y)
            }
        }
    }
    
    private func defaultShadow(){
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOffset = CGSize(width: 0.0, height : -5.0)
        layer.shadowOpacity = 0.2
        layer.shadowRadius = 5
        clipsToBounds = false
    }
    
}

