//
//  ContactUsPopupViewController.swift
//  TempoMonitoring
//
//  Created by Hugo Andres Rosado on 5/30/20.
//  Copyright © 2020 Sportafolio SAC. All rights reserved.
//

import UIKit

class ContactUsPopupViewController: UIViewController {

    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var namesView: UIView!
    @IBOutlet weak var namesLabel: UILabel!
    @IBOutlet weak var namesTextField: UITextField!
    @IBOutlet weak var lastNamesView: UIView!
    @IBOutlet weak var lastNamesLabel: UILabel!
    @IBOutlet weak var lastNamesTextField: UITextField!
    @IBOutlet weak var companyView: UIView!
    @IBOutlet weak var companyLabel: UILabel!
    @IBOutlet weak var companyTextField: UITextField!
    @IBOutlet weak var documentTypeView: UIView!
    @IBOutlet weak var documentTypeLabel: UILabel!
    @IBOutlet weak var documentTypeTextField: UITextField!
    @IBOutlet weak var documentView: UIView!
    @IBOutlet weak var documentLabel: UILabel!
    @IBOutlet weak var documentTextField: UITextField!
    @IBOutlet weak var phoneView: UIView!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var descriptionView: UIView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var sendButton: UIButton!
    private var bottomViewColor: UIColor?
    private var bottomViewTag: Int!
    var contactUsPresenter: ContactUsPopupPresenterProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        bottomViewColor = UIColor("#D3D8DD")
        bottomViewTag = 10
        backgroundView.alpha = 0.5
        
        [namesTextField, lastNamesTextField, companyTextField, documentTypeTextField, documentTextField, phoneTextField, descriptionTextView.textInputView].forEach { (view) in
            let padding: CGFloat = 0
            let heightBottomView = UIView(frame: .zero)
            heightBottomView.backgroundColor = bottomViewColor
            heightBottomView.translatesAutoresizingMaskIntoConstraints = false
            heightBottomView.tag = 10
            (view as? UITextField)?.delegate = self
            view?.addSubview(heightBottomView)
            
            NSLayoutConstraint.activate([
                heightBottomView.leadingAnchor.constraint(equalTo: view!.leadingAnchor, constant: -padding),
                heightBottomView.trailingAnchor.constraint(equalTo: view!.trailingAnchor, constant: padding),
                heightBottomView.bottomAnchor.constraint(equalTo: view!.bottomAnchor, constant: -3),
                heightBottomView.heightAnchor.constraint(equalToConstant: 1)
            ])
        }
        
        documentTypeTextField.loadDocumentTypes()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        scrollView.layer.cornerRadius = scrollView.bounds.width / 30
        sendButton.layer.cornerRadius = sendButton.bounds.height / 2
    }

    @IBAction func didCloseView(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didSendInformation(_ sender: UIButton) {
        var isValid: Bool = true
        [namesTextField, lastNamesTextField, companyTextField, documentTypeTextField, documentTextField, phoneTextField].forEach { (textField) in
            let color = (!textField!.isTextValid) ? .red : bottomViewColor
            textField?.subviews.first(where: { (view) -> Bool in
                view.tag == bottomViewTag
            })?.backgroundColor = color
            guard textField!.isTextValid else {
                isValid = false
                return
            }
        }
        [descriptionTextView].forEach { (textView) in
            let color = (textView!.text.isEmpty) ? .red : bottomViewColor
            textView?.textInputView.subviews.first(where: { (view) -> Bool in
                view.tag == bottomViewTag
            })?.backgroundColor = color
            guard !textView!.text.isEmpty else {
                isValid = false
                return
            }
        }
        guard isValid, let documentTypeId = documentTypeTextField.documentTypeId else {
            return
        }
        contactUsPresenter.sendInformation(names: namesTextField.text!, lastNames: lastNamesTextField.text!, company: companyTextField.text!, documentTypeId: documentTypeId, document: documentTextField.text!, phone: phoneTextField.text!, description: descriptionTextView.text) {
            self.dismiss(animated: true, completion: nil)
        }
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
extension ContactUsPopupViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField {
        case documentTextField:
            textField.keyboardType = contactUsPresenter.validateKeyboard(text: documentTypeTextField.text)
        default:
            break
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let color: UIColor? = (textField.isTextValid) ? bottomViewColor : .red
        textField.subviews.first(where: { (view) -> Bool in
            view.tag == bottomViewTag
        })?.backgroundColor = color
    }
}
extension ContactUsPopupViewController: ContactUsPopupViewControllerProtocol {
}
