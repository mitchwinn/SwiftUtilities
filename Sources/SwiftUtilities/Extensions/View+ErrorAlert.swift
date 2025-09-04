import SwiftUI

public extension View {
    func alert<Message: View, Actions: View>(
        _ title: LocalizedStringResource,
        presenting error: Binding<Error?>,
        @ViewBuilder message: @escaping (Error) -> Message,
        @ViewBuilder actions: @escaping () -> Actions
    ) -> some View {
        modifier(
            ErrorAlertViewModifier(
                title: title,
                error: error,
                actions: actions,
                message: message
            )
        )
    }

    func alert<Message: View>(
        _ title: LocalizedStringResource,
        presenting error: Binding<Error?>,
        @ViewBuilder message: @escaping (Error) -> Message
    ) -> some View {
        modifier(
            ErrorAlertViewModifier(title: title, error: error) {
                Button(role: .cancel) {
                    error.wrappedValue = nil
                } label: {
                    Text("OK")
                }
            } message: { error in
                message(error)
            }
        )
    }
}

private struct ErrorAlertViewModifier<Message: View, Actions: View>: ViewModifier {
    let title: LocalizedStringResource
    @Binding var error: Error?
    @ViewBuilder let actions: () -> Actions
    @ViewBuilder let message: (Error) -> Message

    @State private var isAlertPresented = false
    private var hasError: Bool {
        error != nil
    }

    func body(content: Content) -> some View {
        content
            .alert(title, isPresented: $isAlertPresented) {
                actions()
            } message: {
                if let error {
                    message(error)
                }
            }
            .onChange(of: hasError) { _, newValue in
                isAlertPresented = newValue
            }
    }
}
