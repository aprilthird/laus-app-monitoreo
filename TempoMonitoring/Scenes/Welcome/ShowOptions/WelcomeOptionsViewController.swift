//
//  WelcomeOptionsViewController.swift
//  TempoMonitoring
//
//  Created by Hugo Andres on 20/02/21.
//  Copyright © 2021 Sportafolio SAC. All rights reserved.
//

import UIKit

class WelcomeOptionsViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    private var options: [(text: String, imageUrl: String, openUrl: String)]?
    private var numberOfColumns: CGFloat!
    var presenter: WelcomeOptionsPresenterProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        numberOfColumns = 2.0
        
        navigationItem.title = Constants.Localizable.HOME_TITLE
        
        collectionView.delegate = self
        collectionView.dataSource = self
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets(top: 15.0, left: 30.0, bottom: 25.0, right: 30.0)
        flowLayout.minimumInteritemSpacing = 50.0
        flowLayout.minimumLineSpacing = 25.0
        let availableWidth = UIScreen.main.bounds.width - flowLayout.sectionInset.left - flowLayout.sectionInset.right - ((numberOfColumns - 1) * flowLayout.minimumInteritemSpacing)
        let size = (availableWidth / numberOfColumns).rounded(.towardZero)
        flowLayout.itemSize = CGSize(width: size, height: size)
        collectionView.collectionViewLayout = flowLayout
        
        collectionView.register(WelcomeOptionCollectionViewCell.getNIB(), forCellWithReuseIdentifier: WelcomeOptionCollectionViewCell.reuseIdentifier)
        collectionView.register(WelcomeOptionHeaderCollectionReusableView.getNIB(), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: WelcomeOptionHeaderCollectionReusableView.reuseIdentifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        presenter.loadOptions()
        navigationItem.setRightBarButtonItems(presenter.getRightNavigationItems(), animated: true)
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: UICollectionViewDelegate && UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return options?.count ?? 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WelcomeOptionCollectionViewCell.reuseIdentifier, for: indexPath) as! WelcomeOptionCollectionViewCell
        cell.color = presenter.getPrimaryColor()
        guard let option = options?[indexPath.row] else {
            return cell
        }
        cell.option = (option.text, option.imageUrl)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        guard let option = options?[indexPath.row] else { return }
        let webView = Router.shared.getMainWebView(title: option.text.capitalized, url: option.openUrl)
        webView.hidesBottomBarWhenPushed = true
        show(webView, sender: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: WelcomeOptionHeaderCollectionReusableView.reuseIdentifier, for: indexPath) as! WelcomeOptionHeaderCollectionReusableView
            header.option = presenter.getHeaderOptions()
            return header
        default:
            return UICollectionReusableView()
        }
    }
    
    // MARK: UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: WelcomeOptionHeaderCollectionReusableView.reuseIdentifier, for: IndexPath(row: 0, section: section)) as! WelcomeOptionHeaderCollectionReusableView
        let size = header.systemLayoutSizeFitting(CGSize(width: UIScreen.main.bounds.width, height: UIView.layoutFittingCompressedSize.height), withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
        return CGSize(width: UIScreen.main.bounds.width, height: size.height)
    }

}
extension WelcomeOptionsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {}
extension WelcomeOptionsViewController: WelcomeOptionsViewControllerProtocol {
    func showQRCodeReader() {
        let qrCodeReader = Router.shared.getQRCodeReader()
        qrCodeReader.hidesBottomBarWhenPushed = true
        show(qrCodeReader, sender: nil)
    }
    
    func updateOptions(_ options: [(String, String, String)]) {
        self.options = options
        collectionView.reloadData()
    }
}
