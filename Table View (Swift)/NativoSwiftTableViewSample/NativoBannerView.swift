//
//  NativoBannerView.swift
//  NativoSwiftTableViewSample
//
//  Created by Matthew Murray on 10/27/22.
//  Copyright © 2022 Nativo. All rights reserved.
//

import Foundation
import NativoSDK

class NativoBannerView: UIView, NtvStandardDisplayAdInterface {
    
    lazy var contentWebView : NtvContentWebView! = {
        let config = WKWebViewConfiguration()
        let ntvWeb = NtvContentWebView(frame: self.bounds, configuration: config)
        self.addSubview(ntvWeb)
        ntvWeb.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        ntvWeb.topAnchor.constraint(equalTo: self.topAnchor, constant: 12).isActive = true
        ntvWeb.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -12).isActive = true
        self.backgroundColor = UIColor(red: 0.949, green: 0.949, blue: 0.949, alpha: 1.000)
        return ntvWeb
    }()
}


