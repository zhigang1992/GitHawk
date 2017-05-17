//
//  SettingsViewController.swift
//  Freetime
//
//  Created by Ryan Nystrom on 5/15/17.
//  Copyright © 2017 Ryan Nystrom. All rights reserved.
//

import UIKit
import SnapKit
import IGListKit

final class SettingsViewController: UIViewController {

    let sessionManager: GithubSessionManager
    lazy var adapter: IGListAdapter = { IGListAdapter(updater: IGListAdapterUpdater(), viewController: self) }()
    lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        view.alwaysBounceVertical = true
        view.backgroundColor = Styles.Colors.background
        return view
    }()

    init(
        sessionManager: GithubSessionManager
        ) {
        self.sessionManager = sessionManager
        super.init(nibName: nil, bundle: nil)
        sessionManager.addListener(listener: self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        adapter.dataSource = self
        adapter.collectionView = collectionView

        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
    }

}

extension SettingsViewController: IGListAdapterDataSource {

    func objects(for listAdapter: IGListAdapter) -> [IGListDiffable] {
        return [sessionManager]
    }

    func listAdapter(_ listAdapter: IGListAdapter, sectionControllerFor object: Any) -> IGListSectionController {
        return SettingsUsersSectionController()
    }

    func emptyView(for listAdapter: IGListAdapter) -> UIView? { return nil }

}

extension SettingsViewController: GithubSessionListener {

    func didFocus(manager: GithubSessionManager, userSession: GithubUserSession) {
        adapter.performUpdates(animated: false)
    }

    func didRemove(manager: GithubSessionManager, userSessions: [GithubUserSession], result: GithubSessionResult) {
        adapter.performUpdates(animated: false)
    }

}