//
//  Repository.swift
//  GameVaultCore
//

import Combine

/// Kontrak generik repository: sumber kebenaran data untuk Domain Layer.
public protocol Repository {
  associatedtype Request
  associatedtype Response

  func execute(request: Request?) -> AnyPublisher<Response, Error>
}

/// Repository generik yang mengambil data dari `DataSource` remote lalu
/// mengubahnya menjadi model domain menggunakan `Mapper`.
public struct RemoteRepository<Remote: DataSource, Transformer: Mapper>: Repository
where Remote.Response == Transformer.Input {
  public typealias Request = Remote.Request
  public typealias Response = Transformer.Output

  private let remote: Remote
  private let mapper: Transformer

  public init(remote: Remote, mapper: Transformer) {
    self.remote = remote
    self.mapper = mapper
  }

  public func execute(request: Remote.Request?) -> AnyPublisher<Transformer.Output, Error> {
    let mapper = self.mapper
    return remote.execute(request: request)
      .map { mapper.transform($0) }
      .eraseToAnyPublisher()
  }
}
