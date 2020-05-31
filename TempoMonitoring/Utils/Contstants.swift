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
        static let COMPANY: String = "company"
        static let COMPANY_TOKEN: String = "companyToken"
        static let IS_FIRST_OPEN: String = "isFirstOpen"
        static let IS_SCANNER_ENABLED: String = "isScannerEnabled"
        static let LAST_APP_VERSION: String = "lastAppVersion"
        static let LAST_HOME_BANNER_ID: String = "lastHomeBannerId"
        static let TOKEN: String = "token"
    }
    struct Localizable {
        static let APP_NAME: String = "Tempo Monitoring"
        static let ATTENTION_TITLE: String = NSLocalizedString("Attention", comment: "")
        static let INVALID_DOCUMENT: String = NSLocalizedString("Invalid document", comment: "")
        static let INVALID_DOCUMENT_TYPE: String = NSLocalizedString("Invalid document type", comment: "")
        static let LOADING: String = NSLocalizedString("Loading...", comment: "")
        static let OK: String = NSLocalizedString("Ok", comment: "")
        static let SEND_INFORMATION_SUCCESFULLY: String = NSLocalizedString("The data has been sent correctly", comment: "")
        static let SIGN_UP_TITLE: String = NSLocalizedString("Sign Up", comment: "")
        static let TIPS_TITLE: String = NSLocalizedString("Learn", comment: "")
        static let NOTE_TITLE: String = NSLocalizedString("Note", comment: "")
        static let TRIAGE_TITLE: String = NSLocalizedString("Triage", comment: "")
    }
    struct Service {
        #if DEBUG
        // Hugo's WiFi
        private static let BASE_URL: String = "https://temposalud.com/tempo_covit/api/1"
        #else
        private static let BASE_URL: String = "https://temposalud.com/tempo_covit/api/1"
        #endif
        
        static let GET_ATTENTION_URL = "\(BASE_URL)/config.php?action=get_atenttion_webview_url"
        static let GET_HOME_BANNER = "\(BASE_URL)/config.php?action=get_home_banner"
        static let GET_QR_CODE_URL = "\(BASE_URL)/config.php?action=get_qr_webview_url"
        static let GET_SIGN_UP_URL = "\(BASE_URL)/config.php?action=get_register_link"
        static let GET_TRIAGE_URL = "\(BASE_URL)/config.php?action=get_triaje_webview_url"
        
        static let SAVE_USER_INFORMATION = "\(BASE_URL)/user.php?action=save_user_problems"
        static let SIGN_IN = "\(BASE_URL)/user.php?action=login"
    }
}
