//
//  ContactUsPopupPresenterProtocol.swift
//  TempoMonitoring
//
//  Created by Hugo Andres Rosado on 5/31/20.
//  Copyright © 2020 Sportafolio SAC. All rights reserved.
//

import Foundation
import UIKit

protocol ContactUsPopupPresenterProtocol {
    func sendInformation(names: String, lastNames: String, company: String, documentType: Int, document: String, phone: String, closure: @escaping(() -> Void))
    func validateKeyboard(text: String?) -> UIKeyboardType
}
