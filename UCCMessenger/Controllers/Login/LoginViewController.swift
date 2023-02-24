//
//  LoginViewController.swift
//  UCCMessenger
//
//  Created by Cian Keeney on 10/1/22.
//

import UIKit
import FirebaseAuth
import JGProgressHUD

class LoginViewController: UIViewController {
    
    private let spinner = JGProgressHUD(style: .dark)
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.clipsToBounds = true
        return scrollView
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "logo")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let emailField: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 12
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.placeholder = "Email Address..."
        field.leftView = UIView(frame:
                                    CGRect(x: 0,
                                           y: 0,
                                           width: 10,
                                           height: 0))
        field.leftViewMode = .always
        field.backgroundColor = .systemBackground
        return field
    }()
    
    private let passwordField: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .done
        field.layer.cornerRadius = 12
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.placeholder = "Password..."
        field.leftView = UIView(frame:
                                    CGRect(x: 0,
                                           y: 0,
                                           width: 10,
                                           height: 0))
        field.leftViewMode = .always
        field.backgroundColor = .systemBackground
        field.isSecureTextEntry = true
        return field
    }()
    
    private let loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("Log in", for: .normal)
        button.backgroundColor = .black
        button.setTitleColor(.systemBackground, for: .normal)
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        return button
    }()
    
    private let forgotPasswordButton: UIButton = {
        let button_forgot = UIButton()
        button_forgot.setTitle("Forgot Password", for: .normal)
        button_forgot.setTitleColor(.black, for: .normal)
        button_forgot.layer.masksToBounds = true
        button_forgot.titleLabel?.font = .systemFont(ofSize: 15)
        return button_forgot
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Log into stUtalk"
        view.backgroundColor = .systemBackground
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Register",
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(didTapRegister))
        
        loginButton.addTarget(self,
                              action: #selector(loginButtonTapped),
                              for: .touchUpInside)
        
        forgotPasswordButton.addTarget(self,
                                       action: #selector(forgotPasswordButtonTapped),
                                       for: .touchUpInside)
        emailField.delegate = self
        passwordField.delegate = self
       // Add Subviews
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        scrollView.addSubview(emailField)
        scrollView.addSubview(passwordField)
        scrollView.addSubview(loginButton)
        scrollView.addSubview(forgotPasswordButton)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.frame = view.bounds
        let size = scrollView.width/3
        imageView.frame = CGRect(x: (scrollView.width-size)/2,
                                 y: 60,
                                 width: size,
                                 height: size)
        emailField.frame = CGRect(x: 30,
                                  y: imageView.bottom+10,
                                  width: scrollView.width-60,
                                 height: 52)
        passwordField.frame = CGRect(x: 30,
                                  y: emailField.bottom+10,
                                  width: scrollView.width-60,
                                 height: 52)
        loginButton.frame = CGRect(x: 30,
                                  y: passwordField.bottom+10,
                                  width: scrollView.width-60,
                                 height: 52)
        forgotPasswordButton.frame = CGRect(x: 30,
                                            y: loginButton.bottom+10,
                                            width: scrollView.width-60,
                                            height: 52)
    }
    
    @objc private func loginButtonTapped() {
        
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
        
//        func isValidEmail(email:String?) -> Bool {
////            There’s some text before the @
////            There’s some text after the @
////            There’s at least 2 alpha characters after a .
//
//            guard email != nil else { return false }
//
//            let regEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
//
//            let pred = NSPredicate(format:"SELF MATCHES %@", regEx)
//            if (email != nil) {
//                print("The email address is not the correct format.")
//            } else {
//                alertUserLoginErrorEmail()
//            }
//
//            return pred.evaluate(with: email)
//        }
//
//        func isValidPassword(password:String?) -> Bool {
//            guard password != nil else { return false }
//            // at least one uppercase,
//            // at least one digit
//            // at least one lowercase
//            // 8 characters total
//            let passwordTest = NSPredicate(format: "SELF MATCHES %@", "(?=.*[A-Z])(?=.*[0-9])(?=.*[a-z]).{8,}")
//            if (password != nil) {
//                print("The password is not the correct format.")
//            } else {
//                alertUserLoginErrorPassword()
//            }
//            return passwordTest.evaluate(with: password)
//        }
        
        guard let email = emailField.text,
                let password = passwordField.text
               else {
                alertUserLoginError()
                return
        }
        
        spinner.show(in: view)
        
        //Fire base login
        FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password, completion: { [weak self ] authResult, error in
            guard let strongSelf = self else {
                return
            }
            
            DispatchQueue.main.async {
                strongSelf.spinner.dismiss()
            }
            

            guard let result = authResult, error == nil else {
                print("Failed to log in user with email: \(email)")
                self?.alertUserLoginErrorEmail()
                return
            }
            
            let user = result.user
            
            UserDefaults.standard.set(email, forKey: "email")
            
            print("Logged In User \(user)")
            strongSelf.navigationController?.dismiss(animated: true, completion: nil)
        })
    }
    
    
    func alertUserLoginError() {
        let alert = UIAlertController(title: "Error",
                                      message: "Please enter all information to log in.",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss",
                                      style: .cancel,
                                      handler: nil))
        present(alert, animated: true)
    }
    
    func alertUserLoginErrorEmail() {
        let alert = UIAlertController(title: "Failed to login",
                                      message: "Please enter a valid email address.",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss",
                                      style: .cancel,
                                      handler: nil))
        present(alert, animated: true)
    }
    
    func alertUserLoginErrorPassword() {
        let alert = UIAlertController(title: "Failed to login",
                                      message: "Please enter a correct password. The password must be at least one uppercase letter, at least one digit, at least one lowercase, and must be at least 8 characters long. ",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss",
                                      style: .cancel,
                                      handler: nil))
        present(alert, animated: true)
    }
    
    @objc private func forgotPasswordButtonTapped() {
        let vc = ForgotPasswordViewController()
        vc.title = "Forgot Password"
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func didTapRegister() {
        let vc = RegisterViewController()
        vc.title = "Register for stUtalk"
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == emailField {
            passwordField.becomeFirstResponder()
        }
        else if textField == passwordField {
            loginButtonTapped()
        }
        return true
    }
}
