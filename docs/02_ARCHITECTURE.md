# 02 - Application Architecture Document

## 1. Document Purpose

Bu dokümanın amacı, Mobil101Lig uygulamasının teknik mimarisini, kullanılan teknolojileri, geliştirme prensiplerini ve uygulama katmanlarının sorumluluklarını tanımlamaktır.

Bu mimari kararlar;

- Ölçeklenebilirlik
- Bakım kolaylığı
- Yeni özellik ekleme kolaylığı
- Test edilebilirlik
- Güvenli geliştirme süreçleri

hedeflenerek hazırlanmıştır.

---

# 2. Architecture Overview

Mobil101Lig uygulaması Flutter tabanlı mobil uygulama olarak geliştirilecektir.

Temel mimari yaklaşım:

- Clean Architecture
- Feature Based Architecture
- Repository Pattern
- Dependency Injection
- Reactive State Management
- Firebase Backend Services

olarak belirlenmiştir.

Genel mimari:


Presentation Layer
|
|
Domain Layer
|
|
Data Layer
|
|
Firebase / External Services


---

# 3. Technology Stack

## Mobile Application

| Teknoloji | Kullanım |
|---|---|
| Flutter | Mobil uygulama geliştirme |
| Dart | Programlama dili |
| Riverpod | State management |
| GoRouter | Navigation |
| Firebase | Backend servisleri |
| Cloud Firestore | Database |
| Firebase Authentication | Kullanıcı yönetimi |
| Firebase Storage | Dosya yönetimi |
| Firebase Analytics | Kullanıcı analizi |
| Firebase Crashlytics | Hata takibi |

---

# 4. Project Structure

Uygulama feature bazlı organize edilmiştir.


lib/

├── core
│
├── features
│
├── shared
│
├── services
│
├── routes
│
├── theme
│
└── main.dart


---

# 5. Clean Architecture Layers

## 5.1 Presentation Layer

Kullanıcı arayüzü ve kullanıcı etkileşimlerinden sorumludur.

İçerir:

- Pages
- Widgets
- Controllers
- Providers
- UI State Management


Örnek:


features/game/presentation

game_page.dart
game_controller.dart
game_state.dart
widgets/


Sorumlulukları:

- Kullanıcı hareketlerini almak
- UI durumunu yönetmek
- Domain katmanını çağırmak


---

## 5.2 Domain Layer

Uygulamanın iş kurallarının bulunduğu katmandır.

Framework bağımsızdır.

İçerir:

- Entities
- Use Cases
- Repository Interfaces


Örnek:


features/game/domain

entities/
game.dart

usecases/
calculate_score.dart

repositories/
game_repository.dart


Sorumlulukları:

- 101 oyun kurallarını uygulamak
- Skor hesaplamak
- Lig puanı hesaplamak
- Oyuncu istatistiklerini üretmek

---

## 5.3 Data Layer

Veri erişim işlemlerinden sorumludur.

İçerir:

- Models
- Data Sources
- Repository Implementations


Örnek:


features/game/data

models/

datasources/

repositories/


Sorumlulukları:

- Firebase bağlantısı
- Veri kaydetme
- Veri okuma
- Cache yönetimi


---

# 6. Feature Architecture

Her ana özellik kendi bağımsız modülüne sahiptir.



features/

auth/

game/

league/

home/

profile/

statistics/

settings/


Her feature:


feature

├── data

├── domain

└── presentation


yapısında olacaktır.


---

# 7. Core Layer

Uygulama genelinde kullanılan ortak yapılar burada bulunur.



core/

├── constants

├── errors

├── extensions

├── helpers

├── network

├── storage

├── utils

└── widgets


Örnek:

- Genel hata yönetimi
- Network işlemleri
- Ortak componentler
- Utility sınıfları


---

# 8. State Management

State management olarak Riverpod kullanılacaktır.

Amaç:

- Global state kontrolü
- Reactive UI
- Test edilebilir yapı
- Gereksiz rebuild azaltılması


Örnek:


GameProvider

LeagueProvider

AuthProvider

ProfileProvider


---

# 9. Dependency Injection

Dependency injection merkezi olarak yönetilecektir.

Kullanım amacı:

- Loose coupling
- Test kolaylığı
- Servis değişimlerinde kolaylık


Konum:


config/di


İçerisinde:

- Repository kayıtları
- Service kayıtları
- Provider tanımları

bulunacaktır.


---

# 10. Navigation Architecture

Navigation yönetimi GoRouter ile yapılacaktır.


Route yapısı:


routes/

app_router.dart

route_names.dart


Örnek:


/login

/home

/league/:id

/game/:id

/profile

/statistics



---

# 11. Game Engine Architecture

101 oyunu için oyun kuralları uygulama içerisinde bağımsız servis olarak tasarlanacaktır.


Amaç:

Kurallar değiştiğinde UI veya database yapısını değiştirmeden geliştirme yapabilmek.


Örnek yapı:


features/game/domain

entities/

Game

PlayerScore

Round

usecases/

CalculateRoundScore

CalculateLeagueScore

CalculatePlayerRanking



---

# 12. Score Calculation Architecture

Skor hesaplama sistemi dinamik olacaktır.


Desteklenecek yapı:

- Kazanan puanı
- Kaybeden ceza puanı
- Elde kalan taş puanı
- Ek bonus puanları
- Oyun başına katkı
- Rakip performansı


Örnek:



ScoreCalculationEngine

input:

players

round results

penalties

bonus rules

output:

player scores

ranking

statistics



---

# 13. League Architecture

Lig sistemi bağımsız modül olarak geliştirilecektir.


Lig içerisinde:

- Oyuncular
- Oyun geçmişi
- Sıralama
- İstatistikler
- Rakip analizleri


tutulacaktır.


Örnek:


League

Players

Matches

Rankings

Statistics


---

# 14. Firebase Architecture

Firebase backend olarak kullanılacaktır.


Servisler:

## Authentication

Kullanıcı giriş sistemi.


## Firestore

Ana veri kaynağı.


## Storage

Profil fotoğrafı ve medya dosyaları.


## Analytics

Kullanıcı davranış analizi.


## Crashlytics

Uygulama hata takibi.


---

# 15. Security Architecture

Güvenlik prensipleri:

- Firebase Security Rules kullanılacak
- Kullanıcı yetkilendirmesi yapılacak
- Hassas bilgiler client tarafında tutulmayacak
- Validation backend tarafında kontrol edilecek


---

# 16. Testing Strategy

Test seviyeleri:


## Unit Test

Domain kuralları test edilir.

Örnek:

- Skor hesaplama
- Ceza hesaplama
- Lig puanı hesaplama


## Widget Test

UI component testleri.


## Integration Test

Gerçek kullanıcı senaryoları.


---

# 17. Development Principles

Kod geliştirme prensipleri:


- SOLID prensipleri
- Clean Code
- Single Responsibility
- DRY
- Repository Pattern
- Meaningful naming
- Automated testing


---

# 18. Future Scalability

Mimari aşağıdaki geliştirmelere hazır olacaktır:


- Çoklu lig desteği
- Online gerçek zamanlı oyun
- Turnuva sistemi
- Arkadaş ekleme
- Davet sistemi
- Sezon yönetimi
- Gelişmiş oyuncu analizi
- Yapay zeka destekli istatistik yorumları


---

# 19. Architecture Decision Summary

Mobil101Lig;

Flutter + Clean Architecture + Firebase tabanlı,

feature-oriented,

ölçeklenebilir,

değişen 101 oyun kurallarına uyum sağlayabilecek

profesyonel mobil uygulama mimarisi ile geliştirilecektir.