//
//  WelcomeOptionsPresenterProtocol.swift
//  TempoMonitoring
//
//  Created by Hugo Andres on 20/02/21.
//  Copyright © 2021 Sportafolio SAC. All rights reserved.
//

import UIKit

protocol WelcomeOptionsPresenterProtocol {
    func getHeaderOptions() -> (String, String)
    func getPrimaryColor() -> String?
    func loadOptions()
}
