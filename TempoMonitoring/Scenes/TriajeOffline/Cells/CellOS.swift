//
//  CellOS.swift
//  TempoMonitoring
//
//  Created by Jose Silva on 9/09/21.
//  Copyright © 2021 Sportafolio SAC. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class CellOS: UITableViewCell {

    @IBOutlet weak var lbPregunta: UILabel!
    @IBOutlet weak var picker: SkyFloatingLabelTextField!
    @IBOutlet weak var mainView: UIView!
    var textField: SkyFloatingLabelTextField? = nil
    
    private var pickerCell = UIPickerView()
    private var items: [String] = []
//    private var keyboardObserver: KeyboardObserver!
    var delegateResponse: CustomCellResponseDelegate?
    var delegateCuadroTexto: CuadroTextoDelegate?
    var index: IndexPath!
    var required: Bool = false
    
    var alternativas: String? {
        willSet(newValue) {
            if let value = newValue {
                items = value.components(separatedBy: "|")
                items.insert("Seleccione...", at: 0)
            }
//            if required {
//                mainView.backgroundColor = UIColor.red.withAlphaComponent(0.1)
//                mainView.layer.borderColor = UIColor.red.cgColor
//                mainView.layer.borderWidth = 1
//            } else {
//                mainView.backgroundColor = UIColor.white
//                mainView.layer.borderColor = UIColor.red.cgColor
//                mainView.layer.borderWidth = 0
//            }
        }
    }
    
    var cuadroTexto: String? {
        willSet(newValue) {
            if let value = newValue, newValue != "" {
                let textField = SkyFloatingLabelTextField()
                textField.placeholder = cuadroTexto
                textField.selectedTitle = cuadroTexto
                textField.textColor = UIColor.init(named: "TextColor")
                textField.placeholderColor = UIColor.init(named: "TextTitleColor")!
                textField.titleColor = UIColor.init(named: "TextLine")!
                textField.lineColor = UIColor.init(named: "TextLine")!
                textField.selectedTitleColor = UIColor.init(named: "TextTitleColor")!
                textField.selectedLineColor = UIColor.init(named: "TextLine")!
                textField.lineHeight = 1
                textField.selectedLineHeight = 1
                textField.translatesAutoresizingMaskIntoConstraints = false
                self.mainView.addSubview(textField)
                NSLayoutConstraint.activate([
                    textField.leadingAnchor.constraint(equalTo: textField.superview!.leadingAnchor, constant: 0),
                    textField.trailingAnchor.constraint(equalTo: textField.superview!.trailingAnchor, constant: 0)
                ])
                let lastView = self.mainView.subviews.last
                textField.topAnchor.constraint(equalTo: lastView!.bottomAnchor, constant: 56).isActive = true
                self.textField = textField
                textField.delegate = self
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        pickerCell.delegate = self
        picker.inputView = pickerCell
        configKeyboardAndPickers()
        if let cuadroTextoView = self.textField {
            cuadroTextoView.removeFromSuperview()
        }
    }
    
    func configKeyboardAndPickers(){
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let okButton = UIBarButtonItem(title: "Aceptar", style: .plain, target: self, action: #selector(self.dissmissPickers))
        toolbar.setItems([okButton], animated: false)
        toolbar.isUserInteractionEnabled = true
        
        picker.inputAccessoryView = toolbar
    }
    
    @objc func dissmissPickers(sender: UITextField)
    {
        if (picker.text != "" && required) || !required {
            picker.endEditing(true)
            delegateResponse?.getResponse(value: picker.text, index: index.row, group: index.section, cell: self)
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}

extension CellOS: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return items.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return items[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if items[row] != "Seleccione..." {
            picker.text = items[row]
        } else {
            picker.text = ""
        }
    }
}

extension CellOS: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        delegateCuadroTexto?.getCuadroTexto(value: textField.text, index: index.row, group: index.section)
    }
}
