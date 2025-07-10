//
//  FriendListViewController.swift
//  CubeTest
//
//  Created by 季紅 on 2024/10/25.
//

import Foundation
import UIKit

protocol FriendListViewDelegate: AnyObject {
    func searchBarDidBeginEditing()
    func didchangeSearchText(_ text: String)
}

class FriendListViewController: BaseSegmentedContentViewController, Refreshable {
    weak var delegate: FriendListViewDelegate?
    
    var refreshAdaptor: RefreshAdaptor?
    private lazy var dataSource = makeDataSource()

    private let viewModel: FriendViewModel

    private lazy var friendSearchView: FriendSearchView = {
        let view = FriendSearchView()
        view.delegate = self
        return view
    }()

    private let addFriendView: AddFriendView = {
        let view = AddFriendView()
        return view
    }()

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewlayout)
        collectionView.register(cellWithClass: FriendListCollectionViewCell.self)
        return collectionView
    }()

    private lazy var collectionViewlayout: UICollectionViewLayout = UICollectionViewCompositionalLayout { [unowned self] index, _ in
        let section = Section(rawValue: index) ?? .main
        let layout = generateLayoutSection(sectionType: section)
        return layout
    }

    init(viewModel: FriendViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        binding()
        refreshAdaptor = RefreshAdaptor(targetView: collectionView, delegate: self)
        refreshAdaptor?.refresh()
    }

    override func setupUI() {
        view.addSubviews([friendSearchView, collectionView])
        friendSearchView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(15).priority(.low)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(36)
        }
        collectionView.snp.makeConstraints {
            $0.top.equalTo(friendSearchView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
}

private extension FriendListViewController {
    func binding() {
        viewModel.$friendListResponse
            .dropFirst()
            .sink { [weak self] response in
                self?.toggleAddFriendView(isEmpty: response.isEmpty)
                self?.configureDataSource(model: response)
            }
            .store(in: &cancellables)
        
        viewModel.$searchResults
            .dropFirst()
            .sink { [weak self] results in
                self?.configureDataSource(model: results)
            }
            .store(in: &cancellables)
    }
}

private extension FriendListViewController {
    func generateLayoutSection(sectionType _: Section) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(120))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(120))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20)

        return section
    }

    func makeDataSource() -> UICollectionViewDiffableDataSource<Section, FriendListCollectionViewData> {
        return UICollectionViewDiffableDataSource(collectionView: collectionView) {
            collectionView, indexPath, item in
            let cell = collectionView.dequeueReusableCell(withClass: FriendListCollectionViewCell.self, for: indexPath)
            cell.configure(viewData: item)
            return cell
        }
    }

    func configureDataSource(model: [FriendListResponse]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, FriendListCollectionViewData>()
        snapshot.appendSections(Section.allCases)

        let items = model.map { FriendListCollectionViewData(model: $0) }
        snapshot.appendItems(items)

        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    func toggleAddFriendView(isEmpty: Bool) {
        guard let targetView = viewModel.rootType == .noFriend ? self.view : collectionView else { return }
        isEmpty ? addFriendView.show(targetView: targetView) : addFriendView.remove()
    }
}

extension FriendListViewController {
    enum Section: Int, CaseIterable {
        case main
    }
}

extension FriendListViewController: RefreshAdaptorDelegate {
    func refreshAdaptorWillRefresh() {
        viewModel.fetchFriendListBasedOnRootType()
    }
}

extension FriendListViewController: FriendSearchViewDelegate {
    func didChangeSearchText(_ text: String) {
        viewModel.performSearch(text: text)
        delegate?.didchangeSearchText(text)
    }
    
    func searchBarDidBeginEditing() {
        delegate?.searchBarDidBeginEditing()
    }
}
