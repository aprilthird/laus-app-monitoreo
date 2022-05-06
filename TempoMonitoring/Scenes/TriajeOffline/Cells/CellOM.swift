//
//  CellOM.swift
//  webcontrolOP
//
//  Created by Jose Silva on 7/29/20.
//  Copyright © 2020 WCS. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
protocol RefreshSpecificRowHeightDelegate {
    func refreshHeight(index: IndexPath)
}
protocol CustomCellResponseDelegate {
    func getResponse(value: String?, index: Int, group: Int, cell: UITableViewCell)
    func lockCell(value: String?, index: Int, group: Int, cell: UITableViewCell)
    func unlockCell(value: String?, index: Int, group: Int, cell: UITableViewCell)
}
protocol CuadroTextoDelegate {
    func getCuadroTexto(value: String?, index: Int, group: Int)
}
class CellOM: UITableViewCell {
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var lbPregunta: UILabel!
    @IBOutlet weak var listView: UIView!
    
    private var items: [DataPregunta] = []
    private var gRespuestas: [DataRepuesta?] = []
    
    var value = false
    var delegateRowHeight: RefreshSpecificRowHeightDelegate?
    var delegateResponse : CustomCellResponseDelegate?
    var delegateCuadroTexto: CuadroTextoDelegate?
    var index: IndexPath!
    
    var textField: SkyFloatingLabelTextField? = nil
    
    func configCard(){
        mainView.layer.cornerRadius = 20
        mainView.backgroundColor = UIColor.white
        
        mainView.layer.shadowColor = UIColor.black.cgColor
        mainView.layer.shadowOpacity = 0.5
        mainView.layer.shadowOffset = CGSize(width: 0, height: 1.75)
        mainView.layer.shadowRadius = 1.75
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //configCard()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func addItems(opciones: [DataPregunta], respuestas: [DataRepuesta?], cuadroTexto: String?){
        items = opciones
        gRespuestas = respuestas
        
        for vista in listView.subviews {
            vista.removeFromSuperview()
        }
        
        value = true
        var lastView: UIView?
        do {
            for element in gRespuestas {
                
                let btnOpc = CCheckbox()
                btnOpc.delegate = self
                btnOpc.animation = .showHideTransitionViews
                btnOpc.setTitle(element?.etiqueta, for: .normal)
                btnOpc.setTitle(element?.etiqueta, for: .selected)
                btnOpc.titleLabel?.numberOfLines = 0
                btnOpc.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
                btnOpc.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
                btnOpc.contentEdgeInsets = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
                btnOpc.imageView?.frame = CGRect(x: 0, y: 0, width: 48, height: 48)
                btnOpc.imageEdgeInsets = UIEdgeInsets(top: -5, left: 15, bottom: -5, right: 15)
                btnOpc.titleEdgeInsets = UIEdgeInsets(top: 10, left: 25, bottom: 10, right: 5)
                btnOpc.titleLabel?.font = UIFont(name: "AvenirNext-Regular", size: 14)
                btnOpc.setTitleColor(UIColor(named: "ColorWC"), for: .normal)
                if let disabled = element?.disabled {
                    btnOpc.isEnabled = !disabled
                } else {
                    btnOpc.isEnabled = true
                }
                btnOpc.isCheckboxSelected = element?.seleccionado ?? false
                let height = CalcHeightRow(width: mainView.layer.bounds.width, text: element?.etiqueta ?? "")
                lastView = listView.subviews.count > 0 ? listView.subviews.last : listView
                
                listView.addSubview(btnOpc)
                
                btnOpc.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    btnOpc.leadingAnchor.constraint(equalTo: btnOpc.superview!.leadingAnchor, constant: 0),
                    btnOpc.trailingAnchor.constraint(equalTo: btnOpc.superview!.trailingAnchor, constant: 0),
                    btnOpc.heightAnchor.constraint(equalToConstant: height)
                ])
                
                if element?.valor == gRespuestas.first??.valor {
                    btnOpc.topAnchor.constraint(equalTo: lastView!.topAnchor, constant: 0).isActive = true
                } else {
                    btnOpc.topAnchor.constraint(equalTo: lastView!.bottomAnchor, constant: 0).isActive = true
                }
            }
            if cuadroTexto != "" {
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
                listView.addSubview(textField)
                NSLayoutConstraint.activate([
                    textField.leadingAnchor.constraint(equalTo: textField.superview!.leadingAnchor, constant: 0),
                    textField.trailingAnchor.constraint(equalTo: textField.superview!.trailingAnchor, constant: 0)
                ])
                textField.topAnchor.constraint(equalTo: lastView!.bottomAnchor, constant: 56).isActive = true
                self.textField = textField
                self.textField?.delegate = self
            }
            if let ultimo = listView.subviews.last {
                ultimo.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    ultimo.bottomAnchor.constraint(equalTo: ultimo.superview!.bottomAnchor, constant: -8)
                ])
            }
            
            //delegateResponse?.getResponse(value: alternativas, index: index.row)
            delegateRowHeight?.refreshHeight(index: index!)
            
        } catch {
            print(error)
            print("Error en Decode ciudades: \(debugDescription)")
            debugPrint(error)
        }
    }
    
    func unSelectAll(lock: Bool, except: Int?) {
        for (idx, opcView) in listView.subviews.enumerated() {
            if let except = except, idx == except {
                continue
            }
            if let opc = opcView as? CCheckbox {
                // Si esta seleccionada, deseleccionar
                let text = opc.titleLabel?.text ?? ""
                if opc.isCheckboxSelected {
                    delegateResponse?.getResponse(value: text, index: index.row, group: index.section, cell: self)
                }
                delegateResponse?.lockCell(value: text, index: index.row, group: index.section, cell: self)
                opc.isCheckboxSelected = false
                if lock {
                    opc.isEnabled = false
                }
            }
        }
    }
    
    func unLockAll() {
        for opcView in listView.subviews {
            if let opc = opcView as? CCheckbox {
                opc.isEnabled = true
                let text = opc.titleLabel?.text ?? ""
                delegateResponse?.unlockCell(value: text, index: index.row, group: index.section, cell: self)
            }
        }
    }
    
    func isEnable(idx: Int) -> Bool {
        if let opc = listView.subviews[idx] as? CCheckbox {
            return opc.isEnabled
        }
        return true
    }
    
    func CalcHeightRow(width: CGFloat, text: String) -> CGFloat {
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byCharWrapping
        label.font = UIFont(name: "AvenirNext", size: 13)
        label.text = text
        label.sizeToFit()
        if label.frame.height > 0 {
            return label.frame.height + 16
        } else {
            return 0
        }
    }
    
}

extension CellOM: CheckboxDelegate {
    func didSelect(_ checkbox: CCheckbox) {
        let text = checkbox.titleLabel?.text ?? ""
        delegateResponse?.getResponse(value: text, index: index.row, group: index.section, cell: self)
    }

    func didDeselect(_ checkbox: CCheckbox) {
        let text = checkbox.titleLabel?.text ?? ""
        delegateResponse?.getResponse(value: text, index: index.row, group: index.section, cell: self)
    }
}

extension CellOM: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        delegateCuadroTexto?.getCuadroTexto(value: textField.text, index: index.row, group: index.section)
    }
}
