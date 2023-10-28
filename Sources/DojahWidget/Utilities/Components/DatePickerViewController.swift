//
//  DatePickerViewController.swift
//  
//
//  Created by Isaac Iniongun on 28/10/2023.
//

import UIKit

protocol DatePickerViewDelegate: AnyObject {
    func didChooseDate(_ date: String)
}

final class DatePickerViewController: BottomPopupViewController {
    
    weak var delegate: DatePickerViewDelegate?
    private let dateLabel = UILabel(
        text: "Choose Date",
        font: .semibold(17),
        alignment: .center
    )
    private let datePicker = UIDatePicker(dateMode: .date)
    private lazy var doneButton = DJButton(title: "Done") { [weak self] in
        self?.didTapDone()
    }
    private lazy var contentStackView = VStackView(
        subviews: [dateLabel, datePicker, doneButton, UIView.vspacer(20)],
        spacing: 15
    )

    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundColor = .aSystemBackground
        setUserInterfaceStyle()
        with(contentStackView) {
            addSubview($0)
            $0.fillSuperview(padding: .kinit(allEdges: 20))
            $0.setCustomSpacing(0, after: doneButton)
        }
        with(datePicker) {
            $0.maximumDate = Date()
            $0.tintColor = .primary
            $0.addTarget(self, action: #selector(dateDidChanged), for: .valueChanged)
        }
    }
    
    @objc private func dateDidChanged() {
        delegate?.didChooseDate(datePicker.dateString())
    }
    
    override var popupHeight: CGFloat { 550 }
    
    override var popupTopCornerRadius: CGFloat { 20 }
    
    private func didTapDone() {
        dismissViewController { [weak self] in
            guard let self else { return }
            self.delegate?.didChooseDate(self.datePicker.dateString())
        }
    }

}
