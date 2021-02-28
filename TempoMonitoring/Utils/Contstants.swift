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
        static let DOCUMENT_TYPES: String = "documentTypes"
        static let DOCUMENT_TYPE_ID: String = "documentTypeId"
        static let DOCUMENT: String = "document"
        static let IS_CONTACT_TRACING_ENABLED: String = "isContactTracingEnabled"
        static let IS_DEVICE_REGISTERED: String = "isDeviceRegistered"
        static let IS_NOTIFICATION_ENABLED: String = "isNotificationEnabled"
        static let IS_SCANNER_ENABLED: String = "isScannerEnabled"
        static let LAST_APP_VERSION: String = "lastAppVersion"
        static let LAST_HOME_BANNER_ID: String = "lastHomeBannerId"
        static let ONE_SIGNAL_ID: String = "oneSignalId"
        static let PASSWORD: String = "password"
        static let LAST_TOKENS_UPDATE: String = "lastTokensUpdate"
        static let TOKEN: String = "token"
        static let WAS_FIRST_OPEN: String = "wasFirstOpen"
        static let WELCOME_NAME: String = "welcomeName"
    }
    struct Localizable {
        static let APP_NAME: String = NSLocalizedString("Laus", comment: "")
        static let ATTENTION_TITLE: String = NSLocalizedString("Attention", comment: "")
        static let AUTHORIZED: String = NSLocalizedString("Authorized", comment: "")
        static let CANCEL: String = NSLocalizedString("Cancel", comment: "")
        static let DEFAULT_ERROR_MESSAGE: String = NSLocalizedString("There was a problem, please try later", comment: "")
        static let DOWNLOAD_PDF_QUESTION: String = NSLocalizedString("Do you want to download this pdf?", comment: "")
        static let FAQ: String = NSLocalizedString("Frequently Asked Questions", comment: "")
        static let GO_TO_FILES_APP: String = NSLocalizedString("Go to files app", comment: "")
        static let HOME_TITLE: String = NSLocalizedString("Home", comment: "")
        static let INVALID_CODE: String = NSLocalizedString("Invalid code", comment: "")
        static let INVALID_DOCUMENT: String = NSLocalizedString("Invalid document", comment: "")
        static let INVALID_DOCUMENT_TYPE: String = NSLocalizedString("Invalid document type", comment: "")
        static let INVALID_PASSWORD: String = NSLocalizedString("Invalid password", comment: "")
        static let LAST_TRIAGE_COMPLETED: String = NSLocalizedString("Last triage completed", comment: "")
        static let LOADING: String = NSLocalizedString("Loading...", comment: "")
        static let MORE_TITLE: String = NSLocalizedString("More", comment: "")
        static let NO: String = NSLocalizedString("No", comment: "")
        static let NO_LAST_TRIAGE: String = NSLocalizedString("Triage not found", comment: "")
        static let NOTE_TITLE: String = NSLocalizedString("Note", comment: "")
        static let OK: String = NSLocalizedString("Ok", comment: "")
        static let PAST_DATE: String = NSLocalizedString("Past date", comment: "")
        static let QR_CODE_READER_TITLE: String = NSLocalizedString("QR Code Scanner", comment: "")
        static let QR_CODE_TITLE: String = NSLocalizedString("QR Code", comment: "")
        static let SEND_INFORMATION_SUCCESFULLY: String = NSLocalizedString("The data has been sent correctly", comment: "")
        static let SIGN_OUT: String = NSLocalizedString("Sign out", comment: "")
        static let SIGN_OUT_QUESTION: String = NSLocalizedString("Do you want to sign out?", comment: "")
        static let SIGN_UP_TITLE: String = NSLocalizedString("Sign Up", comment: "")
        static let SUCCESSFUL_DOWNLOAD: String = NSLocalizedString("Successful download", comment: "")
        static let SUCCESSFUL_PDF_DOWNLOAD_MESSAGE: String = NSLocalizedString("PDF was successfully downloaded", comment: "")
        static let SUPPORT_CHAT: String = NSLocalizedString("Support chat", comment: "")
        static let TIPS_TITLE: String = NSLocalizedString("Learn", comment: "")
        static let TUTORIAL: String = NSLocalizedString("Tutorial", comment: "")
        static let UNAUTHORIZED: String = NSLocalizedString("Unauthorized", comment: "")
        static let TRIAGE_TITLE: String = NSLocalizedString("Triage", comment: "")
        static let TRACING_TITLE: String = NSLocalizedString("Tracing", comment: "")
        static let WHAT_IS_LAUS: String = NSLocalizedString("What is Laus?", comment: "")
        static let YES: String = NSLocalizedString("Yes", comment: "")
    }
    struct Service {
        private static let BASE_ENDPOINT: String = "tempo_covit/api/3"
        #if DEBUG
        // Hugo's WiFi
        private static let BASE_URL: String = "https://temposalud.com/\(BASE_ENDPOINT)"
        #else
        private static let BASE_URL: String = "https://temposalud.com/\(BASE_ENDPOINT)"
        #endif
        
        static let GET_ATTENTION_URL = "\(BASE_URL)/config.php?action=get_atenttion_webview_url"
        static let GET_DOCUMENT_TYPE = "\(BASE_URL)/config.php?action=get_document_type"
        static let GET_FAQS = "\(BASE_URL)/config.php?action=get_faq"
        static let GET_HOME_BANNER = "\(BASE_URL)/config.php?action=get_home_banner"
        static let GET_HOME_BUTTONS = "\(BASE_URL)/config.php?action=get_home_buttons"
        static let GET_LAST_TRIAGE = "\(BASE_URL)/user.php?action=get_last_triaje"
        static let GET_QR_CODE_URL = "\(BASE_URL)/config.php?action=get_qr_webview_url"
        static let GET_RESOURCE_LINKS_URL = "\(BASE_URL)/config.php?action=get_resource_links"
        static let GET_SIGN_UP_URL = "\(BASE_URL)/config.php?action=get_register_link"
        static let GET_TRIAGE_ELEMENTS = "\(BASE_URL)/config.php?action=get_triaje_elements"
        static let GET_TRIAGE_URL = "\(BASE_URL)/config.php?action=get_triaje_webview_url"
        static let GET_TUTORIAL = "\(BASE_URL)/config.php?action=get_tutorial"
        static let SAVE_DEVICE_ID = "\(BASE_URL)/config.php?action=save_device_id"
        
        static let RECOVER_PASSWORD = "\(BASE_URL)/user.php?action=employee_recover_password"
        static let REGISTER_DEVICE = "\(BASE_URL)/user.php?action=register_device"
        static let SAVE_USER_INFORMATION = "\(BASE_URL)/user.php?action=save_user_problems"
        static let SIGN_IN = "\(BASE_URL)/user.php?action=login"
        static let UNREGISTER_DEVICE = "\(BASE_URL)/user.php?action=unregister_device"
        
        static let GET_TIP_CATEGORIES = "\(BASE_URL)/article.php?action=get_categories"
    }
}
