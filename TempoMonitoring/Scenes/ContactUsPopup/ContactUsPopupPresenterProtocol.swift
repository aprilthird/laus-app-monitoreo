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
    func sendInformation(names: String, lastNames: String, company: String, documentTypeId: Int, document: String, phone: String, description: String, closure: @escaping(() -> Void))
    func validateKeyboard(text: String?) -> UIKeyboardType
}
