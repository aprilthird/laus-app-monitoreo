//
//  TipsCollectionViewController.swift
//  TempoMonitoring
//
//  Created by Hugo Andres Rosado on 5/31/20.
//  Copyright © 2020 Sportafolio SAC. All rights reserved.
//

import UIKit

class TipsCollectionViewController: UICollectionViewController {

    private var tipReuseIdentifier: String!
    private var headerReuseIdentifier: String!
    private var tips: [(imageUrl: String, name: String, url: String)]!
    var tipsPresenter: TipsPresenterProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = Constants.Localizable.TIPS_TITLE
        
        tipReuseIdentifier = TipCollectionViewCell.reuseIdentifier
        headerReuseIdentifier = TipsHeaderCollectionReusableView.reuseIdentifier
        tips = []
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 10
        flowLayout.minimumInteritemSpacing = 10
        flowLayout.sectionInset = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
        collectionView.collectionViewLayout = flowLayout
        
        collectionView.register(TipCollectionViewCell.getNIB(), forCellWithReuseIdentifier: tipReuseIdentifier)
        collectionView.register(TipsHeaderCollectionReusableView.getNIB(), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerReuseIdentifier)
        
        tipsPresenter.loadTips()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tips.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: tipReuseIdentifier, for: indexPath) as! TipCollectionViewCell
        cell.tip = tips[indexPath.row]
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        tipsPresenter.didSelect(tip: tips[indexPath.row])
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerReuseIdentifier, for: indexPath) as! TipsHeaderCollectionReusableView
            headerView.options = tipsPresenter.getHeaderOptions()
            return headerView
        default:
            return UICollectionReusableView()
        }
    }

}
extension TipsCollectionViewController: TipsCollectionViewControllerProtocol {
    func openWebView(_ url: String) {
        let mainWebView = Router.shared.getMainWebView(title: Constants.Localizable.NOTE_TITLE, url: url)
        mainWebView.hidesBottomBarWhenPushed = true
        show(mainWebView, sender: nil)
    }
    
    func updateTips(_ tips: [(imageUrl: String, name: String, url: String)]) {
        self.tips = tips
        collectionView.reloadData()
    }
}
extension TipsCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width - 20, height: 150)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 200)
    }
}
