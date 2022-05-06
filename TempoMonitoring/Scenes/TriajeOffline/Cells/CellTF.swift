//
//  CellN.swift
//  TempoMonitoring
//
//  Created by Manuel Alejandro López Corrales on 9/9/21.
//  Copyright © 2021 Sportafolio SAC. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class CellTF: UITableViewCell, UITextFieldDelegate {
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var lbPregunta: UILabel!
    @IBOutlet weak var textField: SkyFloatingLabelTextField!
    
    var delegateResponse : CustomCellResponseDelegate?
    var index: IndexPath!
    var type: TextFieldType = .TEXT
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        textField.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        delegateResponse?.getResponse(value: textField.text, index: index.row, group: index.section, cell: self)
    }
    
    func configKeyboard(){
        switch type  {
        case .TEXT:
            textField.keyboardType = .alphabet
        case .NUMBER:
            textField.keyboardType = .decimalPad
        }
    }
}

enum TextFieldType {
    case NUMBER
    case TEXT
}
