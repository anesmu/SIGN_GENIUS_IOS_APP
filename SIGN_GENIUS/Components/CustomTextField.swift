import SwiftUI

struct CustomTextField: View {
    
    @Binding var text: String
    private let isPasswordType: Bool
    private let placeHolderText: String
    
    @State private var isPasswordShown: Bool = false
    
    init(placeHolderText: String, text: Binding<String>, isPasswordType: Bool = false) {
        _text = text
        self.isPasswordType = isPasswordType
        self.placeHolderText = placeHolderText
    }
    var body: some View {
        VStack {
            if isPasswordType {
                ZStack(alignment: .trailing) {
                    if isPasswordShown {
                        TextField(placeHolderText, text: $text)
                            .textFieldStyle(MyTextFieldStyle())
                    } else {
                        SecureField(placeHolderText, text: $text)
                            .textFieldStyle(MyTextFieldStyle())
                    }
                    Button(action: {
                        self.isPasswordShown.toggle()
                    }) {
                        Image(systemName: self.isPasswordShown ? "eye.slash.fill" : "eye.fill")
                            .padding(.trailing, 15)
                            .foregroundColor(.black)
                    }
                }
            } else {
                TextField(placeHolderText, text: $text)
                    .textFieldStyle(MyTextFieldStyle())
            }
        }
    }
}
