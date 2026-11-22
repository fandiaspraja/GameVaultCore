# GameVaultCore

[![CI](https://github.com/YOUR_GITHUB_USERNAME/GameVaultCore/actions/workflows/ci.yml/badge.svg)](https://github.com/YOUR_GITHUB_USERNAME/GameVaultCore/actions/workflows/ci.yml)

Modul **Core** untuk aplikasi [GameVault](https://github.com/YOUR_GITHUB_USERNAME/GameVault).
Isinya hanya *generic protocol* dan komponen generik Clean Architecture, sehingga bisa
dipakai ulang oleh modul fitur mana pun.

| Layer | Komponen |
|---|---|
| Domain | `UseCase`, `Interactor<Request, Response, R>`, `AnyUseCase<Request, Response>`, `CoreError` |
| Data | `Repository`, `RemoteRepository<Remote, Transformer>`, `DataSource`, `LocalDataSource`, `Mapper` |
| Presentation | `ViewState`, `ListPresenter<Request, Item>`, `ItemPresenter<Request, Item>` |

## Instalasi (Swift Package Manager)

```swift
.package(url: "https://github.com/YOUR_GITHUB_USERNAME/GameVaultCore.git", from: "1.0.0")
```

Atau di Xcode: **File ▸ Add Package Dependencies…**, lalu tempel URL repo ini.

## Contoh

```swift
let repository = RemoteRepository(remote: GamesRemoteDataSource(client: client), mapper: GamesMapper())
let useCase = Interactor(repository: repository).eraseToAnyUseCase()
let presenter = ListPresenter<Void, FavoriteGame>(useCase: getFavoritesUseCase)
```

Platform: iOS 16+, macOS 13+. Lisensi MIT.
