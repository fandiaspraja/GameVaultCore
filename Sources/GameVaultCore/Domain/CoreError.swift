//
//  CoreError.swift
//  GameVaultCore
//

import Foundation

/// Error umum yang dipahami semua layer. Pesan yang ditampilkan ke pengguna
/// dilokalisasi oleh modul presentasi (lihat `ErrorMessage` di modul Common).
public enum CoreError: LocalizedError, Equatable {
  case noConnection
  case unauthorized
  case server(statusCode: Int?)
  case decoding
  case database(String)
  case notFound
  case invalidRequest

  public var errorDescription: String? {
    switch self {
    case .noConnection: return "No internet connection."
    case .unauthorized: return "Invalid or missing API key."
    case .server(let code): return "Server error\(code.map { " (\($0))" } ?? "")."
    case .decoding: return "Unable to read the server response."
    case .database(let message): return "Local storage error. \(message)"
    case .notFound: return "Data not found."
    case .invalidRequest: return "Invalid request."
    }
  }
}
