//
//  Contstants.swift
//  TempoMonitoring
//
//  Created by Hugo Andres Rosado on 5/30/20.
//  Copyright © 2020 Sportafolio SAC. All rights reserved.
//

import Foundation

final class Constants {
    struct Credentials {
        static let ONE_SIGNAL_APP_ID: String = "4497e601-6f34-422b-8df4-a945662c2b4e"
    }
    struct Keys {
        static let COMPANY: String = "company"
        static let COMPANY_TOKEN: String = "companyToken"
        static let IS_FIRST_OPEN: String = "isFirstOpen"
        static let IS_NOTIFICATION_ENABLED: String = "isNotificationEnabled"
        static let IS_SCANNER_ENABLED: String = "isScannerEnabled"
        static let LAST_APP_VERSION: String = "lastAppVersion"
        static let LAST_HOME_BANNER_ID: String = "lastHomeBannerId"
        static let ONE_SIGNAL_ID: String = "oneSignalId"
        static let TOKEN: String = "token"
    }
    struct Localizable {
        static let APP_NAME: String = NSLocalizedString("Tempo Monitoring", comment: "")
        static let ATTENTION_TITLE: String = NSLocalizedString("Attention", comment: "")
        static let AUTHORIZED: String = NSLocalizedString("Authorized", comment: "")
        static let CANCEL: String = NSLocalizedString("Cancel", comment: "")
        static let DEFAULT_ERROR_MESSAGE: String = NSLocalizedString("There was a problem, please try alter", comment: "")
        static let FAQ: String = NSLocalizedString("Frequently Asked Questions", comment: "")
        static let INVALID_CODE: String = NSLocalizedString("Invalid code", comment: "")
        static let INVALID_DOCUMENT: String = NSLocalizedString("Invalid document", comment: "")
        static let INVALID_DOCUMENT_TYPE: String = NSLocalizedString("Invalid document type", comment: "")
        static let LOADING: String = NSLocalizedString("Loading...", comment: "")
        static let MORE_TITLE: String = NSLocalizedString("More", comment: "")
        static let NO: String = NSLocalizedString("No", comment: "")
        static let NOTE_TITLE: String = NSLocalizedString("Note", comment: "")
        static let OK: String = NSLocalizedString("Ok", comment: "")
        static let QR_CODE_READER_TITLE: String = NSLocalizedString("QR Code Scanner", comment: "")
        static let SEND_INFORMATION_SUCCESFULLY: String = NSLocalizedString("The data has been sent correctly", comment: "")
        static let SIGN_OUT: String = NSLocalizedString("Sign out", comment: "")
        static let SIGN_OUT_QUESTION: String = NSLocalizedString("Do you want to sign out?", comment: "")
        static let SIGN_UP_TITLE: String = NSLocalizedString("Sign Up", comment: "")
        static let SUPPORT_CHAT: String = NSLocalizedString("Support chat", comment: "")
        static let TIPS_TITLE: String = NSLocalizedString("Learn", comment: "")
        static let TUTORIAL: String = NSLocalizedString("Tutorial", comment: "")
        static let UNAUTHORIZED: String = NSLocalizedString("Unauthorized", comment: "")
        static let TRIAGE_TITLE: String = NSLocalizedString("Triage", comment: "")
        static let WHAT_IS_TEMPO: String = NSLocalizedString("What is Tempo?", comment: "")
        static let YES: String = NSLocalizedString("Yes", comment: "")
    }
    struct Service {
        #if DEBUG
        // Hugo's WiFi
        private static let BASE_URL: String = "https://temposalud.com/tempo_covit/api/1"
        #else
        private static let BASE_URL: String = "https://temposalud.com/tempo_covit/api/1"
        #endif
        
        static let GET_ATTENTION_URL = "\(BASE_URL)/config.php?action=get_atenttion_webview_url"
        static let GET_FAQS = "\(BASE_URL)/config.php?action=get_faq"
        static let GET_HOME_BANNER = "\(BASE_URL)/config.php?action=get_home_banner"
        static let GET_QR_CODE_URL = "\(BASE_URL)/config.php?action=get_qr_webview_url"
        static let GET_SIGN_UP_URL = "\(BASE_URL)/config.php?action=get_register_link"
        static let GET_TRIAGE_URL = "\(BASE_URL)/config.php?action=get_triaje_webview_url"
        static let GET_TUTORIAL = "\(BASE_URL)/config.php?action=get_tutorial"
        
        static let REGISTER_DEVICE = "\(BASE_URL)/user.php?action=register_device"
        static let SAVE_USER_INFORMATION = "\(BASE_URL)/user.php?action=save_user_problems"
        static let SIGN_IN = "\(BASE_URL)/user.php?action=login"
        static let UNREGISTER_DEVICE = "\(BASE_URL)/user.php?action=unregister_device"
        
        static let GET_TIP_CATEGORIES = "\(BASE_URL)/article.php?action=get_categories"
    }
}
