//
//  LoginViewModel.swift
//  Guardian
//
//  Created by Siyu Yao on 18/12/2023.
//

import SwiftUI
import FirebaseAuth


/// discarded since Feb.
class LoginPhoneViewModel: ObservableObject {
    // MARK: View Properties
    @Published var phoneNo: String = ""
    @Published var otpCode: String = ""
    
    @Published var CLIENT_CODE: String = ""
    @Published var showOTPField: Bool = false
    @Published var showToast: Bool = false
    
    // MARK: Error Properties
    @Published var showError: Bool = false
    @Published var errorMessage: String = ""
    
    
    
    // MARK: Firebase auth
    func getOTP(){
        UIApplication.shared.closeKeyboard()
        
        Task{
            do{
               
                
                // MARK: disable it when testing with real device
                Auth.auth().settings?.isAppVerificationDisabledForTesting = true
                
                let code = try await PhoneAuthProvider.provider().verifyPhoneNumber("+\(phoneNo)", uiDelegate: nil)
                await MainActor.run(body: {
                    CLIENT_CODE = code
                    
                    // show code sent toast
                    showToast = true
                    
                    // enabling OTP field when it's success
                    withAnimation(.easeInOut){
                        showOTPField = true
                    }
                })
            }catch{
                await handleError(error: error)
            }
        }
    }
    
    func verifyOTP(){
        UIApplication.shared.closeKeyboard()
        
        Task{
            do{
                let credential = PhoneAuthProvider.provider().credential(withVerificationID: CLIENT_CODE, verificationCode: otpCode)
                
                try await Auth.auth().signIn(with: credential)
                
                // MARK: logged in successfully
                print("Success logged in!")
//                withAnimation(.easeInOut){self.logStatus}
            }catch{
                await handleError(error: error)
            }
        }
    }
    
    // MARK: Handing error
    func handleError(error: Error)async {
        await MainActor.run(body: {
            errorMessage = error.localizedDescription
            showError.toggle()
        })
    }
}


// MARK: extensions
extension UIApplication{
    func closeKeyboard(){
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    // Root controller
    func rootController() -> UIViewController{
        guard let window = connectedScenes.first as? UIWindowScene else {return .init()}
        guard let viewcontroller = window.windows.last?.rootViewController else {return .init()}
        
        return viewcontroller
    }
}
