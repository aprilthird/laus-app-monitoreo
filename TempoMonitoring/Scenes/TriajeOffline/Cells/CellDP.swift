//
//  CellDP.swift
//  TempoMonitoring
//
//  Created by Manuel Alejandro López Corrales on 9/10/21.
//  Copyright © 2021 Sportafolio SAC. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class CellDP: UITableViewCell, UITextFieldDelegate {
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var lbPregunta: UILabel!
    @IBOutlet weak var txDate: SkyFloatingLabelTextField!
    
    var delegateResponse : CustomCellResponseDelegate?
    var index: IndexPath!
    var fechaInPicker: UIDatePicker?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        txDate.addTarget(self, action: #selector(changeValue(textfield:)), for: .valueChanged)
        txDate.returnKeyType = .done
        txDate.delegate = self
    }
    
    @objc func changeValue(textfield: UITextField) {
        if let text = textfield.text {
            delegateResponse?.getResponse(value: text, index: index.row, group: index.section, cell: self)
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc func valueChange(_ datePicker: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        delegateResponse?.getResponse(value: formatter.string(from: datePicker.date), index: index.row, group: index.section, cell: self)
    }
    
    
    func customInput(){
        
        fechaInPicker = UIDatePicker()
        fechaInPicker?.datePickerMode = .date
        fechaInPicker?.addTarget(self, action: #selector(changeDateCell(datePicker:)), for: .valueChanged)
        fechaInPicker?.locale = .current
        
        if #available(iOS 13.4, *) {
            fechaInPicker?.preferredDatePickerStyle = .wheels
        }
        
        // TOOLBAR
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let dondeButton = UIBarButtonItem(title: "Aceptar", style: .plain, target: self, action: #selector(self.hideKeyboard))
        toolbar.setItems([dondeButton], animated: false)
        toolbar.isUserInteractionEnabled = true
        
        txDate.inputView = fechaInPicker
        txDate.inputAccessoryView = toolbar
    }
    
    @objc func hideKeyboard() {
        if txDate.text == "" {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            txDate.text = formatter.string(from: Date())
            let text = txDate.text
            delegateResponse?.getResponse(value: text, index: index.row, group: index.section, cell: self)
        }
        txDate.resignFirstResponder()
    }
    
    @objc func changeDateCell(datePicker: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        txDate.text = formatter.string(from: fechaInPicker!.date)
        let text = txDate.text
        delegateResponse?.getResponse(value: text, index: index.row, group: index.section, cell: self)
        datePicker.endEditing(true)
    }
}
