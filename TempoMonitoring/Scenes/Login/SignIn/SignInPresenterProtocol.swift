//
//  SignInPresenterProtocol.swift
//  TempoMonitoring
//
//  Created by Hugo Andres Rosado on 5/31/20.
//  Copyright © 2020 Sportafolio SAC. All rights reserved.
//

import Foundation
import UIKit

protocol SignInPresenterProtocol {
    func didLoadSignUpLogic()
    func signIn(documentTypeId: Int, document: String)
    func validateKeyboard(text: String?) -> UIKeyboardType
}
