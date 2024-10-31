//
//  FriendInviteViewController.swift
//  CubeTest
//
//  Created by 季紅 on 2024/10/25.
//

import UIKit

class FriendInviteViewController: BaseSegmentedContentViewController {
    private lazy var dataSource = makeDataSource()

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewlayout)
        collectionView.register(cellWithClass: FriendInviteCollectionViewCell.self)
        return collectionView
    }()

    private lazy var collectionViewlayout: UICollectionViewLayout = {
        UICollectionViewCompositionalLayout { [unowned self] index, enviroment in
            let section = Section(rawValue: index) ?? .main
            let layout = generateLayoutSection(sectionType: section)
            return layout
        }
    }()
    
    private let viewModel: FriendViewModel
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
    }
    
    override func setupUI() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints({
            $0.edges.equalToSuperview()
        })
    }

}

private extension FriendInviteViewController {
    func binding() {
        viewModel
            .$invitedFriendsResponse
            .dropFirst()
            .sink { [weak self] response in
                self?.configureDataSource(model: response)
            }
            .store(in: &cancellables)
    }
}

private extension FriendInviteViewController {
    func generateLayoutSection(sectionType: Section) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(120)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(120)
        )
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 25, leading: 30, bottom: 15, trailing: 30)
        section.interGroupSpacing = 10
   
        return section
    }

    func makeDataSource() -> UICollectionViewDiffableDataSource<Section, FriendInviteCollectionViewData> {
        return UICollectionViewDiffableDataSource(collectionView: collectionView) {
            collectionView, indexPath, item in
            let cell = collectionView.dequeueReusableCell(withClass: FriendInviteCollectionViewCell.self, for: indexPath)
            cell.configure(viewData: item)
            return cell
        }
    }

    func configureDataSource(model: [FriendListResponse]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, FriendInviteCollectionViewData>()
        snapshot.appendSections(Section.allCases)

        let items = model.map({FriendInviteCollectionViewData(model: $0)})
        snapshot.appendItems(items)

        dataSource.apply(snapshot, animatingDifferences: false)
    }
}

extension FriendInviteViewController {
    enum Section: Int, CaseIterable {
        case main
    }
}

