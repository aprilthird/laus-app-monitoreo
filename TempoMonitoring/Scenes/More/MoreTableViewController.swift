//
//  MoreTableViewController.swift
//  TempoMonitoring
//
//  Created by Hugo Andres Rosado on 5/30/20.
//  Copyright © 2020 Sportafolio SAC. All rights reserved.
//

import UIKit

class MoreTableViewController: UITableViewController {

    private var optionReuseIdentifier: String!
    private var headerReuseIdentifier: String!
    private var headerView: MoreHeaderView!
    private var options: [(image: UIImage, type: MoreOptionType, title: String)]!
    var morePresenter: MorePresenterProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = Constants.Localizable.MORE_TITLE
        
        optionReuseIdentifier = MoreTableViewCell.reuseIdentifier
        headerReuseIdentifier = MoreHeaderView.reuseIdentifier
        headerView = MoreHeaderView.get(owner: self)
        headerView.frame = CGRect(origin: .zero, size: CGSize(width: tableView.bounds.width, height: 200))
        headerView.imageOptions = morePresenter.getImageOptions()
        options = morePresenter.loadOptions()
        
        tableView.register(MoreTableViewCell.getNIB(), forCellReuseIdentifier: optionReuseIdentifier)
        
        let view = UIView(frame: headerView.frame)
        view.addSubview(headerView)
        tableView.tableHeaderView = view
        tableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.navigationBar.topItem?.backBarButtonItem = nil
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        headerView.backgroundColor = morePresenter.getBackgroundColor()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: optionReuseIdentifier, for: indexPath) as! MoreTableViewCell
        cell.option = options[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        morePresenter.didSelect(option: options[indexPath.row])
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
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
extension MoreTableViewController: MoreTableViewControllerProtocol {
    func goToFirstScene() {
        let firstScene = Router.shared.getFirstScene()
        let navigationController = Router.shared.getTempoNavigationController(firstScene)
        crossDisolveTransition(to: navigationController)
    }
    
    func open(_ url: String) {
        guard let url = URL(string: url) else {
            return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}
