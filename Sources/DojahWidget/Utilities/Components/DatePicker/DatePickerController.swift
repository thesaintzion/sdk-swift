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
    private let dateIconTextView = PillIconTextView(
        text: "November 21, 2022".uppercased(),
        font: .light(14),
        icon: .res(.calendar).withRenderingMode(.alwaysTemplate),
        iconTint: .primaryGrey,
        textColor: .white,
        contentSpacing: 10,
        bgColor: .primary,
        cornerRadius: 5
    )
    private lazy var monthPickerView = DJPickerView(
        title: "",
        value: "November",
        items: DJConstants.monthNames,
        itemSelectionHandler: didChooseMonth
    )
    
    private lazy var dayPickerView = DJPickerView(
        title: "",
        value: current(.day).string,
        items: DJConstants.monthDays.map { $0.string },
        itemSelectionHandler: didChooseDay
    )
    
    private lazy var yearPickerView = DJPickerView(
        title: "",
        value: current(.year).string,
        items: DJConstants.years.map { String($0) },
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
    var minDate: Date?
    var maxDate: Date?

    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundColor = .aSystemBackground
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
    
    override var popupHeight: CGFloat { 520 }
    
    override var popupTopCornerRadius: CGFloat { 20 }
    
    private func didChooseMonth(name: String, index: Int) {
        
    }
    
    private func didChooseDay(text: String, index: Int) {
        
    }
    
    private func didChooseYear(text: String, index: Int) {
        
    }
    
    private func setupCalendarView() {
        calendarView = CalendarView(initialContent: makeCalendarViewContent())
        calendarView.daySelectionHandler = { [weak self] day in
            guard let self else { return }
            self.selectedDay = day
            //self.selectedDateLabel.text = day.date?.dateOnlyString()
            self.calendarView?.setContent(self.makeCalendarViewContent())
        }
        
        with(calendarView!) {
            addSubview($0)
            
            $0.anchor(
                top: topStackView.bottomAnchor,
                leading: safeAreaLeadingAnchor,
                bottom: safeAreaBottomAnchor,
                trailing: safeAreaTrailingAnchor,
                padding: .kinit(
                    top: 10,
                    left: 15,
                    bottom: 10,
                    right: 15
                )
            )
        }
    }
    
    private func makeCalendarViewContent() -> CalendarViewContent {
        let calendar = Calendar.current
        let startDate = Date().startOfMonth
        let endDate = Date().endOfMonth
        return CalendarViewContent(calendar: calendar, visibleDateRange: startDate...endDate, monthsLayout: .vertical(options: VerticalMonthsLayoutOptions()))
            .dayItemProvider { day in
                
                var invariantViewProperties = DateTimeDayLabel.InvariantViewProperties(font: .regular(18), textColor: .aLabel, backgroundColor: .clear)
                
                if day == self.selectedDay {
                    invariantViewProperties.textColor = .white
                    invariantViewProperties.backgroundColor = .primary
                }
                
                return CalendarItemModel<DateTimeDayLabel>(invariantViewProperties: invariantViewProperties, viewModel: .init(day: day))
            }
            .monthHeaderItemProvider { month in
                CalendarItemModel<EmptyMonthHeaderView>(invariantViewProperties: .init(), viewModel: .init())
            }
            .interMonthSpacing(24)
            .verticalDayMargin(8)
            .horizontalDayMargin(8)
    }

}
