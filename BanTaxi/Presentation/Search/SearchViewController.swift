//
//  SearchViewController.swift
//  BanTaxi
//
//  Created by 엄태양 on 2023/02/27.
//

import Foundation
import RxSwift
import RxCocoa
import SnapKit
import NVActivityIndicatorView

class SearchViewController: UIViewController {
    private let disposeBag = DisposeBag()
    private let viewModel: SearchViewModel
    
    private let activityIndicator = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: K.ScreenSize.width, height: K.ScreenSize.height), type: .circleStrokeSpin, color: K.Color.mainColor, padding: 200)
    
    private let modeButtonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 0
        return stackView
    }()
    
    private let titleModeButton: UIButton = {
        let button = UIButton()
        button.setTitle("그룹명 검색", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        return button
    }()
    
    private let locationModeButton: UIButton = {
        let button = UIButton()
        button.setTitle("위치 검색", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        return button
    }()
    
    private let divider: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    
    private let titleUnderLine: UIView = {
        let view = UIView()
        view.backgroundColor = K.Color.mainColor
        return view
    }()
    private let locationUnderLine: UIView = {
        let view = UIView()
        view.backgroundColor = K.Color.mainColor
        return view
    }()
    
    private let titleModeView = UIView()
    private let locationModeView = UIView()
    
    private let titleSearchView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 20
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowRadius = 10
        view.layer.shadowOffset = CGSize.zero
        view.layer.masksToBounds = false
        return view
    }()
    
    private let titleSearchBarStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fillProportionally
        stackView.spacing = 5
        return stackView
    }()
    
    private let titleSearchImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "magnifyingglass"))
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = K.Color.mainColor
        return imageView
    }()
    
    private let titleSearchTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "그룹명을 입력해주세요."
        return textField
    }()
    
    private let titleSearchTableView = UITableView()

    private let locationSearchView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.95, alpha: 1)
        view.layer.cornerRadius = 15
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.2
        view.layer.shadowRadius = 15
        view.layer.shadowOffset = CGSize.zero
        view.layer.masksToBounds = false
        return view
    }()
    
    private let currentLocationStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fillProportionally
        stackView.spacing = 20
        return stackView
    }()
    
    private let currentLocationImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "location.circle"))
        imageView.tintColor = UIColor(named: "MainColor")
        return imageView
    }()
    private let currentLocationLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = .black
        return label
    }()
    private let locationButtonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 15
        return stackView
    }()
    
    private let mapSearchButton: UIButton = {
        let button = UIButton()
        button.setTitle("지도에서 설정", for: .normal)
        button.setImage(UIImage(systemName: "map"), for: .normal)
        button.backgroundColor = .white
        button.setTitleColor(UIColor(named: "MainColor"), for: .normal)
        button.layer.borderColor = UIColor(named: "MainColor")?.cgColor
        button.tintColor = UIColor(named: "MainColor")
        button.layer.borderWidth = 1
        button.titleLabel?.font = .systemFont(ofSize: 15, weight: .semibold)
        button.layer.cornerRadius = 5
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        return button
    }()
    
    private let addressSearchButton: UIButton = {
        let button = UIButton()
        button.setTitle("주소로 검색", for: .normal)
        button.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        button.backgroundColor = .white
        button.setTitleColor(UIColor(named: "MainColor"), for: .normal)
        button.layer.borderColor = UIColor(named: "MainColor")?.cgColor
        button.tintColor = UIColor(named: "MainColor")
        button.layer.borderWidth = 1
        button.titleLabel?.font = .systemFont(ofSize: 15, weight: .semibold)
        button.layer.cornerRadius = 5
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        return button
    }()
    
    private let searchModeButtonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 15
        return stackView
    }()
    private let startingPointButton: UIButton = {
        let button = UIButton()
        button.setTitle("시작점으로 검색", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(named: "MainColor")
        button.layer.cornerRadius = 5
        button.titleLabel?.font = .systemFont(ofSize: 15, weight: .semibold)
        return button
    }()
    
    private let destinationButton: UIButton = {
        let button = UIButton()
        button.setTitle("도착점으로 검색", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(named: "MainColor")
        button.layer.cornerRadius = 5
        button.titleLabel?.font = .systemFont(ofSize: 15, weight: .semibold)
        return button
    }()
    
    private let locationSearchTableView = UITableView()
    
    init(viewModel: SearchViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        
        titleSearchTableView.register(GroupListCellViewController.self, forCellReuseIdentifier: K.TableViewCellID.GroupListCell)
        locationSearchTableView.register(GroupListCellViewController.self, forCellReuseIdentifier: K.TableViewCellID.GroupListCell)
        
        bind()
        attribute()
        layout()
    }
    
    private func bind() {
        
        let selectedAddress = BehaviorSubject<AddressData?>(value: nil)
        
        
        let input = SearchViewModel.Input(keyword: titleSearchTextField.rx.text.orEmpty.asDriver(),
                                          address: selectedAddress.asDriver(onErrorJustReturn: nil),
                                          modeTrigger: Driver.merge(titleModeButton.rx.tap.map { SearchMode.groupName }.asDriver(onErrorJustReturn: .groupName),
                                                                    locationModeButton.rx.tap.map { SearchMode.location }.asDriver(onErrorJustReturn: .location)),
                                          groupNameSearchTrigger: titleSearchTextField.rx.controlEvent(.editingDidEndOnExit).asDriver(),
                                          locationSearchTrigger: Driver.merge(startingPointButton.rx.tap.map { LocationSearchType.starting}.asDriver(onErrorJustReturn: .starting),
                                                                              destinationButton.rx.tap.map { LocationSearchType.destination}.asDriver(onErrorJustReturn: .destination)),
                                          selectGroupName: titleSearchTableView.rx.itemSelected.asDriver().do(onNext: {[weak self] indexPath in self?.titleSearchTableView.cellForRow(at: indexPath)?.isSelected = false}),
                                          selectLocation: locationSearchTableView.rx.itemSelected.asDriver().do(onNext: {[weak self] indexPath in self?.locationSearchTableView.cellForRow(at: indexPath)?.isSelected = false}))
        
        let output = viewModel.transform(input: input)
        
        output.loading
            .drive(onNext: { [weak self] loading in
                if loading {
                    self?.activityIndicator.startAnimating()
                    self?.activityIndicator.isHidden = false
                } else {
                    self?.activityIndicator.stopAnimating()
                    self?.activityIndicator.isHidden = true
                }
            })
            .disposed(by: disposeBag)
        
        output.mode
            .drive(onNext: { mode in
                if mode == .groupName {
                    self.titleModeView.isHidden = false
                    self.titleModeButton.setTitleColor(K.Color.mainColor, for: .normal)
                    self.titleUnderLine.isHidden = false
                    self.locationModeView.isHidden = true
                    self.locationModeButton.setTitleColor(.gray, for: .normal)
                    self.locationUnderLine.isHidden = true
                } else if mode == .location {
                    self.titleModeView.isHidden = true
                    self.titleModeButton.setTitleColor(.gray, for: .normal)
                    self.titleUnderLine.isHidden = true
                    self.locationModeView.isHidden = false
                    self.locationModeButton.setTitleColor(K.Color.mainColor, for: .normal)
                    self.locationUnderLine.isHidden = false
                }
            })
            .disposed(by: disposeBag)
        
        output.titleSearchList
            .drive(titleSearchTableView.rx.items) { tv, row, groupInfo in
                let cell = tv.dequeueReusableCell(withIdentifier: K.TableViewCellID.GroupListCell, for: IndexPath(row: row, section: 0)) as! GroupListCellViewController
                cell.setUp(with: groupInfo)
                return cell
            }
            .disposed(by: disposeBag)
        
        output.locationSearchList
            .drive(locationSearchTableView.rx.items) { tv, row, groupInfo in
                let cell = tv.dequeueReusableCell(withIdentifier: K.TableViewCellID.GroupListCell, for: IndexPath(row: row, section: 0)) as! GroupListCellViewController
                cell.setUp(with: groupInfo)
                return cell
            }
            .disposed(by: disposeBag)
        
        output.selectedGroup
            .drive(onNext: { [weak self] groupInfo in
                self?.navigationController?.pushViewController(GroupDetailViewController(with: groupInfo), animated: true)
            })
            .disposed(by: disposeBag)
        
        selectedAddress
            .asDriver(onErrorJustReturn: nil)
            .map { $0?.roadAddress ?? "설정된 위치가 없습니다."}
            .drive(currentLocationLabel.rx.text)
            .disposed(by: disposeBag)
        
        mapSearchButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] in
                guard let self = self else { return }
                self.navigationController?.pushViewController(LocationSelectViewController(viewModel: LocationSelectViewModel(mode: .Default, select: selectedAddress)), animated: true)
            })
            .disposed(by: disposeBag)
        
        addressSearchButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] in
                guard let self = self else { return }
                self.navigationController?.pushViewController(AddressSearchViewController(viewModel: AddressSearchViewModel(mode: .Default, select: selectedAddress)), animated: true)
            })
            .disposed(by: disposeBag)
        
    }
    
    private func attribute() {
        
        view.addTapGesture(cancelsTouchesInViewOption: false)
        
        // Initialize
        self.navigationController?.navigationBar.topItem?.title = " "
        view.backgroundColor = .white

    }
    
    private func layout() {
        // Common
        [modeButtonStackView, divider, titleUnderLine, locationUnderLine, titleModeView, locationModeView, activityIndicator].forEach { view.addSubview($0) }
        [titleModeButton, locationModeButton].forEach { modeButtonStackView.addArrangedSubview($0) }
        
        //TitleMode
        [titleSearchView, titleSearchTableView].forEach { titleModeView.addSubview($0) }
        titleSearchView.addSubview(titleSearchBarStackView)
        [titleSearchImageView, titleSearchTextField].forEach { titleSearchBarStackView.addArrangedSubview($0) }
        
        
        //LocationMode
        [locationSearchView, locationSearchTableView].forEach { locationModeView.addSubview($0) }
        [currentLocationStackView, locationButtonStackView, searchModeButtonStackView].forEach { locationSearchView.addSubview($0)}
        [currentLocationImageView, currentLocationLabel].forEach { currentLocationStackView.addArrangedSubview($0) }
        [mapSearchButton, addressSearchButton].forEach { locationButtonStackView.addArrangedSubview($0) }
        [startingPointButton, destinationButton].forEach { searchModeButtonStackView.addArrangedSubview($0) }
        
        
        //Common
        modeButtonStackView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.equalToSuperview()
        }
        
        divider.snp.makeConstraints {
            $0.top.equalTo(modeButtonStackView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        titleUnderLine.snp.makeConstraints {
            $0.top.equalTo(modeButtonStackView.snp.bottom)
            $0.leading.trailing.equalTo(titleModeButton)
            $0.height.equalTo(2)
        }
        
        locationUnderLine.snp.makeConstraints {
            $0.top.equalTo(modeButtonStackView.snp.bottom)
            $0.leading.trailing.equalTo(locationModeButton)
            $0.height.equalTo(2)
        }
        
        titleModeView.snp.makeConstraints{
            $0.top.equalTo(modeButtonStackView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        
        locationModeView.snp.makeConstraints{
            $0.top.equalTo(modeButtonStackView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        
        // Title Mode
        
        titleSearchView.snp.makeConstraints {
            $0.top.equalTo(modeButtonStackView.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(10)
            $0.trailing.equalToSuperview().offset(-10)
            $0.height.equalTo(40)
        }
        
        titleSearchBarStackView.snp.makeConstraints{
            $0.top.bottom.equalToSuperview()
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
        }
        
        
        titleSearchTableView.snp.makeConstraints {
            $0.top.equalTo(titleSearchBarStackView.snp.bottom).offset(15)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        //Location Mode
        
        locationSearchView.snp.makeConstraints {
            $0.top.equalTo(locationModeView.snp.top).offset(15)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.bottom.equalTo(searchModeButtonStackView.snp.bottom).offset(15)
        }
        
        currentLocationStackView.snp.makeConstraints {
            $0.top.equalTo(locationSearchView.snp.top).offset(15)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.height.equalTo(30)
        }
        
        currentLocationImageView.snp.makeConstraints {
            $0.width.equalTo(30)
        }
        
        locationButtonStackView.snp.makeConstraints {
            $0.top.equalTo(currentLocationStackView.snp.bottom).offset(10)
            $0.leading.trailing.equalTo(currentLocationStackView)
            $0.height.equalTo(30)
        }
        
        searchModeButtonStackView.snp.makeConstraints{
            $0.top.equalTo(locationButtonStackView.snp.bottom).offset(20)
            $0.leading.trailing.equalTo(locationButtonStackView)
            $0.height.equalTo(40)
        }
        
        locationSearchTableView.snp.makeConstraints {
            $0.top.equalTo(locationSearchView.snp.bottom).offset(15)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
}
