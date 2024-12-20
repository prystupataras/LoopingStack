//
//  Developer.swift
//  LoopingStack
//
//  Created by Taras Prystupa on 20.12.2024.
//

//import Foundation
import SwiftUI

class Developer {
    
    static let dev = Developer()
    private init() { }

    let images: [ImageModel] = [
        .init(text: "", image: "pic1"),
        .init(text: "", image: "pic2"),
        .init(text: "", image: "pic3"),
        .init(text: "", image: "pic4")
    ]
}
