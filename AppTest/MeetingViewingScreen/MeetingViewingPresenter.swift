//
//  MeetingViewingPresenter.swift
//  AppTest
//
//  Created by Сергей Аршинов on 30.05.2023.
//

import Foundation

protocol MeetingViewingPresenterProtocol: AnyObject {
    var view: MeetingViewingViewProtocol? { get set }
    func showMeeting()
}

class MeetingViewingPresenter {
    
    weak var view: MeetingViewingViewProtocol?
    let meetingManager = MeetingManager.shared
    var meeting: Meeting
    
    init() {
        meeting = meetingManager.getMeeting()
        meetingManager.weakAttach(self)
    }
}

extension MeetingViewingPresenter: MeetingViewingPresenterProtocol {
    func showMeeting() {
        var viewData = MeetingViewData()
        viewData.name = meeting.name ?? ""
        viewData.startTime = meeting.startTime ?? ""
        viewData.endTime = meeting.endTime ?? ""
        viewData.description = meeting.description ?? ""
        
        view?.setData(viewData: viewData)
    }
}

extension MeetingViewingPresenter: MeetingProtocol {
    func meetingManager(_ manager: MeetingManager, didUpdateMeeting meeting: Meeting) {
        self.meeting = meeting
        showMeeting()
    }
}
