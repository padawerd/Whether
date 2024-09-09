//
//  ErrorResponse.swift
//  Whether
//
//  Created by David Padawer on 9/7/24.
//

struct ErrorResponse: Codable {
    struct Error: Codable {
        let code: Int
        let message: String
    }
    let error: Error
}
