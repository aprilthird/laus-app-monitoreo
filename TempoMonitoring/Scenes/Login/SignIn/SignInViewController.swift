//
//  SignInViewController.swift
//  TempoMonitoring
//
//  Created by Hugo Andres Rosado on 5/30/20.
//  Copyright © 2020 Sportafolio SAC. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var logoView: UIView!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var logoLabel: UILabel!
    @IBOutlet weak var instructionsLabel: UILabel!
    @IBOutlet weak var documentTypeTextField: UITextField!
    @IBOutlet weak var documentTextField: UITextField!
    @IBOutlet weak var contactUsView: UIView!
    @IBOutlet weak var contactUsLabel: UILabel!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var contactUsButton: UIButton!
    @IBOutlet weak var mainButton: UIButton!
    var shouldSignUpUser: Bool?
    var signUpUrl: String?
    var signInPresenter: SignInPresenterProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        [self.documentTypeTextField, self.documentTextField].forEach { (textField) in
            textField?.delegate = self
            textField?.addPadding(15, to: .left)
            textField?.addPadding(15, to: .right)
        }
        documentTypeTextField.loadDocumentTypes()
        
        guard shouldSignUpUser == nil else {
            signUpButton.isHidden = !shouldSignUpUser!
            return
        }
        
        signUpButton.isHidden = true
        signInPresenter.didLoadSignUpLogic()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        navigationController?.navigationBar.shadowImage = nil
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        [documentTypeTextField, documentTextField].forEach { (textField) in
            textField?.layer.borderWidth = 0.5
            textField?.layer.borderColor = UIColor.lightGray.cgColor
            textField?.layer.cornerRadius = textField!.bounds.height / 2
        }
        [signUpButton, contactUsButton].forEach { (button) in
            button?.layer.cornerRadius = button!.bounds.height / 2
        }
    }
    
    @IBAction func didShowSignUp(_ sender: UIButton) {
        guard let signUpUrl = signUpUrl else {
            return
        }
        let mainWebView = Router.shared.getMainWebView(title: Constants.Localizable.SIGN_UP_TITLE, url: signUpUrl)
        show(mainWebView, sender: nil)
    }
    
    @IBAction func didShowContactUs(_ sender: UIButton) {
        let contactUsPopup = Router.shared.getContactUsPopup()
        contactUsPopup.modalPresentationStyle = .overCurrentContext
        contactUsPopup.modalTransitionStyle = .crossDissolve
        present(contactUsPopup, animated: true, completion: nil)
    }
    
    @IBAction func didSignIn(_ sender: UIButton) {
        guard documentTypeTextField.isTextValid else {
            show(.alert, message: Constants.Localizable.INVALID_DOCUMENT_TYPE)
            return
        }
        
        guard documentTextField.isTextValid else {
            show(.alert, message: Constants.Localizable.INVALID_DOCUMENT)
            return
        }
        
        signInPresenter.signIn(documentTypeId: documentTypeTextField.documentTypeId ?? 0, document: documentTextField.text!)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension SignInViewController: SignInViewControllerProtocol {
    func goToMain() {
        let mainTabBar = Router.shared.getMainTabBar()
        crossDisolveTransition(to: mainTabBar)
    }
    
    func updateView(url: String, visibility: Bool) {
        signUpUrl = url
        shouldSignUpUser = visibility
        signUpButton.isHidden = !visibility
        signUpButton.layoutIfNeeded()
    }
}
extension SignInViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField {
        case documentTextField:
            textField.keyboardType = signInPresenter.validateKeyboard(text: documentTypeTextField.text)
        default:
            break
        }
    }
}
