//
//  MeetingEditingPresenter.swift
//  AppTest
//
//  Created by Сергей Аршинов on 30.05.2023.
//

import Foundation

protocol MeetingEditingPresenterProtocol: AnyObject {
    var view: MeetingEditingViewProtocol? { get set }
    func saveMeeting(name: String?, startTime: String?, endTime: String?, description: String?)
}

class MeetingEditingPresenter {
    
    weak var view: MeetingEditingViewProtocol?
    let meetingManager = MeetingManager.shared
}

extension MeetingEditingPresenter: MeetingEditingPresenterProtocol {
    func saveMeeting(name: String?, startTime: String?, endTime: String?, description: String?) {
        self.view?.ui(block: true)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
            guard let self = self else { return }
            self.meetingManager.saveMeeting(name: name, startTime: startTime, endTime: endTime, description: description)
            self.view?.clearData()
            self.view?.ui(block: false)
        }
    }
}
