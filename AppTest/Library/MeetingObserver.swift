//
//  MeetingObserver.swift
//  AppTest
//
//  Created by Сергей Аршинов on 30.05.2023.
//

import Foundation

protocol MeetingProtocol: AnyObject {
    func meetingManager(_ manager: MeetingManager, didUpdateMeeting meeting: Meeting)
}

class MeetingObserver {
    
    weak var observer: MeetingProtocol?
    
    init(observer: MeetingProtocol) {
        self.observer = observer
    }
}

extension MeetingObserver: MeetingProtocol {
    func meetingManager(_ manager: MeetingManager, didUpdateMeeting meeting: Meeting) {
        observer?.meetingManager(manager, didUpdateMeeting: meeting)
    }
}
