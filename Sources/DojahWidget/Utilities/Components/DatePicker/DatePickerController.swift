//
//  DatePickerController.swift
//  
//
//  Created by Isaac Iniongun on 20/11/2023.
//

import UIKit
import HorizonCalendar

final class DatePickerController: BottomPopupViewController {
    
    weak var delegate: DatePickerViewDelegate?
    private let dateFormat = "MMMM dd, YYYY"
    private lazy var dateIconTextView = PillIconTextView(
        text: Date().string(format: dateFormat).uppercased(),
        font: .light(14),
        icon:.res("calendar").withRenderingMode(.alwaysTemplate),
        iconTint: .primaryGrey,
        textColor: .white,
        contentSpacing: 10,
        bgColor: .primary,
        cornerRadius: 5
    )
    
    private lazy var monthPickerView = DJPickerView(
        title: "",
        value: selectedMonth.name,
        bgColor: .white,
        borderColor: .clear,
        borderWidth: 0,
        items: DJConstants.monthNames,
        itemSelectionHandler: didChooseMonth
    )
    
    private lazy var dayPickerView = DJPickerView(
        title: "",
        value: current(.day).string,
        bgColor: .white,
        borderColor: .clear,
        borderWidth: 0,
        showDropdownIcon: false
    )
    
    private lazy var yearPickerView = DJPickerView(
        title: "",
        value: current(.year).string,
        bgColor: .white,
        borderColor: .clear,
        borderWidth: 0,
        items: DJConstants.years.map { $0.string },
        itemSelectionHandler: didChooseYear
    )
    
    private lazy var dateStackView = HStackView(subviews: [monthPickerView, dayPickerView, yearPickerView], spacing: 20)
    private lazy var topStackView = VStackView(
        subviews: [dateIconTextView.withHStackLeftAlignment(), dateStackView],
        spacing: 15
    )
    private var calendarView: CalendarView!
    private var selectedDay: Day?
    private var selectedYear = current(.year)
    private var selectedMonth = DJMonth(rawValue: current(.month)) ?? .jan
    private var monthYearDate: Date {
        let dateComps = DateComponents(
            year: selectedYear,
            month: selectedMonth.rawValue,
            day: selectedDay?.date?.current(.day) ?? current(.day)
        )
        return Calendar.current.date(from: dateComps) ?? Date()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundColor = .primaryGrey
        setUserInterfaceStyle()
        with(topStackView) {
            addSubview($0)
            $0.anchor(
                top: safeAreaTopAnchor,
                leading: safeAreaLeadingAnchor,
                trailing: safeAreaTrailingAnchor,
                padding: .kinit(topBottom: 30, leftRight: 20)
            )
        }
        setupCalendarView()
    }
    
    override var popupHeight: CGFloat { 535 }
    
    override var popupTopCornerRadius: CGFloat { 20 }
    
    private func didChooseMonth(name: String, index: Int) {
        guard let month = DJMonth(rawValue: index + 1) else { return }
        selectedMonth = month
        refreshCalendarView()
    }
    
    private func didChooseYear(text: String, index: Int) {
        guard let year = text.int else { return }
        selectedYear = year
        refreshCalendarView()
    }
    
    private func setupCalendarView() {
        calendarView = CalendarView(initialContent: makeCalendarViewContent())
        calendarView.daySelectionHandler = { [weak self] day in
            self?.didChooseDay(day)
        }
        
        let calendarContentView = UIView(
            subviews: [calendarView],
            backgroundColor: .white,
            radius: 5
        )
        
        with(calendarContentView) {
            addSubview($0)
            
            $0.anchor(
                top: topStackView.bottomAnchor,
                leading: safeAreaLeadingAnchor,
                bottom: safeAreaBottomAnchor,
                trailing: safeAreaTrailingAnchor,
                padding: .kinit(
                    top: 10,
                    left: 15,
                    bottom: 5,
                    right: 15
                )
            )
        }
        
        calendarView.fillSuperview(padding: .kinit(bottom: 15))
    }
    
    private func didChooseDay(_ day: Day) {
        guard let date = day.date else { return }
        selectedDay = day
        delegate?.didChooseDate(date)
        dateIconTextView.text = date.string(format: dateFormat)
        dayPickerView.updateValue(date.current(.day).string)
        calendarView.setContent(makeCalendarViewContent())
        runAfter(0.25) { [weak self] in
            self?.kdismiss()
        }
    }
    
    private func refreshCalendarView() {
        dateIconTextView.text = monthYearDate.string(format: dateFormat)
        calendarView.setContent(makeCalendarViewContent())
    }
    
    private func makeCalendarViewContent() -> CalendarViewContent {
        let calendar = Calendar.current
        let startDate = monthYearDate.startOfMonth
        let endDate = monthYearDate.endOfMonth
        return CalendarViewContent(
            calendar: calendar,
            visibleDateRange: startDate...endDate,
            monthsLayout: .vertical(options: VerticalMonthsLayoutOptions())
        )
        .dayItemProvider { day in
            
            var invariantViewProperties = DateDayLabel.InvariantViewProperties(
                font: .regular(18),
                textColor: .aLabel,
                backgroundColor: .clear
            )
            
            if day == self.selectedDay {
                invariantViewProperties.textColor = .white
                invariantViewProperties.backgroundColor = .primary
            }
            
            return CalendarItemModel<DateDayLabel>(
                invariantViewProperties: invariantViewProperties,
                viewModel: .init(day: day)
            )
        }
        .monthHeaderItemProvider { month in
            CalendarItemModel<EmptyMonthHeaderView>(
                invariantViewProperties: .init(),
                viewModel: .init()
            )
        }
        .interMonthSpacing(24)
        .verticalDayMargin(8)
        .horizontalDayMargin(8)
    }

}
