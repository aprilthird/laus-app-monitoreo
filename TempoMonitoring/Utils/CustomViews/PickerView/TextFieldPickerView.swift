//
//  TextFieldPickerView.swift
//  TempoMonitoring
//
//  Created by Hugo Andres Rosado on 5/30/20.
//  Copyright © 2020 Sportafolio SAC. All rights reserved.
//

import UIKit

class TextFieldPickerView: UIPickerView {

    private var elements: [String]
    weak var textField: UITextField?
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    required init(textField: UITextField, with elements: [String], startingAt index: Int) {
        self.elements = elements
        self.textField = textField
        super.init(frame: .zero)
        
        delegate = self
        dataSource = self
        textField.text = (!elements.isEmpty && index < elements.count) ? elements[index] : nil
        textField.isEnabled = (!elements.isEmpty) ? true : false
    }

}
extension TextFieldPickerView: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return elements.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return elements[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        textField?.text = elements[row]
    }
}
