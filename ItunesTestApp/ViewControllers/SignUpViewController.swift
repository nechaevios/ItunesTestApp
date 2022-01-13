//
//  SignUpViewController.swift
//  ItunesTestApp
//
//  Created by Nechaev Sergey  on 29.12.2021.
//

import UIKit

class SignUpViewController: UIViewController {
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let backGroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let loginLabel: UILabel = {
        let label = UILabel()
        label.text = "Registration"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let firstNameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "First Name"
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    private let firstNameValidLabel: UILabel = {
        let label = UILabel()
        label.text = "Required field"
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let secondNameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Second Name"
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    private let secondNameValidLabel: UILabel = {
        let label = UILabel()
        label.text = "Required field"
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let ageValidLabel: UILabel = {
        let label = UILabel()
        label.text = "Required field"
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let phoneNumberTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = "Phone"
        textField.keyboardType = .decimalPad
        return textField
    }()
    
    private let phoneValidLabel: UILabel = {
        let label = UILabel()
        label.text = "Required field"
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let emailTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = "E-mail"
        return textField
    }()
    
    private let emailValidLabel: UILabel = {
        let label = UILabel()
        label.text = "Required field"
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.isSecureTextEntry = true
        textField.placeholder = "Password"
        return textField
    }()
    
    private let passwordValidLabel: UILabel = {
        let label = UILabel()
        label.text = "Required field"
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .black
        button.setTitle("SignUP", for: .normal)
        button.tintColor = .white
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var elementsStackView = UIStackView()
    private let datePicker = UIDatePicker()
    
    let nameValidType: String.ValidTypes = .name
    let emailValidType: String.ValidTypes = .email
    let passwordValidType: String.ValidTypes = .password
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setConstraints()
        setupDelegate()
        setupDataPicker()
        registerKeyboardNotification()
    }
    
    deinit {
        removeKeyboardNotification()
    }
    
    private func setupUI() {
        title = "Registration"
        view.backgroundColor = .white
        
        view.addSubview(scrollView)
        scrollView.addSubview(backGroundView)
        
        elementsStackView = UIStackView(arrangedSubviews: [
            firstNameTextField,
            firstNameValidLabel,
            secondNameTextField,
            secondNameValidLabel,
            datePicker,
            phoneNumberTextField,
            phoneValidLabel,
            emailTextField,
            emailValidLabel,
            passwordTextField,
            passwordValidLabel
        ])
        
        elementsStackView.translatesAutoresizingMaskIntoConstraints = false
        elementsStackView.axis = .vertical
        elementsStackView.distribution = .fillProportionally
        elementsStackView.spacing = 10
        
        backGroundView.addSubview(loginLabel)
        backGroundView.addSubview(elementsStackView)
        backGroundView.addSubview(signUpButton)
    }
    
    private func setupDelegate() {
        firstNameTextField.delegate = self
        secondNameTextField.delegate = self
        phoneNumberTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    private func setupDataPicker() {
        datePicker.datePickerMode = .date
        datePicker.contentHorizontalAlignment = .left
        datePicker.backgroundColor = .white
        datePicker.layer.borderColor = #colorLiteral(red: 0.8810099265, green: 0.8810099265, blue: 0.8810099265, alpha: 1)
        datePicker.layer.borderWidth = 1
        datePicker.clipsToBounds = true
        datePicker.layer.cornerRadius = 6
        datePicker.tintColor = .black
    }
    
    @objc private func signUpButtonTapped() {
        let firstNameText = firstNameTextField.text ?? ""
        let secondNameText = secondNameTextField.text ?? ""
        let emailText = emailTextField.text ?? ""
        let passwordText = passwordTextField.text ?? ""
        let phoneText = phoneNumberTextField.text ?? ""
        
        if firstNameText.isValid(validType: nameValidType)
            && secondNameText.isValid(validType: nameValidType)
            && emailText.isValid(validType: emailValidType)
            && passwordText.isValid(validType: passwordValidType)
            && phoneText.count == 18
            && ageIsValid() == true {
            
            DataBase.shared.saveUser(
                firstName: firstNameText,
                secondName: secondNameText,
                phone: phoneText,
                email: emailText,
                password: passwordText,
                age: datePicker.date
            )
            
            loginLabel.text = "Registration complete"
            
        } else {
            loginLabel.text = "Registration"
            alertOk(title: "Error", message: "Fill in all fields, your age must be 18+ y.o.")
        }
        
        
        
    }
    
    private func setTextField(
        textField: UITextField,
        label: UILabel,
        validType:String.ValidTypes,
        validMessage: String,
        wrongMessage: String,
        string: String,
        range: NSRange
    ) {
        
        let text = (textField.text ?? "") + string
        let result: String
        
        if range.length == 1 {
            let end = text.index(text.startIndex, offsetBy: text.count - 1)
            result = String(text[text.startIndex..<end])
        } else {
            result = text
        }
        
        textField.text = result
        
        if result.isValid(validType: validType) {
            label.text = validMessage
            label.textColor = .blue
        } else {
            label.text = wrongMessage
            label.textColor = .red
        }
    }
    
    private func setPhoneNumberMask(textField: UITextField, mask: String, string: String, range: NSRange) -> String {
        
        let text = textField.text ?? ""
        let phone = (text as NSString).replacingCharacters(in: range, with: string)
        let number = phone.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        var result = ""
        var index = number.startIndex
        
        for character in mask where index < number.endIndex {
            if character == "X" {
                result.append(number[index])
                index = number.index(after: index)
            } else {
                result.append(character)
            }
        }
        
        if result.count == 18 {
            phoneValidLabel.text = "Phone is valid"
            phoneValidLabel.textColor = .blue
        } else {
            phoneValidLabel.text = "Phone is not valid"
            phoneValidLabel.textColor = .red
        }
        
        return result
    }
    
    private func ageIsValid() -> Bool {
        let calendar = NSCalendar.current
        let dateNow = Date()
        let birthday = datePicker.date
        let age = calendar.dateComponents([.year], from: birthday, to: dateNow)
        let ageYear = age.year
        
        guard let ageUser = ageYear else { return false }
        
        return (ageUser < 18 ?  false : true)
    }
    
}

// MARK: - Constraints

extension SignUpViewController {
    private func setConstraints() {
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8.0),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8.0),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 8.0),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -8.0)
        ])
        
        NSLayoutConstraint.activate([
            backGroundView.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor),
            backGroundView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            backGroundView.heightAnchor.constraint(equalTo: view.heightAnchor),
            backGroundView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
        
        NSLayoutConstraint.activate([
            elementsStackView.centerXAnchor.constraint(equalTo: backGroundView.centerXAnchor),
            elementsStackView.centerYAnchor.constraint(equalTo: backGroundView.centerYAnchor),
            elementsStackView.leadingAnchor.constraint(equalTo: backGroundView.leadingAnchor, constant: 20),
            elementsStackView.trailingAnchor.constraint(equalTo: backGroundView.trailingAnchor, constant: -20)
        ])
        
        NSLayoutConstraint.activate([
            loginLabel.centerXAnchor.constraint(equalTo: backGroundView.centerXAnchor),
            loginLabel.bottomAnchor.constraint(equalTo: elementsStackView.topAnchor, constant: -30),
        ])
        
        NSLayoutConstraint.activate([
            signUpButton.centerXAnchor.constraint(equalTo: backGroundView.centerXAnchor),
            signUpButton.topAnchor.constraint(equalTo: elementsStackView.bottomAnchor, constant: 30),
            signUpButton.heightAnchor.constraint(equalToConstant: 40),
            signUpButton.widthAnchor.constraint(equalToConstant: 300)
        ])
    }
}

