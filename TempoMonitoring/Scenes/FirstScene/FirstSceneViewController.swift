//
//  FirstSceneViewController.swift
//  TempoMonitoring
//
//  Created by Hugo Andres Rosado on 5/30/20.
//  Copyright © 2020 Sportafolio SAC. All rights reserved.
//

import UIKit

class FirstSceneViewController: UIViewController {

    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var contactUsView: UIView!
    @IBOutlet weak var contactUsLabel: UILabel!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var contactUsButton: UIButton!
    @IBOutlet weak var mainButton: UIButton!
    private var shouldSignUpUser: Bool?
    private var signUpUrl: String?
    var firstScenePresenter: FirstScenePresenterProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard shouldSignUpUser == nil else {
            signUpButton.isHidden = !shouldSignUpUser!
            return
        }
        
        signUpButton.isHidden = true
        firstScenePresenter.didLoadSignUpLogic()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        navigationController?.navigationBar.shadowImage = nil
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        backgroundImageView.layer.opacity = 0.4
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
    
    @IBAction func didShowSignIn(_ sender: UIButton) {
        let signIn = Router.shared.getSignIn(shouldSignUpUser: shouldSignUpUser, signUpUrl: signUpUrl)
        show(signIn, sender: nil)
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
extension FirstSceneViewController: FirstSceneViewControllerProtocol {
    func updateView(url: String, visibility: Bool) {
        signUpUrl = url
        shouldSignUpUser = visibility
        signUpButton.isHidden = !visibility
        signUpButton.layoutIfNeeded()
    }
}
