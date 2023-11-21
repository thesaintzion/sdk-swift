//
//  DateDayLabel.swift
//
//
//  Created by Isaac Iniongun on 20/11/2023.
//

import HorizonCalendar
import UIKit

struct DateDayLabel: CalendarItemViewRepresentable {
    
    /// Properties that are set once when we initialize the view.
    struct InvariantViewProperties: Hashable {
        var font: UIFont
        var textColor: UIColor
        var backgroundColor: UIColor
    }
    
    /// Properties that will vary depending on the particular date being displayed.
    struct ViewModel: Equatable {
        let day: Day
    }
    
    static func makeView(
        withInvariantViewProperties invariantViewProperties: InvariantViewProperties)
    -> UILabel
    {
        let label = UILabel()
        
        label.backgroundColor = invariantViewProperties.backgroundColor
        label.font = invariantViewProperties.font
        label.textColor = invariantViewProperties.textColor
        
        label.textAlignment = .center
        label.clipsToBounds = true
        label.layer.cornerRadius = 22
        
        return label
    }
    
    static func setViewModel(_ viewModel: ViewModel, on view: UILabel) {
        view.text = "\(viewModel.day.day)"
    }
    
}

extension Day {
    var date: Date? {
        Calendar.current.date(from: DateComponents(year: self.components.year, month: self.components.month, day: self.components.day))
    }
}
