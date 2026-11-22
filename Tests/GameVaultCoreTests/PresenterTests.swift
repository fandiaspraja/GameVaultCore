//
//  PresenterTests.swift
//  GameVaultCoreTests
//

import Combine
@testable import GameVaultCore
import XCTest

final class PresenterTests: XCTestCase {
  // MARK: - ListPresenter

  func testListPresenter_whenItemsReturned_stateIsLoaded() {
    let sut = ListPresenter<Void, String>(useCase: AnyUseCase { _ in
      Just(["a", "b"]).setFailureType(to: Error.self).eraseToAnyPublisher()
    })

    sut.load()

    waitUntil { sut.state == .loaded }
    XCTAssertEqual(sut.items, ["a", "b"])
  }

  func testListPresenter_whenNoItems_stateIsEmpty() {
    let sut = ListPresenter<Void, String>(useCase: AnyUseCase { _ in
      Just([]).setFailureType(to: Error.self).eraseToAnyPublisher()
    })

    sut.load()

    waitUntil { sut.state == .empty }
  }

  func testListPresenter_whenFailure_usesCustomErrorMessage() {
    let sut = ListPresenter<Void, String>(
      useCase: AnyUseCase { _ in Fail(error: CoreError.noConnection).eraseToAnyPublisher() },
      errorMessage: { _ in "offline" }
    )

    sut.load()

    waitUntil { sut.state == .error("offline") }
  }

  func testListPresenter_replaceItems_updatesState() {
    let sut = ListPresenter<Void, String>(useCase: AnyUseCase { _ in Empty().eraseToAnyPublisher() })

    sut.replaceItems(["x"])
    XCTAssertEqual(sut.state, .loaded)

    sut.replaceItems([])
    XCTAssertEqual(sut.state, .empty)
  }

  // MARK: - ItemPresenter

  func testItemPresenter_loadsItemForRequest() {
    let sut = ItemPresenter<Int, String>(useCase: AnyUseCase { request in
      Just("item-\(request ?? 0)").setFailureType(to: Error.self).eraseToAnyPublisher()
    })

    sut.load(request: 5)

    waitUntil { sut.state == .loaded }
    XCTAssertEqual(sut.item, "item-5")
  }

  func testItemPresenter_whenFailure_stateIsError() {
    let sut = ItemPresenter<Int, String>(useCase: AnyUseCase { _ in
      Fail(error: CoreError.notFound).eraseToAnyPublisher()
    })

    sut.load(request: 1)

    waitUntil { sut.state == .error(CoreError.notFound.localizedDescription) }
    XCTAssertNil(sut.item)
  }
}
