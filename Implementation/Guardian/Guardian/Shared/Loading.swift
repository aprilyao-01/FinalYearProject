//
//  Loading.swift
//  Guardian
//
//  Created by Siyu Yao on 05/02/2023.
//

import SwiftUI

struct Loading: View {
    @State var isAnimating = false

    var body: some View {
        ZStack {
            if isAnimating {
                BlurView(style: .systemMaterial)
                VStack {
                    Text("Loading...")
                    LoadingIndicatorView()
                        .frame(width: 50, height: 50)
                }
                .frame(width: 120, height: 120)
                .background(Color.secondary.colorInvert())
                .foregroundColor(.primary)
                .cornerRadius(20)
                .opacity(0.9)
            }
        }
        .onAppear {
            self.isAnimating = true
        }
        .onDisappear {
            self.isAnimating = false
        }
    }

}

struct BlurView: UIViewRepresentable {
    let style: UIBlurEffect.Style

    func makeUIView(context: UIViewRepresentableContext<BlurView>) -> UIView {
        let view = UIView(frame: .zero)
        view.backgroundColor = .clear
        let blurEffect = UIBlurEffect(style: style)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        view.insertSubview(blurView, at: 0)
        NSLayoutConstraint.activate([
            blurView.widthAnchor.constraint(equalTo: view.widthAnchor),
            blurView.heightAnchor.constraint(equalTo: view.heightAnchor),
        ])
        
        return view
    }

    func updateUIView(_ uiView: UIView,
                      context: UIViewRepresentableContext<BlurView>) {
        
    }
}

struct LoadingIndicatorView: UIViewRepresentable {
    func makeUIView(context: UIViewRepresentableContext<LoadingIndicatorView>) -> UIActivityIndicatorView {
        return UIActivityIndicatorView(style: .large)
    }

    func updateUIView(_ uiView: UIActivityIndicatorView,
                      context: UIViewRepresentableContext<LoadingIndicatorView>) {
        uiView.startAnimating()
    }

}

struct Active_Previews: PreviewProvider {
    static var previews: some View {
        Loading()
    }
}
