//
//  CCheckbox.swift
//  MOF

import UIKit

/**
 CheckboxDelegate protocol to be confirmed
 when you need callbacks for checkboc status change
 **/
@objc protocol CheckboxDelegate {
    func didSelect(_ checkbox: CCheckbox)
    func didDeselect(_ checkbox: CCheckbox)
}

/**
 CCheckbox is a custom UIButton class
 which represents custom checkbox with
 custom images
 **/

@IBDesignable class CCheckbox: UIButton {
    
    //MARK:- Variables
    @IBInspectable var normalImage: UIImage? = UIImage(named: "checkEmpty")
    @IBInspectable var selectedImage: UIImage? = UIImage(named: "checkFill")
    
    /// when set this variable checkbox status changed
    @IBInspectable var isCheckboxSelected: Bool = false {
        didSet {
//            self.imageView?.contentMode = .scaleAspectFit
            self.imageView?.frame=CGRect(x: 0, y: 0, width: 30, height: 30)
            self.changeStatus()
        }
    }
    
    open weak var delegate: CheckboxDelegate?
    var animation: UIView.AnimationOptions = .transitionCrossDissolve
    
    //MARK:- Customize Button Properties
    override func layoutSubviews() {
        super.layoutSubviews()
        initComponent()
    }
    
    func setImages(empty: String, fill: String) {
        normalImage = UIImage(named: empty)
        selectedImage = UIImage(named: fill)
    }
    
    private func initComponent () {
        //Check Button Type Value
        if self.buttonType != .system
            && self.buttonType != .custom {
            fatalError("Button Type Error. Please Make Button Type System or Custom")
        }
        self.addTarget(self,
                       action: #selector(CCheckbox.didTouchUpInside(_:)),
                       for: .touchUpInside)
    }
    
    //MARK:- Checkbox Status
    private func changeStatus() {
        if isCheckboxSelected {
            UIView.transition(with: self.imageView!,
                              duration:0.5,
                              options: animation,
                              animations: { self.setImage(self.selectedImage, for: .normal) },
                              completion: nil)
            /*UIView.transition(with: self,
                              duration: 0.3,
                              options: animation,
                              animations: {self.backgroundColor = UIColor.blue},
                              completion: nil)*/
            UIView.transition(with: self,
                              duration: 0.5,
                              options: animation,
                              animations: {self.setTitleColor(UIColor.black, for: .normal)},
                              completion: nil)

            
        } else {
            UIView.transition(with: self.imageView!,
                              duration:0.5,
                              options: animation,
                              animations: { self.setImage(self.normalImage, for: .normal) },
                              completion: nil)
            /*UIView.transition(with: self,
                              duration: 0.5,
                              options: animation,
                              animations: {self.backgroundColor = UIColor.clear},
                              completion: nil)*/
            UIView.transition(with: self,
                              duration: 0.5,
                              options: animation,
                              animations: {self.setTitleColor(UIColor.black, for: .normal)},
                              completion: nil)
        }
        
    }
    
    // MARK: IBActions
    @objc func didTouchUpInside(_ sender: UIButton) {
        self.isCheckboxSelected = !self.isCheckboxSelected
        
        if delegate != nil {
            if isCheckboxSelected {
                delegate?.didSelect(self)
            } else {
                delegate?.didDeselect(self)
            }
        }
    }
}
