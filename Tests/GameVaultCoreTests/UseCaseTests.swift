//
//  UseCaseTests.swift
//  GameVaultCoreTests
//

import Combine
@testable import GameVaultCore
import XCTest

final class UseCaseTests: XCTestCase {
  func testInteractor_forwardsRequestToRepository() throws {
    var receivedRequest: Int?
    let repository = StubRepository(result: .success("ok")) { receivedRequest = $0 }
    let sut = Interactor(repository: repository)

    let value = try firstValue(of: sut.execute(request: 7))

    XCTAssertEqual(value, "ok")
    XCTAssertEqual(receivedRequest, 7)
  }

  func testInteractor_propagatesRepositoryError() {
    let sut = Interactor(repository: StubRepository(result: .failure(CoreError.notFound)))

    XCTAssertThrowsError(try firstValue(of: sut.execute(request: nil))) { error in
      XCTAssertEqual(error as? CoreError, .notFound)
    }
  }

  func testAnyUseCase_wrapsConcreteUseCase() throws {
    let sut = Interactor(repository: StubRepository(result: .success("erased"))).eraseToAnyUseCase()

    XCTAssertEqual(try firstValue(of: sut.execute(request: 1)), "erased")
  }

  func testAnyUseCase_closureInitializer() throws {
    let sut = AnyUseCase<Int, Int> { request in
      Just((request ?? 0) + 1).setFailureType(to: Error.self).eraseToAnyPublisher()
    }

    XCTAssertEqual(try firstValue(of: sut.execute(request: 41)), 42)
  }

  func testRemoteRepository_mapsResponseWithMapper() throws {
    let sut = RemoteRepository(remote: StubDataSource(value: 21), mapper: DoubleToTextMapper())

    XCTAssertEqual(try firstValue(of: sut.execute(request: nil)), "value-42")
  }

  func testCoreError_hasReadableDescription() {
    XCTAssertEqual(CoreError.server(statusCode: 500).errorDescription, "Server error (500).")
    XCTAssertNotNil(CoreError.noConnection.errorDescription)
  }
}
