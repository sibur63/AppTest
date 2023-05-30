//
//  MeetingEditingViewController.swift
//  AppTest
//
//  Created by Сергей Аршинов on 30.05.2023.
//

import UIKit

protocol MeetingEditingViewProtocol: AnyObject {
    func ui(block: Bool)
    func clearData()
}

class MeetingEditingViewController: UIViewController {

    var presenter: MeetingEditingPresenterProtocol!
    
    var scrollView: UIScrollView!
    var contentView: UIView!
    var stackView: UIStackView!
    var meetingNameTextField: UITextField!
    var meetingStartTimeTextField: UITextField!
    var meetingEndTimeTextField: UITextField!
    var meetingDescriptionTextField: UITextField!
    var saveButton: UIButton!
    var indicatorView: UIActivityIndicatorView!
    var bottomConstraintScrollViewToSafeArea: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        setup()
    }

    deinit {
        removeObserverForKeyboard()
    }
    
    private func setup() {
        addObserverForKeyboard()
        presenter = MeetingEditingPresenter()
        presenter.view = self
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
        scrollView = UIScrollView()
        view.addSubview(scrollView)
        
        contentView = UIView()
        scrollView.addSubview(contentView)
        
        meetingNameTextField = UITextField()
        meetingNameTextField.borderStyle = .roundedRect
        meetingNameTextField.placeholder = "Название"
        
        meetingStartTimeTextField = UITextField()
        meetingStartTimeTextField.borderStyle = .roundedRect
        meetingStartTimeTextField.placeholder = "Время начала"
        
        meetingEndTimeTextField = UITextField()
        meetingEndTimeTextField.borderStyle = .roundedRect
        meetingEndTimeTextField.placeholder = "Время окончания"
        
        meetingDescriptionTextField = UITextField()
        meetingDescriptionTextField.borderStyle = .roundedRect
        meetingDescriptionTextField.placeholder = "Описание"
        
        saveButton = UIButton()
        saveButton.setTitle("Save", for: .normal)
        saveButton.backgroundColor = .blue.withAlphaComponent(0.5)
        saveButton.tintColor = .white
        saveButton.addTarget(self, action: #selector(actionSave(_:)), for: .touchUpInside)
        
        stackView = UIStackView(arrangedSubviews: [meetingNameTextField, meetingStartTimeTextField,
                                                   meetingEndTimeTextField, meetingDescriptionTextField, saveButton])
        contentView.addSubview(stackView)
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        
        indicatorView = UIActivityIndicatorView(style: .medium)
        contentView.addSubview(indicatorView)
        indicatorView.color = .white
        indicatorView.hidesWhenStopped = true
    }
    
    private func setupConstraints() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        meetingNameTextField.translatesAutoresizingMaskIntoConstraints = false
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        
        bottomConstraintScrollViewToSafeArea = view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        
        let constraintHeightContentView = contentView.heightAnchor.constraint(equalTo: scrollView.frameLayoutGuide.heightAnchor)
        constraintHeightContentView.priority = .defaultHigh
        
        let constraintWidthStackView = stackView.widthAnchor.constraint(equalToConstant: 350)
        constraintWidthStackView.priority = .defaultHigh
        
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            view.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            bottomConstraintScrollViewToSafeArea,
            
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
            contentView.trailingAnchor.constraint(greaterThanOrEqualTo: stackView.trailingAnchor, constant: 8),
            
            indicatorView.centerXAnchor.constraint(equalTo: saveButton.centerXAnchor),
            indicatorView.centerYAnchor.constraint(equalTo: saveButton.centerYAnchor),
            
            meetingNameTextField.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    @objc
    private func actionSave(_ sender: UIButton) {
        let name = meetingNameTextField.text
        let startTime = meetingStartTimeTextField.text
        let endTime = meetingEndTimeTextField.text
        let description = meetingDescriptionTextField.text
        
        presenter.saveMeeting(name: name, startTime: startTime, endTime: endTime, description: description)
    }
    
    private func removeObserverForKeyboard() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func addObserverForKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc
    private func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
           let duration = (notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double),
           let animationOptions = (notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt) {
            DispatchQueue.main.async {
                UIView.animate(withDuration: duration, delay: 0, options: UIView.AnimationOptions(rawValue: animationOptions)) {
                    self.bottomConstraintScrollViewToSafeArea.constant = keyboardSize.height - self.view.safeAreaInsets.bottom
                    self.view.layoutIfNeeded()
                }
            }
        }
    }
    
    @objc
    private func keyboardWillHide(notification: NSNotification) {
        if let duration: Double = (notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double),
           let animationOptions = (notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt) {
            DispatchQueue.main.async {
                UIView.animate(withDuration: duration, delay: 0, options: UIView.AnimationOptions(rawValue: animationOptions)) {
                    self.bottomConstraintScrollViewToSafeArea.constant = 0
                    self.view.layoutIfNeeded()
                }
            }
        }
    }
}

extension MeetingEditingViewController: MeetingEditingViewProtocol {
    func ui(block: Bool) {
        view.isUserInteractionEnabled = !block
        
        if block {
            indicatorView.startAnimating()
            saveButton.titleLabel?.layer.opacity = 0
        } else {
            indicatorView.stopAnimating()
            saveButton.titleLabel?.layer.opacity = 1
        }
    }
    
    func clearData() {
        meetingNameTextField.text = nil
        meetingStartTimeTextField.text = nil
        meetingEndTimeTextField.text = nil
        meetingDescriptionTextField.text = nil
    }
}
