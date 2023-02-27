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

class SearchViewController: UIViewController {
    let disposeBag = DisposeBag()
    let viewModel: SearchViewModel!
    
    let modeButtonStackView = UIStackView()
    let titleModeButton = UIButton()
    let locationModeButton = UIButton()
    
    let titleModeView = UIView()
    let locationModeView = UIView()
    
    let titleSearchBarStackView = UIStackView()
    let titleSearchTextField = UITextField()
    let titleSearchButton = UIButton()
    let titleSearchTableView = UITableView()

    let searchView = UIView()
    let currentLocationStackView = UIStackView()
    let currentLocationImageView = UIImageView(image: UIImage(systemName: "location.circle"))
    let currentLocationLabel = UILabel()
    let locationButtonStackView = UIStackView()
    let mapSearchButton = UIButton()
    let addressSearchButton = UIButton()
    let searchModeButtonStackView = UIStackView()
    let startingPointButton = UIButton()
    let destinationButton = UIButton()
    let locationTableView = UITableView()
    
    init() {
        viewModel = SearchViewModel()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        bind()
        attribute()
        layout()
    }
    
    private func bind() {
        titleModeButton.rx.tap
            .asDriver()
            .drive(onNext: {
                self.titleModeView.isHidden = false
                self.locationModeView.isHidden = true
            })
            .disposed(by: disposeBag)
        
        locationModeButton.rx.tap
            .asDriver()
            .drive(onNext: {
                self.titleModeView.isHidden = true
                self.locationModeView.isHidden = false
            })
            .disposed(by: disposeBag)
        
    }
    
    private func attribute() {
        
        // Initialize
        self.navigationController?.navigationBar.topItem?.title = " "
        view.backgroundColor = .white
        locationModeView.isHidden = true
        
        // Common
        modeButtonStackView.axis = .horizontal
        modeButtonStackView.alignment = .fill
        modeButtonStackView.distribution = .fillEqually
        modeButtonStackView.spacing = 0
        
        titleModeButton.setTitle("그룹명 검색", for: .normal)
        locationModeButton.setTitle("위치 검색", for: .normal)
        
        [titleModeButton, locationModeButton].forEach {
            $0.setTitleColor(UIColor(named: "MainColor"), for: .normal)
            $0.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        }
        
        // Title Mode
        titleSearchBarStackView.axis = .horizontal
        titleSearchBarStackView.alignment = .fill
        titleSearchBarStackView.distribution = .fillProportionally
        titleSearchBarStackView.spacing = 5
        
        titleSearchButton.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        titleSearchButton.tintColor = .white
        titleSearchButton.backgroundColor = UIColor(named: "MainColor")
        titleSearchButton.layer.cornerRadius = 10
        
        titleSearchTextField.layer.cornerRadius = 10
        titleSearchTextField.layer.borderColor = UIColor.black.cgColor
        titleSearchTextField.layer.borderWidth = 1
        titleSearchTextField.addLeftPadding()
        titleSearchTextField.placeholder = "그룹명을 입력해주세요."
        
        // Location Mode
        
        searchView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        searchView.layer.cornerRadius = 15
        searchView.layer.shadowColor = UIColor.black.cgColor
        searchView.layer.shadowOpacity = 0.2
        searchView.layer.shadowRadius = 15
        searchView.layer.shadowOffset = CGSize.zero
        searchView.layer.masksToBounds = false
        
        currentLocationStackView.axis = .horizontal
        currentLocationStackView.alignment = .fill
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
        [modeButtonStackView, titleModeView, locationModeView].forEach { view.addSubview($0) }
        [titleModeButton, locationModeButton].forEach { modeButtonStackView.addArrangedSubview($0) }
        
        //TitleMode
        [titleSearchBarStackView, titleSearchTableView].forEach { titleModeView.addSubview($0) }
        [titleSearchTextField, titleSearchButton].forEach { titleSearchBarStackView.addArrangedSubview($0) }
        
        
        //LocationMode
        [searchView, locationTableView].forEach { locationModeView.addSubview($0) }
        [currentLocationStackView, locationButtonStackView, searchModeButtonStackView].forEach { searchView.addSubview($0)}
        [currentLocationImageView, currentLocationLabel].forEach { currentLocationStackView.addArrangedSubview($0) }
        [mapSearchButton, addressSearchButton].forEach { locationButtonStackView.addArrangedSubview($0) }
        [startingPointButton, destinationButton].forEach { searchModeButtonStackView.addArrangedSubview($0) }
        
        
        //Common
        modeButtonStackView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(40)
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
        
        titleSearchBarStackView.snp.makeConstraints{
            $0.top.equalTo(modeButtonStackView.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(10)
            $0.trailing.equalToSuperview().offset(-10)
            $0.height.equalTo(40)
        }
        
        titleSearchButton.snp.makeConstraints{
            $0.width.equalTo(50)
        }
        
        titleSearchTableView.snp.makeConstraints {
            $0.top.equalTo(titleSearchBarStackView.snp.bottom).offset(15)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        //Location Mode
        
        searchView.snp.makeConstraints {
            $0.top.equalTo(locationModeView.snp.top).offset(15)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.bottom.equalTo(searchModeButtonStackView.snp.bottom).offset(15)
        }
        
        currentLocationStackView.snp.makeConstraints {
            $0.top.equalTo(searchView.snp.top).offset(15)
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
        
        locationTableView.snp.makeConstraints {
            $0.top.equalTo(searchView.snp.bottom).offset(15)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
}