// MARK: - Keyboard Show Hide

extension SignUpViewController {
    private func registerKeyboardNotification() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil)
    }
    
    private func removeKeyboardNotification() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(notification: Notification) {
        let userInfo = notification.userInfo
        guard let keyboardHeight = (userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        scrollView.contentOffset = CGPoint(x: 0, y: keyboardHeight.height / 2)
    }
    
    @objc private func keyboardWillHide(notification: Notification) {
        scrollView.contentOffset = CGPoint.zero
    }
}

//MARK: - UITextFieldDelegate
extension SignUpViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        switch textField {
        case firstNameTextField: setTextField(
            textField: firstNameTextField,
            label: firstNameValidLabel,
            validType: nameValidType,
            validMessage: "Name is valid",
            wrongMessage: "Only A-Z characters, min 1 character",
            string: string,
            range: range
        )
        case secondNameTextField: setTextField(
            textField: secondNameTextField,
            label: secondNameValidLabel,
            validType: nameValidType,
            validMessage: "Second name is valid",
            wrongMessage: "Only A-Z characters, min 1 character",
            string: string,
            range: range
        )
        case emailTextField: setTextField(
            textField: emailTextField,
            label: emailValidLabel,
            validType: emailValidType,
            validMessage: "Email is valid",
            wrongMessage: "Email is not valid",
            string: string,
            range: range
        )
        case passwordTextField: setTextField(
            textField: passwordTextField,
            label: passwordValidLabel,
            validType: passwordValidType,
            validMessage: "Password is valid",
            wrongMessage: "min 1 A-Z, min 1 a-z, min 1 0-9, min 6 chars",
            string: string,
            range: range
        )
        case phoneNumberTextField: phoneNumberTextField.text = setPhoneNumberMask(
            textField: phoneNumberTextField,
            mask: "+X (XXX) XXX XX XX",
            string: string,
            range: range
        )
        default: break
        }
        
        return false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        firstNameTextField.resignFirstResponder()
        secondNameTextField.resignFirstResponder()
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        return true
    }
}
