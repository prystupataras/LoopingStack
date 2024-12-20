//
//  ContentView.swift
//  LoopingStack
//
//  Created by Taras Prystupa on 20.12.2024.
//

import SwiftUI

struct ContentView: View {
    
    @State private var frameSize: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                
                GeometryReader {
                    let width = $0.size.width
                    
                    LoopingStack(maxTranslationWidth: width) {
                        ForEach(Developer.dev.images) { imageModel in
                            Image(imageModel.image)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: frameSize ? 250 : 100 , height: frameSize ? 400 : 100)
                                .clipShape(.rect(cornerRadius: 30))
                                .padding(5)
                                .background {
                                    RoundedRectangle(cornerRadius: 35)
                                        .fill(.background)
                                }
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                .frame(height: frameSize ? 420 : 120)
                
                Spacer(minLength: 0)
                
                Toggle(isOn: $frameSize) {
                    Text("FrameSize")
                }
                .frame(width: 150, alignment: .center)
                
            }
            .navigationTitle("Looping Stack")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.gray.opacity(0.2))
        }
    }
}

#Preview {
    ContentView()
}
