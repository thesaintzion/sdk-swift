//
//  FeedbackConfig.swift
//
//
//  Created by Isaac Iniongun on 08/12/2023.
//

import Foundation

struct FeedbackConfig {
    let feedbackType: FeedbackType
    let titleText: String
    let message: String
    let showNavControls: Bool
    let doneAction: NoParamHandler?
    
    init(
        feedbackType: FeedbackType,
        titleText: String,
        message: String,
        showNavControls: Bool = true,
        doneAction: NoParamHandler? = nil
    ) {
        self.feedbackType = feedbackType
        self.titleText = titleText
        self.message = message
        self.showNavControls = showNavControls
        self.doneAction = doneAction
    }
}

extension FeedbackConfig {
    static func error(
        feedbackType: FeedbackType = .failure,
        titleText: String = "Failure Message",
        message: String = "Operation Failed",
        showNavControls: Bool = true,
        doneAction: NoParamHandler? = nil
    ) -> FeedbackConfig {
        FeedbackConfig(
            feedbackType: feedbackType,
            titleText: titleText,
            message: message,
            showNavControls: showNavControls,
            doneAction: doneAction
        )
    }
    
    static func success(
        feedbackType: FeedbackType = .success,
        titleText: String = "Success Message",
        message: String = "Operation successful",
        showNavControls: Bool = true,
        doneAction: NoParamHandler? = nil
    ) -> FeedbackConfig {
        FeedbackConfig(
            feedbackType: feedbackType,
            titleText: titleText,
            message: message,
            showNavControls: showNavControls,
            doneAction: doneAction
        )
    }
}
