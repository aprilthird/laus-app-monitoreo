//
//  UITextFieldExtension.swift
//  TempoMonitoring
//
//  Created by Hugo Andres Rosado on 5/30/20.
//  Copyright © 2020 Sportafolio SAC. All rights reserved.
//

import Foundation
import UIKit

enum DocumentTypeEnum: String {
    case dni = "DNI"
    case passport = "Pasaporte"
    case carnet = "Carnet de extranjeria"
    case rut = "RUT"
    case employeeId = "Código de empleado"
}

enum TextFieldSize: String {
    case right
    case left
}

extension UITextField {
    final var documentTypes: [String] {
        get {
            let userDefaultsHandler = UserDefaultsHandler()
            let array = userDefaultsHandler.custom(of: [DocumentType].self, from: Constants.Keys.DOCUMENT_TYPES)?.compactMap({ (documentType) -> String? in
                return documentType.name
            }) ?? []
            return array
        }
    }
    final var documentTypeId: Int? {
        get {
            let userDefaultsHandler = UserDefaultsHandler()
            guard let text = text, !text.isEmpty, let documentTypes = userDefaultsHandler.custom(of: [DocumentType].self, from: Constants.Keys.DOCUMENT_TYPES) else {
                return nil
            }
            var id: Int? = nil
            for documentType in documentTypes {
                if text.lowercased() == documentType.name.lowercased() {
                    id = documentType.id
                    continue
                }
            }
            return id
        }
    }
    
    final var isTextValid: Bool! {
        get {
            guard let text = text, !text.isEmpty else {
                return false
            }
            return true
        }
    }
    
    func addImage(_ image: UIImage, to side: TextFieldSize, padding: CGFloat, margin: CGSize) {
        let iconWidth: CGFloat = image.size.width - padding
        let iconHeight: CGFloat = image.size.height - padding
        
        let imageView = UIImageView(frame: CGRect(x: margin.width,
                                                  y: margin.height,
                                                  width: iconWidth,
                                                  height: iconHeight))
        imageView.image = image
        let view = UIView(frame: CGRect(x: 0,
                                        y: 0,
                                        width: iconWidth + margin.width,
                                        height: iconHeight + margin.height))
        view.addSubview(imageView)
        switch side {
        case .right:
            self.rightView = view
            self.rightViewMode = .always
        case .left:
            self.leftView = view
            self.leftViewMode = .always
        }
    }
    
    func addPadding(_ padding: CGFloat = 8, to side: TextFieldSize) {
        let view = UIView(frame: CGRect(x: 0,
                                        y: 0,
                                        width: padding,
                                        height: self.bounds.height))
        view.backgroundColor = .clear
        switch side {
        case .right:
            self.rightView = view
            self.rightViewMode = .always
        case .left:
            self.leftView = view
            self.leftViewMode = .always
        }
    }
    
    func loadDropdown(with array: [String], startingAt index: Int = 0) {
        inputView = TextFieldPickerView(textField: self, with: array, startingAt: index)
    }
    
    func loadDocumentTypes(startingAt index: Int = 0) {
        inputView = TextFieldPickerView(textField: self, with: documentTypes, startingAt: index)
    }
}
