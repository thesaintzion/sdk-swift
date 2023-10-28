//
//  CountriesViewController.swift
//  
//
//  Created by Isaac Iniongun on 28/10/2023.
//

import UIKit

protocol CountriesViewDelegate: AnyObject {
    func didChooseCountry(_ country: Country)
}

final class CountriesViewController: BottomPopupViewController {
    weak var delegate: CountriesViewDelegate?
    private let countries = Country.allCases
    
    private let countriesLabel = UILabel(
        text: "Countries",
        font: .primaryBold(17),
        alignment: .center
    )
    private lazy var countriesTableView = UITableView(
        cells: [CountryCell.self],
        delegate: self,
        datasource: self,
        scrollable: false
    )

    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews(countriesLabel, countriesTableView)
        countriesLabel.anchor(
            top: safeAreaTopAnchor,
            leading: safeAreaLeadingAnchor,
            trailing: safeAreaTrailingAnchor,
            padding: .kinit(topBottom: 15, leftRight: 16)
        )
        countriesTableView.anchor(
            top: safeAreaTopAnchor,
            leading: leadingAnchor,
            bottom: safeAreaBottomAnchor,
            trailing: safeAreaTrailingAnchor,
            padding: .kinit(topBottom: 10, leftRight: 10)
        )
    }
    
    override var popupHeight: CGFloat { 300 }
    
    override var popupTopCornerRadius: CGFloat { 20 }
    
    private func didChooseCountry(_ country: Country) {
        dismissViewController { [weak self] in
            self?.delegate?.didChooseCountry(country)
        }
    }

}

extension CountriesViewController: UITableViewConformable {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        countries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let country = countries[indexPath.row]
        return with(tableView.deque(cell: CountryCell.self, at: indexPath)) {
            $0.configure(country: country)
            $0.didTap { [weak self] in
                self?.didChooseCountry(country)
            }
        }
    }
}
