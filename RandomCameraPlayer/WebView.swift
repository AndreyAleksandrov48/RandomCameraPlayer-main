//
//  WebView.swift
//  RandomCameraPlayer
//
//  Created by Andrew on 10.11.2023.
//

import SwiftUI
import WebKit
import AVKit

struct WebViewMap: View {
    @State private var urlString = "https://camera.lipetsk.ru"

    var body: some View {
        NavigationView {
            VStack {
                WebView(urlString: urlString) { extractedURL in
                    
                    
                    print("Extracted URL: \(extractedURL)")
                }

                // Ваш код для отображения других элементов интерфейса
                

            }
            .navigationBarTitle("Карта с камерами")
        }
    }
}

struct WebView: View {
    let urlString: String
    let onURLExtracted: (String) -> Void

    var body: some View {
        SwiftUIWebView(urlString: urlString, onURLExtracted: onURLExtracted)
    }
}

struct SwiftUIWebView: UIViewRepresentable {
    let urlString: String
    let onURLExtracted: (String) -> Void

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            webView.load(request)
        }
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        // Обновление WebView, если необходимо
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: SwiftUIWebView

        init(_ parent: SwiftUIWebView) {
            self.parent = parent
        }

        func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            if let url = navigationAction.request.url?.absoluteString {
                // Вызывается при каждой навигации, извлекаем URL и передаем в замыкание
                parent.onURLExtracted(url)
            }
            decisionHandler(.allow)
        }

        // Другие методы делегата WKNavigationDelegate
    }
}

#Preview{
    WebViewMap()
}
