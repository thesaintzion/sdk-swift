//
//  EmptyMonthHeaderView.swift
//
//
//  Created by Isaac Iniongun on 21/11/2023.
//

import UIKit
import HorizonCalendar

struct EmptyMonthHeaderView: CalendarItemViewRepresentable {
    struct InvariantViewProperties: Hashable {}
    
    struct ViewModel: Equatable {}
    
    static func makeView(withInvariantViewProperties invariantViewProperties: InvariantViewProperties)
    -> UILabel {
        UILabel()
    }
    
    static func setViewModel(_ viewModel: ViewModel, on view: UILabel) {}
}
