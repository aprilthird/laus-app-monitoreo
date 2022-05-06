//
//  CompanySelectionViewController.swift
//  TempoMonitoring
//
//  Created by Luis Jeffrey Rojas Montes on 24/04/22.
//  Copyright © 2022 Sportafolio SAC. All rights reserved.
//
//
//  CompanySelectionViewController.swift
//  TempoMonitoring
//
//  Created by Luis Jeffrey Rojas Montes on 17/04/22.
//  Copyright © 2022 Sportafolio SAC. All rights reserved.
//

import UIKit

class CompanySelectionViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var logoView: UIView!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var logoLabel: UILabel!
    @IBOutlet weak var companyTextField: UITextField!
    @IBOutlet weak var instructionsLabel: UILabel!
    @IBOutlet weak var mainButton: UIButton!
    var companySelectionPresenter: CompanySelectionPresenterProtocol!
    var documentTypeId: Int!
    var document: String!
    var userCompanies: [(id: String, name: String)] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        [companyTextField].forEach { (textField) in
            textField?.addPadding(15, to: .left)
            textField?.addPadding(15, to: .right)
        }
        
        let companyNames = userCompanies.compactMap { (company) -> (String)? in
            return company.name
        }
        self.companyTextField.loadDropdown(with: companyNames)
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
        
        [companyTextField].forEach { (textField) in
            textField?.layer.borderWidth = 0.5
            textField?.layer.borderColor = UIColor.lightGray.cgColor
            textField?.layer.cornerRadius = textField!.bounds.height / 2
        }
    }
    
    @IBAction func didSignIn(_ sender: UIButton) {
        guard companyTextField.isTextValid else {
            show(.alert, message: Constants.Localizable.INVALID_COMPANY)
            return
        }
        
        let companyName = self.companyTextField.text
        var companyId: String = ""
        for userCompany in userCompanies {
            if companyName?.lowercased() == userCompany.name.lowercased() {
                companyId = userCompany.id
                continue
            }
        }
        
        companySelectionPresenter.signIn(documentTypeId: documentTypeId, document: document, companyId: companyId)
    }

}
extension CompanySelectionViewController: CompanySelectionViewControllerProtocol {
    func goToPasswordSignIn(_ documentTypeId: Int, _ document: String, _ companyId: String) {
        let passwordScene = Router.shared.getPasswordSignIn(documentTypeId: documentTypeId, document: document, companyId: companyId)
        show(passwordScene, sender: nil)
    }
    
    func goToMain() {
        let mainTabBar = Router.shared.getMainTabBar()
        crossDisolveTransition(to: mainTabBar)
    }
}
