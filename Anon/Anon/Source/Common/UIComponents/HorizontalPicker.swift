//
//  HorizontalPicker.swift
//  Anon
//
//  Created by jeongminji on 8/24/25.
//

import SwiftUI

struct SnappingScrollView<Content: View>: UIViewRepresentable {
    let content: Content
    @Binding var selectedIndex: Int
    let itemWidth: CGFloat
    let spacing: CGFloat
    let itemsCount: Int
    
    init(selectedIndex: Binding<Int>, itemWidth: CGFloat, spacing: CGFloat, itemsCount: Int, @ViewBuilder content: () -> Content) {
        self._selectedIndex = selectedIndex
        self.itemWidth = itemWidth
        self.spacing = spacing
        self.itemsCount = itemsCount
        self.content = content()
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: Context) -> UIScrollView {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.decelerationRate = .fast
        scrollView.delegate = context.coordinator
        
        let hosting = UIHostingController(rootView: AnyView(EmptyView()))
        hosting.view.translatesAutoresizingMaskIntoConstraints = false
        hosting.view.backgroundColor = .clear  
        
        scrollView.addSubview(hosting.view)
        context.coordinator.hosting = hosting
        
        NSLayoutConstraint.activate([
            hosting.view.topAnchor.constraint(equalTo: scrollView.topAnchor),
            hosting.view.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            hosting.view.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            hosting.view.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            hosting.view.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
        ])
        
        return scrollView
    }
    
    func updateUIView(_ uiView: UIScrollView, context: Context) {
        
        context.coordinator.hosting?.rootView = AnyView(
            HStack(spacing: spacing) {
                Color.clear.frame(width: 37)
                content
                Color.clear.frame(width: 37)
            }
        )
    }
    
    class Coordinator: NSObject, UIScrollViewDelegate {
        var parent: SnappingScrollView
        var hosting: UIHostingController<AnyView>?
        
        init(_ parent: SnappingScrollView) { self.parent = parent }
        
        func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
            snap(scrollView)
        }
        
        func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
            if !decelerate { snap(scrollView) }
        }
        
        private func snap(_ scrollView: UIScrollView) {
            let itemSpacing = parent.itemWidth + parent.spacing
            let centerX = scrollView.contentOffset.x + scrollView.bounds.width / 2
            
            let rawIndex = (centerX - parent.itemWidth / 2) / itemSpacing
            let newIndex = max(0, min(parent.itemsCount - 1, Int(round(rawIndex))))
            
            let offset = 3
            let actualIndex = max(0, min(parent.itemsCount - 2*offset - 1, newIndex - offset))

            parent.selectedIndex = actualIndex
            
            let targetX = CGFloat(newIndex) * itemSpacing - (scrollView.bounds.width - parent.itemWidth) / 2
            scrollView.setContentOffset(CGPoint(x: max(0, targetX), y: 0), animated: true)

            UIImpactFeedbackGenerator(style: .light).impactOccurred()
        }

    }
}

struct HorizontalPickerView: View {
    @Binding var selectedIndex: Int
    private let items: [String]
    
    init(selectedIndex: Binding<Int>) {
        self._selectedIndex = selectedIndex
        
        let calendar = Calendar.current
        let today = Date()
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "EEE"
        
        var temp: [String] = []
        for i in 0..<7 {
            if i == 0 {
                temp.append("Today")
            } else if let date = calendar.date(byAdding: .day, value: i, to: today) {
                temp.append(formatter.string(from: date))
            }
        }
        self.items = temp
    }
    
    var body: some View {
        VStack {
            SnappingScrollView(
                selectedIndex: $selectedIndex,
                itemWidth: 44,
                spacing: 32,
                itemsCount: items.count + 6
            ) {
                ForEach(0..<3, id: \.self) { _ in
                    Circle()
                        .fill(.neutral30)
                        .frame(width: 12, height: 12)
                }
                
                ForEach(items.indices, id: \.self) { index in
                    let actualIndex = index
                    let isSelected = selectedIndex == actualIndex
                    
                    ZStack {
                        Capsule()
                            .fill(isSelected ? Color.blue : Color.blue5)
                            .frame(
                                width: isSelected ? 56 : 50,
                                height: isSelected ? 68 : 50
                            )
                            .animation(.spring(response: 0.3, dampingFraction: 2.0), value: selectedIndex)
                        
                        Text(items[index])
                            .font(.labelL)
                            .foregroundColor(isSelected ? .neutral0 : .neutral90)
                    }
                }
                
                ForEach(0..<3, id: \.self) { _ in
                    Circle()
                        .fill(Color.clear)
                        .frame(width: 12, height: 12)
                }
            }
            .frame(height: 68)
        }
    }
}

#Preview {
    @Previewable @State var selectedIndex = 0
    
    HorizontalPickerView(selectedIndex: $selectedIndex)
}
