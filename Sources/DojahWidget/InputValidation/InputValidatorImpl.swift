//
//  InputValidatorImpl.swift
//
//
//  Created by Isaac Iniongun on 25/10/2023.
//

import Foundation

class InputValidatorImpl: IInputValidator {
    
    func validateEmailAddress(_ email: String) -> ValidationMessage {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Z0-9a-z.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        
        if email.isEmpty {
            return ValidationMessage(message: "Cannot be empty", validationType: .email)
        } else if !emailPredicate.evaluate(with: email.trimmingCharacters(in: .whitespacesAndNewlines)) {
            return ValidationMessage(message: "Invalid email address", validationType: .email)
        }
        
        return ValidationMessage(isValid: true, message: "", validationType: .email)
    }
    
    func validateEmailOrPhone(_ emailOrPhone: String) -> ValidationMessage {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Z0-9a-z.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        
        let phoneNoRegex = "^[0-9+]{11}$"
        let phoneNoPredicate = NSPredicate(format: "SELF MATCHES %@", phoneNoRegex)
        
        if emailOrPhone.isEmpty {
            return ValidationMessage(message: "Cannot be empty", validationType: .emailOrPhone)
        } else if !emailPredicate.evaluate(with: emailOrPhone.trimmingCharacters(in: .whitespacesAndNewlines)) &&
            !phoneNoPredicate.evaluate(with: emailOrPhone.trimmingCharacters(in: .whitespacesAndNewlines)) {
            return ValidationMessage(message: "Invalid email or phone", validationType: .emailOrPhone)
        }
        
        return ValidationMessage(isValid: true, message: "", validationType: .emailOrPhone)
    }
    
    func validatePhoneNumber(_ phoneNo: String) -> ValidationMessage {
        let phoneNoRegex = "^[0-9+]{10}$"
        let phoneNoPredicate = NSPredicate(format: "SELF MATCHES %@", phoneNoRegex)
        
        if phoneNo.isEmpty {
            return ValidationMessage(message: "Cannot be empty", validationType: .phoneNumber)
        } else if !phoneNoPredicate.evaluate(with: phoneNo.trimmingCharacters(in: .whitespacesAndNewlines)) {
            return ValidationMessage(message: "Invalid phone number", validationType: .phoneNumber)
        }
        
        return ValidationMessage(isValid: true, message: "", validationType: .phoneNumber)
    }
    
    func validateName(_ name: String) -> ValidationMessage {
        let nameRegex = "[A-Za-z ]{2,}"
        let namePredicate = NSPredicate(format: "SELF MATCHES %@", nameRegex)
        
        if name.isEmpty {
            return ValidationMessage(message: "Cannot be empty", validationType: .name)
        } else if !namePredicate.evaluate(with: name.trimmingCharacters(in: .whitespacesAndNewlines)) {
            return ValidationMessage(message: "Must be at least 2 characters(letters only)", validationType: .name)
        }
        
        return ValidationMessage(isValid: true, message: "", validationType: .name)
    }
    
    func validateAddress(_ address: String) -> ValidationMessage {
        let addressRegex = "[0-9A-Za-z,. ]{2,}"
        let addressPredicate = NSPredicate(format: "SELF MATCHES %@", addressRegex)
        
        if address.isEmpty {
            return ValidationMessage(message: "Cannot be empty", validationType: .name)
        } else if !addressPredicate.evaluate(with: address.trimmingCharacters(in: .whitespacesAndNewlines)) {
            return ValidationMessage(message: "Must be at least 2 characters", validationType: .name)
        }
        
        return ValidationMessage(isValid: true, message: "", validationType: .name)
    }
    
    func validatePassword(_ password: String) -> ValidationMessage {
        if password.isEmpty {
            return ValidationMessage(message: "Cannot be empty", validationType: .password)
        } else if password.count < 6 {
            return ValidationMessage(message: "Minimum 8 characters", validationType: .password)
        }
        
        return ValidationMessage(isValid: true, message: "", validationType: .password)
    }
    
    func validateConfirmPassword(_ password: String, _ confirmPassword: String) -> ValidationMessage {
        if confirmPassword.isEmpty {
            return ValidationMessage(message: "Cannot be empty", validationType: .confirmPassword)
        } else if confirmPassword.count < 6 {
            return ValidationMessage(message: "Minimum 8 characters", validationType: .confirmPassword)
        } else if password != confirmPassword {
            return ValidationMessage(message: "Password mismatch", validationType: .confirmPassword)
        }
        
        return ValidationMessage(isValid: true, message: "", validationType: .confirmPassword)
    }
    
    func validateAmount(_ amount: String) -> ValidationMessage {
        if amount.isEmpty {
            return ValidationMessage(message: "Cannot be empty", validationType: .amount)
        } else if let value = amount.amountSanitized.double, value.equals(0) {
            return ValidationMessage(message: "Invalid amount", validationType: .amount)
        }
        
        return ValidationMessage(isValid: true, message: "", validationType: .password)
    }
    
    func validateNumeric(_ number: String) -> ValidationMessage {
        if number.isEmpty {
            return ValidationMessage(message: "Cannot be empty", validationType: .numeric)
        } else if number != number.filter("0123456789".contains) {
            return ValidationMessage(message: "Invalid value", validationType: .numeric)
        }
        
        return ValidationMessage(isValid: true, message: "", validationType: .numeric)
    }
    
    func validateMileage(_ value: String, max: Double) -> ValidationMessage {
        if value.isEmpty {
            return ValidationMessage(message: "Cannot be empty", validationType: .mileage(max))
        } else if value != value.filter("0123456789".contains) {
            return ValidationMessage(message: "Invalid value", validationType: .mileage(max))
        } else if value.double ?? 0 > max {
            return ValidationMessage(message: "Cannot be above \(max).", validationType: .mileage(max))
        }
        
        return ValidationMessage(isValid: true, message: "", validationType: .mileage(max))
    }
    
    func validateVin(value: String, with maxLength: Int) -> ValidationMessage {
        if value.isEmpty {
            return ValidationMessage(message: "Cannot be empty", validationType: .vin(maxLength))
        } else if value.count > maxLength || value.count < maxLength {
            return ValidationMessage(message: "Must be \(maxLength) characters.", validationType: .vin(maxLength))
        }
        
        return ValidationMessage(isValid: true, message: "", validationType: .vin(maxLength))
    }
    
    func validate(_ value: String, for type: ValidationType) -> ValidationMessage {
        switch type {
        case .email:
            return validateEmailAddress(value)
        case .emailOrPhone:
            return validateEmailOrPhone(value)
        case .phoneNumber:
            return validatePhoneNumber(value)
        case .password:
            return validatePassword(value)
        case .confirmPassword:
            return validatePassword(value)
        case .name:
            return validateName(value)
        case .amount:
            return validateAmount(value)
        case .numeric:
            return validateNumeric(value)
        case .address:
            return validateAddress(value)
        case .mileage(let max):
            return validateMileage(value, max: max)
        case .vin(let maxLength):
            return validateVin(value: value, with: maxLength)
        }
    }
    
}
