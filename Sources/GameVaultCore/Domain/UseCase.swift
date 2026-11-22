//
//  UseCase.swift
//  GameVaultCore
//

import Combine

/// Kontrak generik untuk setiap use case (business logic) di Domain Layer.
public protocol UseCase {
  associatedtype Request
  associatedtype Response

  func execute(request: Request?) -> AnyPublisher<Response, Error>
}

/// Use case generik yang meneruskan permintaan ke sebuah `Repository`.
/// Dipakai untuk use case sederhana yang tidak membutuhkan logika tambahan.
public struct Interactor<Request, Response, R: Repository>: UseCase
where R.Request == Request, R.Response == Response {
  private let repository: R

  public init(repository: R) {
    self.repository = repository
  }

  public func execute(request: Request?) -> AnyPublisher<Response, Error> {
    repository.execute(request: request)
  }
}

/// Type-erasure untuk `UseCase` agar Presenter tidak bergantung pada tipe konkret.
public struct AnyUseCase<Request, Response>: UseCase {
  private let executor: (Request?) -> AnyPublisher<Response, Error>

  public init<U: UseCase>(_ useCase: U) where U.Request == Request, U.Response == Response {
    executor = { useCase.execute(request: $0) }
  }

  public init(_ executor: @escaping (Request?) -> AnyPublisher<Response, Error>) {
    self.executor = executor
  }

  public func execute(request: Request?) -> AnyPublisher<Response, Error> {
    executor(request)
  }
}

public extension UseCase {
  func eraseToAnyUseCase() -> AnyUseCase<Request, Response> {
    AnyUseCase(self)
  }
}
