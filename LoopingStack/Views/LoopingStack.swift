//
//  LoopingStack.swift
//  LoopingStack
//
//  Created by Taras Prystupa on 20.12.2024.
//

import SwiftUI

struct LoopingStack<Content: View>: View {
    
    var visibleCardCount: Int = 2
    var maxTranslationWidth: CGFloat?
    @ViewBuilder var content: Content
    //View properties
    @State private var rotation: Int = 0
    
    var body: some View {
        
        Group(subviews: content) { collection in
            let collection = collection.rotateFromLeft(by: rotation)
            let count = collection.count
            
            ZStack {
                ForEach(collection) { view in
                    //reverse stack with zindex
                    let index = collection.index(view)
                    let zIndex = Double(count - index)
                    
                    
                    LoopingStackCardView(
                        index: index,
                        count: count,
                        visibleCardCount: visibleCardCount,
                        maxTranslationWidth: maxTranslationWidth,
                        rotation: $rotation
                    ) {
                       view
                    }
                    .zIndex(zIndex)
                }
            }
        }
    }
}

fileprivate struct LoopingStackCardView<Content: View> : View {
    var index: Int
    var count: Int
    var visibleCardCount: Int
    var maxTranslationWidth: CGFloat?
    @Binding var rotation: Int
    @ViewBuilder var content: Content
    //interacting properties
    @State private var offset: CGFloat = .zero
    //useful to calculate the end result when dragging is finished (to push into the next card)
    @State private var viewSize: CGSize = .zero
    var body: some View {
        //visible card count and scale
        let extraOffset = min(CGFloat(index) * 20, CGFloat(visibleCardCount) * 20)
        let scale = 1 - min(CGFloat(index) * 0.07, CGFloat(visibleCardCount) * 0.07)
        //3D rotation whed swipind the card
        let rotationDegree: CGFloat = -30
        let rotation = max(min(-offset / viewSize.width, 1), 0) * rotationDegree
        content
            .onGeometryChange(for: CGSize.self, of: {
                $0.size
            }, action: {
                viewSize = $0
            })
            .offset(x: extraOffset)
            .scaleEffect(scale, anchor: .trailing)
            .animation(.smooth(duration: 0.25, extraBounce: 0), value: index)
            .offset(x: offset)
            .rotation3DEffect(.init(degrees: rotation), axis: (0, 1, 0), anchor: .center, perspective: 0.5)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        //only left side
                        let xOffset = -max(-value.translation.width, 0)
                        
                        if let maxTranslationWidth {
                            let progress = -max(min(-xOffset / maxTranslationWidth, 1), 0) * viewSize.width
                            offset = progress
                        } else {
                            offset = xOffset
                        }
                    }.onEnded { value in
                        let xVelocity = max(-value.velocity.width / 5, 0)
                        
                        if (-offset + xVelocity) > (viewSize.width * 0.65) {
                            pushToNextCard()
                        } else {
                            withAnimation(.smooth(duration: 0.3, extraBounce: 0)) {
                                offset = .zero
                            }
                        }
                    },
                isEnabled: index == 0 && count > 1
            )
    }
    
    private func pushToNextCard() {
        withAnimation(.smooth(duration: 0.25, extraBounce: 0).logicallyComplete(after: 0.15), completionCriteria: .logicallyComplete) {
            offset = -viewSize.width
        } completion: {
            rotation += 1
            withAnimation(.smooth(duration: 0.25, extraBounce: 0)) {
                offset = .zero
            }
        }
    }
}

extension SubviewsCollection {
    
    func rotateFromLeft(by: Int) -> [SubviewsCollection.Element] {
        guard !isEmpty else { return [] }
        //to push cards behind when it's swiped and to make it appear as if it's looping, we can actually rotate the array to achive that
        let moveIndex = by % count
        let rotatedElements = Array(self[moveIndex...]) + Array(self[0..<moveIndex])
        // This will give result like,
        // if array given [1,2,3,4,5] and steps 2, result will be [3,4,5,1,2]
        return rotatedElements
    }
}

extension [SubviewsCollection.Element] {
    func index(_ item: SubviewsCollection.Element) -> Int {
        firstIndex(where: { $0.id == item.id }) ?? 0
    }
}

#Preview {
    ContentView()
}
