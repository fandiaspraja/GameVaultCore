//
//  TestDoubles.swift
//  GameVaultCoreTests
//

import Combine
import Foundation
@testable import GameVaultCore
import XCTest

struct StubRepository: Repository {
  let result: Result<String, Error>
  var onRequest: ((Int?) -> Void)?

  func execute(request: Int?) -> AnyPublisher<String, Error> {
    onRequest?(request)
    return result.publisher.eraseToAnyPublisher()
  }
}

struct StubDataSource: DataSource {
  let value: Int

  func execute(request: Void?) -> AnyPublisher<Int, Error> {
    Just(value).setFailureType(to: Error.self).eraseToAnyPublisher()
  }
}

struct DoubleToTextMapper: Mapper {
  func transform(_ input: Int) -> String {
    "value-\(input * 2)"
  }
}

extension XCTestCase {
  /// Menjalankan run loop utama sampai `condition` terpenuhi (untuk publisher yang
  /// menerima nilai di `DispatchQueue.main`).
  func waitUntil(
    timeout: TimeInterval = 1,
    file: StaticString = #filePath,
    line: UInt = #line,
    _ condition: () -> Bool
  ) {
    let deadline = Date().addingTimeInterval(timeout)
    while !condition() && Date() < deadline {
      RunLoop.current.run(until: Date().addingTimeInterval(0.01))
    }
    XCTAssertTrue(condition(), "Kondisi tidak terpenuhi dalam \(timeout) detik", file: file, line: line)
  }

  func firstValue<P: Publisher>(of publisher: P, timeout: TimeInterval = 1) throws -> P.Output {
    var result: Result<P.Output, Error>?
    let expectation = self.expectation(description: "publisher")
    let cancellable = publisher.sink { completion in
      if case .failure(let error) = completion {
        result = .failure(error)
      }
      expectation.fulfill()
    } receiveValue: { value in
      result = .success(value)
    }
    wait(for: [expectation], timeout: timeout)
    cancellable.cancel()
    return try XCTUnwrap(result).get()
  }
}
