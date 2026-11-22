//
//  ItemPresenter.swift
//  GameVaultCore
//

import Combine
import Foundation

/// Presenter generik untuk menampilkan satu item (mis. halaman detail).
open class ItemPresenter<Request, Item>: ObservableObject {
  @Published public private(set) var item: Item?
  @Published public private(set) var state: ViewState = .idle

  private let useCase: AnyUseCase<Request, Item>
  private let errorMessage: (Error) -> String
  private var loadCancellable: AnyCancellable?

  public init(
    useCase: AnyUseCase<Request, Item>,
    errorMessage: @escaping (Error) -> String = { $0.localizedDescription }
  ) {
    self.useCase = useCase
    self.errorMessage = errorMessage
  }

  open func load(request: Request?) {
    state = .loading
    loadCancellable = useCase.execute(request: request)
      .receive(on: DispatchQueue.main)
      .sink { [weak self] completion in
        guard let self, case .failure(let error) = completion else { return }
        self.state = .error(self.errorMessage(error))
      } receiveValue: { [weak self] item in
        self?.item = item
        self?.state = .loaded
      }
  }
}
