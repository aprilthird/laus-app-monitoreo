//
//  Contstants.swift
//  TempoMonitoring
//
//  Created by Hugo Andres Rosado on 5/30/20.
//  Copyright © 2020 Sportafolio SAC. All rights reserved.
//

import Foundation

final class Constants {
    struct Keys {
        static let TOKEN: String = "token"
        static let COMPANY_TOKEN: String = "CompanyToken"
    }
    struct Localizable {
        static let APP_NAME: String = "Tempo Monitoring"
        static let OK: String = NSLocalizedString("Ok", comment: "")
    }
    struct Service {
        #if DEBUG
        // Hugo's WiFi
        private static let BASE_URL: String = "https://temposalud.com/tempo_covit/api/1"
        #else
        private static let BASE_URL: String = "https://temposalud.com/tempo_covit/api/1"
        #endif
        
        static let GET_ATTENTION_URL = "\(BASE_URL)/config.php?action=get_atenttion_webview_url"
        static let GET_QR_CODE_URL = "\(BASE_URL)/config.php?action=get_qr_webview_url"
        static let GET_SIGN_UP_URL = "\(BASE_URL)/config.php?action=get_register_link"
        static let GET_TRIAGE_URL = "\(BASE_URL)/config.php?action=get_triaje_webview_url"
    }
}
