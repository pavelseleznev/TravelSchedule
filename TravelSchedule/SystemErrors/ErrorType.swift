//
//  ErrorType.swift
//  TravelSchedule
//
//  Created by Pavel Seleznev on 8/12/25.
//

import Foundation

enum ErrorType {
    case noInternet
    case serverError
    
    var title: String {
        switch self {
        case .noInternet:
            return "Нет интернета"
        case .serverError:
            return "Ошибка сервера"
        }
    }
    
    var imageName: String {
        switch self {
        case .noInternet:
            return "NoConnection"
        case .serverError:
            return "ServerError"
        }
    }
}
