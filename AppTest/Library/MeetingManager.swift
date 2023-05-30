//
//  MeetingManager.swift
//  AppTest
//
//  Created by Сергей Аршинов on 30.05.2023.
//

import Foundation

class MeetingManager {
    
    static let shared = MeetingManager()
    
    private var weakObservers = [MeetingObserver]()
    private var strongObservers = [MeetingProtocol]()
    
    func weakAttach(_ observer: MeetingProtocol) {
        deleteNilObservers()
        if !weakObservers.contains(where: { $0 === observer }) {
            let newObserver = MeetingObserver(observer: observer)
            weakObservers.append(newObserver)
        }
    }
    
    func strongAttach(_ observer: MeetingProtocol) {
        deleteNilObservers()
        if !strongObservers.contains(where: { $0 === observer }) {
            strongObservers.append(observer)
        }
    }
    
    func detach(_ observer: MeetingProtocol) {
        deleteNilObservers()
        if let index = weakObservers.firstIndex(where: { $0 === observer }) {
            weakObservers.remove(at: index)
        }
        
        if let index = strongObservers.firstIndex(where: { $0 === observer }) {
            strongObservers.remove(at: index)
        }
    }
    
    private func deleteNilObservers() {
        weakObservers.removeAll { $0.observer == nil }
    }
    
    func getMeeting() -> Meeting {
        let meeting = Meeting()
        meeting.name = UserDefaults.standard.string(forKey: "meetingName")
        meeting.startTime = UserDefaults.standard.string(forKey: "meetingStartTime")
        meeting.endTime = UserDefaults.standard.string(forKey: "meetingEndTime")
        meeting.description = UserDefaults.standard.string(forKey: "meetingDescription")
        
        return meeting
    }
    
    func saveMeeting(name: String?, startTime: String?, endTime: String?, description: String?) {
        let meeting = Meeting()
        meeting.name = name
        meeting.startTime = startTime
        meeting.endTime = endTime
        meeting.description = description
        save(meeting: meeting)
    }
    
    func save(meeting: Meeting) {
        UserDefaults.standard.set(meeting.name, forKey: "meetingName")
        UserDefaults.standard.set(meeting.startTime, forKey: "meetingStartTime")
        UserDefaults.standard.set(meeting.endTime, forKey: "meetingEndTime")
        UserDefaults.standard.set(meeting.description, forKey: "meetingDescription")
        
        weakObservers.forEach { $0.meetingManager(self, didUpdateMeeting: meeting) }
        strongObservers.forEach { $0.meetingManager(self, didUpdateMeeting: meeting) }
    }
}
