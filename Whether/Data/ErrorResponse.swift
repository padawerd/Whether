//
//  ErrorResponse.swift
//  Whether
//
//  Created by David Padawer on 9/7/24.
//

struct Error: Codable {
    let code: Int
    let message: String
}

struct ErrorResponse: Codable {
    let error: Error
}
