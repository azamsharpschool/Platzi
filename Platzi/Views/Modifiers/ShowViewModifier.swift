import SwiftUI

struct Show: ViewModifier {
    
    let duration: Duration
    @Binding var isVisible: Bool
    @State private var initial: Bool = true
    
    func body(content: Content) -> some View {
        content
            .opacity(isVisible ? 1: 0)
            .task(id: isVisible) {
                
                if initial {
                    initial = false
                    return
                }
                
                try? await Task.sleep(for: duration)
                guard !Task.isCancelled else { return }
                
                withAnimation {
                    isVisible = false
                }
            }
    }
}

extension View {
    
    func show(duration: Duration, isVisible: Binding<Bool>) -> some View {
        modifier(Show(duration: duration, isVisible: isVisible))
    }
    
}
