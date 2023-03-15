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
    let disposeBag = DisposeBag()
    let viewModel: SearchViewModel!
    
    let activityIndicator = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: K.ScreenSize.width, height: K.ScreenSize.height), type: .circleStrokeSpin, color: K.Color.mainColor, padding: 200)
    
    let modeButtonStackView = UIStackView()
    let titleModeButton = UIButton()
    let locationModeButton = UIButton()
    let divider = UIView()
    let titleUnderLine = UIView()
    let locationUnderLine = UIView()
    
    let titleModeView = UIView()
    let locationModeView = UIView()
    
    let titleSearchView = UIView()
    let titleSearchBarStackView = UIStackView()
    let titleSearchImageView = UIImageView(image: UIImage(systemName: "magnifyingglass"))
    let titleSearchTextField = UITextField()
    let titleSearchTableView = UITableView()

    let locationSearchView = UIView()
    let currentLocationStackView = UIStackView()
    let currentLocationImageView = UIImageView(image: UIImage(systemName: "location.circle"))
    let currentLocationLabel = UILabel()
    let locationButtonStackView = UIStackView()
    let mapSearchButton = UIButton()
    let addressSearchButton = UIButton()
    let searchModeButtonStackView = UIStackView()
    let startingPointButton = UIButton()
    let destinationButton = UIButton()
    let locationSearchTableView = UITableView()
    
    init() {
        viewModel = SearchViewModel()
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
        
        viewModel.isLoading
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { loading in
                if loading {
                    self.activityIndicator.startAnimating()
                    self.activityIndicator.isHidden = false
                } else {
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.isHidden = true
                }
            })
            .disposed(by: disposeBag)
        
        // 그룹명 검색
        
        titleModeButton.rx.tap
            .asDriver()
            .drive(onNext: {
                self.titleModeView.isHidden = false
                self.titleModeButton.setTitleColor(K.Color.mainColor, for: .normal)
                self.titleUnderLine.isHidden = false
                self.locationModeView.isHidden = true
                self.locationModeButton.setTitleColor(.gray, for: .normal)
                self.locationUnderLine.isHidden = true
            })
            .disposed(by: disposeBag)
        
        locationModeButton.rx.tap
            .asDriver()
            .drive(onNext: {
                self.titleModeView.isHidden = true
                self.titleModeButton.setTitleColor(.gray, for: .normal)
                self.titleUnderLine.isHidden = true
                self.locationModeView.isHidden = false
                self.locationModeButton.setTitleColor(K.Color.mainColor, for: .normal)
                self.locationUnderLine.isHidden = false
            })
            .disposed(by: disposeBag)
        
        titleSearchTextField.rx.text
            .orEmpty
            .bind(to: viewModel.keyword)
            .disposed(by: disposeBag)
        
        titleSearchTextField.rx.controlEvent(.editingDidEndOnExit)
            .bind(to: viewModel.titleSearchButtonTap)
            .disposed(by: disposeBag)
        
        viewModel.titleSearchResult
            .bind(to: titleSearchTableView.rx.items) { tv, row, groupInfo in
                let cell = tv.dequeueReusableCell(withIdentifier: K.TableViewCellID.GroupListCell, for: IndexPath(row: row, section: 0)) as! GroupListCellViewController
                cell.setUp(with: groupInfo)
                return cell
            }
            .disposed(by: disposeBag)
        
        titleSearchTableView.rx.itemSelected
            .observe(on: MainScheduler.instance)
            .withLatestFrom(viewModel.titleSearchResult) { indexPath, list in
                return (indexPath, list[indexPath.row])
            }
            .subscribe { (indexPath, groupInfo) in
                self.titleSearchTableView.cellForRow(at: indexPath)?.isSelected = false
                self.navigationController?.pushViewController(GroupDetailViewController(with: groupInfo), animated: true)
            }
            .disposed(by: disposeBag)
            
        
        // 위치 검색
        
        viewModel.targetAddress
            .filter { $0 != nil }
            .map { $0!.roadAddress}
            .bind(to: currentLocationLabel.rx.text)
            .disposed(by: disposeBag)
        
        mapSearchButton.rx.tap
            .asDriver()
            .drive(onNext: {
                self.navigationController?.pushViewController(LocationSelectViewController(mode: .Default, with: self.viewModel.targetAddress), animated: true)
            })
            .disposed(by: disposeBag)
        
        addressSearchButton.rx.tap
            .asDriver()
            .drive(onNext: {
                self.navigationController?.pushViewController(AddressSearchViewController(mode: .Default, with: self.viewModel.targetAddress), animated: true)
            })
            .disposed(by: disposeBag)
        
        startingPointButton.rx.tap
            .bind(to: viewModel.startPointSearchButtonTap)
            .disposed(by: disposeBag)
        
        destinationButton.rx.tap
            .bind(to: viewModel.destinationSearchButtonTap)
            .disposed(by: disposeBag)
        
        viewModel.locationSearchResult
            .bind(to: locationSearchTableView.rx.items) { tv, row, groupInfo in
                let cell = tv.dequeueReusableCell(withIdentifier: K.TableViewCellID.GroupListCell, for: IndexPath(row: row, section: 0)) as! GroupListCellViewController
                cell.setUp(with: groupInfo)
                return cell
            }
            .disposed(by: disposeBag)
        
        locationSearchTableView.rx.itemSelected
            .observe(on: MainScheduler.instance)
            .withLatestFrom(viewModel.locationSearchResult) { indexPath, list in
                return (indexPath, list[indexPath.row])
            }
            .subscribe { (indexPath, groupInfo) in
                self.locationSearchTableView.cellForRow(at: indexPath)?.isSelected = false
                self.navigationController?.pushViewController(GroupDetailViewController(with: groupInfo), animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    private func attribute() {
        
        // Initialize
        self.navigationController?.navigationBar.topItem?.title = " "
        view.backgroundColor = .white
        locationModeView.isHidden = true
        
        divider.backgroundColor = .lightGray
        
        [titleUnderLine, locationUnderLine].forEach {
            $0.backgroundColor = K.Color.mainColor
        }
        
        locationUnderLine.isHidden = true
        
        // Common
        modeButtonStackView.axis = .horizontal
        modeButtonStackView.alignment = .fill
        modeButtonStackView.distribution = .fillEqually
        modeButtonStackView.spacing = 0
        
        titleModeButton.setTitle("그룹명 검색", for: .normal)
        locationModeButton.setTitle("위치 검색", for: .normal)
        
        [titleModeButton, locationModeButton].forEach {
            $0.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        }
        titleModeButton.setTitleColor(UIColor(named: "MainColor"), for: .normal)
        locationModeButton.setTitleColor(.gray, for: .normal)
        
        // Title Mode
        
        titleSearchView.backgroundColor = .white
        titleSearchView.layer.cornerRadius = 20
        titleSearchView.layer.shadowColor = UIColor.black.cgColor
        titleSearchView.layer.shadowOpacity = 0.1
        titleSearchView.layer.shadowRadius = 10
        titleSearchView.layer.shadowOffset = CGSize.zero
        titleSearchView.layer.masksToBounds = false
        
        titleSearchBarStackView.axis = .horizontal
        titleSearchBarStackView.distribution = .fillProportionally
        titleSearchBarStackView.spacing = 5
        
        titleSearchImageView.contentMode = .scaleAspectFit
        titleSearchImageView.tintColor = K.Color.mainColor
        
        titleSearchTextField.placeholder = "그룹명을 입력해주세요."
        
        // Location Mode
        
        locationSearchView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        locationSearchView.layer.cornerRadius = 15
        locationSearchView.layer.shadowColor = UIColor.black.cgColor
        locationSearchView.layer.shadowOpacity = 0.2
        locationSearchView.layer.shadowRadius = 15
        locationSearchView.layer.shadowOffset = CGSize.zero
        locationSearchView.layer.masksToBounds = false
        
        currentLocationStackView.axis = .horizontal
        currentLocationStackView.distribution = .fillProportionally
        currentLocationStackView.spacing = 20
        
        currentLocationImageView.tintColor = UIColor(named: "MainColor")
        
        currentLocationLabel.text = "설정된 위치가 없습니다"
        currentLocationLabel.font = .systemFont(ofSize: 13, weight: .regular)
        currentLocationLabel.textColor = .black
        
        locationButtonStackView.axis = .horizontal
        locationButtonStackView.alignment = .fill
        locationButtonStackView.distribution = .fillEqually
        locationButtonStackView.spacing = 15
        
        [mapSearchButton, addressSearchButton].forEach {
            $0.backgroundColor = .white
            $0.setTitleColor(UIColor(named: "MainColor"), for: .normal)
            $0.layer.borderColor = UIColor(named: "MainColor")?.cgColor
            $0.tintColor = UIColor(named: "MainColor")
            $0.layer.borderWidth = 1
            $0.titleLabel?.font = .systemFont(ofSize: 15, weight: .semibold)
            $0.layer.cornerRadius = 5
            $0.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10);
            $0.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0);
        }
        
        mapSearchButton.setTitle("지도에서 설정", for: .normal)
        mapSearchButton.setImage(UIImage(systemName: "map"), for: .normal)
        
        addressSearchButton.setTitle("주소로 검색", for: .normal)
        addressSearchButton.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        
        searchModeButtonStackView.axis = .horizontal
        searchModeButtonStackView.alignment = .fill
        searchModeButtonStackView.distribution = .fillEqually
        searchModeButtonStackView.spacing = 15
        
        [startingPointButton, destinationButton].forEach {
            $0.setTitleColor(.white, for: .normal)
            $0.backgroundColor = UIColor(named: "MainColor")
            $0.layer.cornerRadius = 5
            $0.titleLabel?.font = .systemFont(ofSize: 15, weight: .semibold)
        }
        
        startingPointButton.setTitle("시작점으로 검색", for: .normal)
        destinationButton.setTitle("도착점으로 검색", for: .normal)

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
            $0.height.equalTo(40)
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
        
        titleSearchImageView.snp.makeConstraints {
            $0.height.width.equalTo(25)
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
