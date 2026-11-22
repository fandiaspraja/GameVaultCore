//
//  DataSource.swift
//  GameVaultCore
//

import Combine

/// Kontrak generik untuk sumber data remote (API).
public protocol DataSource {
  associatedtype Request
  associatedtype Response

  func execute(request: Request?) -> AnyPublisher<Response, Error>
}

/// Kontrak generik untuk sumber data lokal (database).
public protocol LocalDataSource {
  associatedtype Request
  associatedtype Response

  func list(request: Request?) -> AnyPublisher<[Response], Error>
  func get(id: Int) -> AnyPublisher<Response?, Error>
  func add(entity: Response) -> AnyPublisher<Bool, Error>
  func delete(id: Int) -> AnyPublisher<Bool, Error>
}

/// Kontrak generik untuk mengubah satu model menjadi model lain
/// (Response -> Domain, Entity -> Domain, Domain -> Entity).
public protocol Mapper {
  associatedtype Input
  associatedtype Output

  func transform(_ input: Input) -> Output
}
