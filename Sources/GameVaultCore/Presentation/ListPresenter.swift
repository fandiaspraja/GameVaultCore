//
//  ListPresenter.swift
//  GameVaultCore
//

import Combine
import Foundation

/// Presenter generik untuk menampilkan daftar item dari sebuah use case.
/// Dapat diturunkan (subclass) oleh modul fitur untuk menambah aksi lain.
open class ListPresenter<Request, Item>: ObservableObject {
  @Published public private(set) var items: [Item] = []
  @Published public private(set) var state: ViewState = .idle

  private let useCase: AnyUseCase<Request, [Item]>
  private let errorMessage: (Error) -> String
  private var loadCancellable: AnyCancellable?

  public init(
    useCase: AnyUseCase<Request, [Item]>,
    errorMessage: @escaping (Error) -> String = { $0.localizedDescription }
  ) {
    self.useCase = useCase
    self.errorMessage = errorMessage
  }

  open func load(request: Request? = nil) {
    if items.isEmpty {
      state = .loading
    }
    loadCancellable = useCase.execute(request: request)
      .receive(on: DispatchQueue.main)
      .sink { [weak self] completion in
        guard let self, case .failure(let error) = completion else { return }
        self.state = .error(self.errorMessage(error))
      } receiveValue: { [weak self] items in
        self?.replaceItems(items)
      }
  }

  /// Mengganti isi daftar (dipakai subclass, mis. setelah menghapus item).
  public func replaceItems(_ newItems: [Item]) {
    items = newItems
    state = newItems.isEmpty ? .empty : .loaded
  }
}
