//
//  MeetingViewingViewController.swift
//  AppTest
//
//  Created by Сергей Аршинов on 30.05.2023.
//

import UIKit

protocol MeetingViewingViewProtocol: AnyObject {
    func setData(viewData: MeetingViewData)
}

class MeetingViewingViewController: UIViewController {

    var presenter: MeetingViewingPresenterProtocol!
    
    var scrollView: UIScrollView!
    var contentView: UIView!
    var stackView: UIStackView!
    var meetingNameLabel: UILabel!
    var meetingStartTimeLabel: UILabel!
    var meetingEndTimeLabel: UILabel!
    var meetingDescriptionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        setup()
    }

    private func setup() {
        presenter = MeetingViewingPresenter()
        presenter.view = self
        presenter.showMeeting()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
        scrollView = UIScrollView()
        view.addSubview(scrollView)
        
        contentView = UIView()
        scrollView.addSubview(contentView)
        
        meetingNameLabel = UILabel()
        meetingNameLabel.numberOfLines = 0
        meetingStartTimeLabel = UILabel()
        meetingStartTimeLabel.numberOfLines = 0
        meetingEndTimeLabel = UILabel()
        meetingEndTimeLabel.numberOfLines = 0
        meetingDescriptionLabel = UILabel()
        meetingDescriptionLabel.numberOfLines = 0
        
        stackView = UIStackView(arrangedSubviews: [meetingNameLabel, meetingStartTimeLabel,
                                                   meetingEndTimeLabel, meetingDescriptionLabel])
        contentView.addSubview(stackView)
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        stackView.spacing = 8
    }
    
    private func setupConstraints() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        let constraintHeightContentView = contentView.heightAnchor.constraint(equalTo: scrollView.frameLayoutGuide.heightAnchor)
        constraintHeightContentView.priority = .defaultHigh
        
        let constraintWidthStackView = stackView.widthAnchor.constraint(equalToConstant: 350)
        constraintWidthStackView.priority = .defaultHigh
        
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            view.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            
            contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),
            constraintHeightContentView,
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            scrollView.contentLayoutGuide.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            scrollView.contentLayoutGuide.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            constraintWidthStackView,
            stackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            stackView.topAnchor.constraint(greaterThanOrEqualTo: contentView.topAnchor, constant: 8),
            contentView.trailingAnchor.constraint(greaterThanOrEqualTo: stackView.trailingAnchor, constant: 8)
        ])
    }
    
    func applyStyleToString(string: String) -> NSAttributedString {
        NSAttributedString(string: string, attributes: [NSAttributedString.Key.foregroundColor : UIColor.gray])
    }
}

extension MeetingViewingViewController: MeetingViewingViewProtocol {
    func setData(viewData: MeetingViewData) {
        let name = NSMutableAttributedString()
        name.append(NSAttributedString(string: "Название: "))
        name.append(applyStyleToString(string: viewData.name))
        
        let startTime  = NSMutableAttributedString()
        startTime.append(NSAttributedString(string: "Время начала: "))
        startTime.append(applyStyleToString(string: viewData.startTime))
        
        let endTime  = NSMutableAttributedString()
        endTime.append(NSAttributedString(string: "Время окончания: "))
        endTime.append(applyStyleToString(string: viewData.endTime))
        
        let description  = NSMutableAttributedString()
        description.append(NSAttributedString(string: "Описание: "))
        description.append(applyStyleToString(string: viewData.description))
                                            
        meetingNameLabel.attributedText = name
        meetingStartTimeLabel.attributedText = startTime
        meetingEndTimeLabel.attributedText = endTime
        meetingDescriptionLabel.attributedText = description
    }
}
