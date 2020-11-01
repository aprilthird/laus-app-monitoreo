//
//  PasswordSignInViewController.swift
//  TempoMonitoring
//
//  Created by Hugo Rosado on 10/31/20.
//  Copyright © 2020 Sportafolio SAC. All rights reserved.
//

import UIKit

class PasswordSignInViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var logoView: UIView!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var logoLabel: UILabel!
    @IBOutlet weak var instructionsLabel: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var forgotPasswordButton: UIButton!
    @IBOutlet weak var mainButton: UIButton!
    var passwordSignInPresenter: PasswordSignInPresenterProtocol!
    var documentTypeId: Int!
    var document: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        [passwordTextField].forEach { (textField) in
            textField?.addPadding(15, to: .left)
            textField?.addPadding(15, to: .right)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        navigationController?.navigationBar.shadowImage = nil
        navigationController?.navigationBar.isTranslucent = false
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        [passwordTextField].forEach { (textField) in
            textField?.layer.borderWidth = 0.5
            textField?.layer.borderColor = UIColor.lightGray.cgColor
            textField?.layer.cornerRadius = textField!.bounds.height / 2
        }
    }
    
    @IBAction func didForgotPassword(_ sender: UIButton) {
        passwordSignInPresenter.forgotPassword(documentTypeId: documentTypeId, document: document)
    }
    
    @IBAction func didSignIn(_ sender: UIButton) {
        guard passwordTextField.isTextValid else {
            show(.alert, message: Constants.Localizable.INVALID_PASSWORD)
            return
        }
        
        passwordSignInPresenter.signIn(documentTypeId: documentTypeId, document: document, password: passwordTextField.text ?? "")
    }

}
extension PasswordSignInViewController: PasswordSignInViewControllerProtocol {
    func goToForgotPasswordPopup(_ imageUrl: String?, _ message: String) {
        let popup = Router.shared.getForgotPasswordPopup(imageUrl: imageUrl, message: message)
        popup.modalPresentationStyle = .overFullScreen
        popup.modalTransitionStyle = .crossDissolve
        present(popup, animated: true, completion: nil)
    }
    
    func goToMain() {
        let mainTabBar = Router.shared.getMainTabBar()
        crossDisolveTransition(to: mainTabBar)
    }
}
