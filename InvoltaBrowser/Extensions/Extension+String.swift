//
//  Extension+String.swift
//  InvoltaBrowser
//
//  Created by Zhassulan Aimukhambetov on 07.05.2020.
//  Copyright © 2020 Zhassulan Aimukhambetov. All rights reserved.
//

import Foundation

extension String {
    func searchRequest() -> URLRequest {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "google.com"
        components.path = "/search"
        components.queryItems = [URLQueryItem(name: "q", value: self)]
        let url = components.url!
        return URLRequest(url: url)
    }
    func urlRequest() -> URLRequest {
        guard let url = URL(string: "https://\(self)") else { return self.searchRequest() }
        return URLRequest(url: url)
    }
}
