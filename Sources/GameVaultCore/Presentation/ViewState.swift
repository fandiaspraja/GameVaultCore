//
//  ViewState.swift
//  GameVaultCore
//

import Foundation

/// Status tampilan yang dipakai seluruh Presenter.
public enum ViewState: Equatable {
  case idle
  case loading
  case loaded
  case empty
  case error(String)
}
