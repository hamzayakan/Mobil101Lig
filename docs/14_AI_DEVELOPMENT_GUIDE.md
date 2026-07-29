# AI Development Guide

## 1. Dokümanın Amacı

Bu dokümanın amacı, Mobil101Lig projesinde yapay zeka destekli geliştirme süreçlerinin standartlarını belirlemektir.

AI araçları (Cursor AI, ChatGPT vb.) kullanılırken:

- Proje mimarisine uygun kod üretmek
- Mevcut kod kalitesini korumak
- Gereksiz karmaşıklığı önlemek
- Clean Architecture prensiplerinden ayrılmamak
- Güvenli ve sürdürülebilir geliştirme yapmak

amaçlanmaktadır.

AI bir kod yazma aracı olarak değil, bir yazılım geliştirme yardımcısı olarak kullanılmalıdır.


---

# 2. AI Kullanım Prensipleri

## 2.1 Genel Kurallar

AI tarafından oluşturulan hiçbir kod direkt olarak projeye eklenmemelidir.

Her zaman:

1. Üretilen kod incelenmeli
2. Mimariye uygunluğu kontrol edilmeli
3. Gereksiz bağımlılıklar kaldırılmalı
4. Test edilmelidir


AI çıktısı:


Generate → Review → Refactor → Test → Commit


akışı ile kullanılmalıdır.


---

# 3. Proje Bağlamı

AI ile çalışırken aşağıdaki proje bilgileri temel alınmalıdır.


## Proje

Mobil101Lig


## Teknoloji Stack

Frontend:

- Flutter
- Dart


Architecture:

- Clean Architecture
- Feature Based Architecture


State Management:

- Riverpod


Backend:

- Firebase


Database:

- Cloud Firestore


Authentication:

- Firebase Authentication


Storage:

- Firebase Storage


Analytics:

- Firebase Analytics


Crash Reporting:

- Firebase Crashlytics



---

# 4. Kod Üretim Standartları


## 4.1 Genel Kod Kuralları

AI tarafından oluşturulan kod:

- Okunabilir olmalıdır
- SOLID prensiplerine uygun olmalıdır
- Tek sorumluluk prensibini takip etmelidir
- Gereksiz abstraction içermemelidir
- Test edilebilir olmalıdır


Yanlış:

```dart
class UserManagerHelperServiceController {
}

Doğru:

class UserRepository {
}
5. Flutter Kodlama Standartları
5.1 Feature Yapısı

Yeni özellikler aşağıdaki yapıya uygun oluşturulmalıdır.

Örnek:

features/
 └── league/
      ├── data/
      │    ├── datasource/
      │    ├── models/
      │    └── repositories/
      │
      ├── domain/
      │    ├── entities/
      │    ├── repositories/
      │    └── usecases/
      │
      └── presentation/
           ├── pages/
           ├── widgets/
           └── providers/

AI yeni ekran veya özellik oluştururken bu yapıya uymalıdır.

6. AI Prompt Standartları
6.1 Özellik Geliştirme Prompt Örneği

Kullanılacak format:

Bu Mobil101Lig Flutter projesidir.

Clean Architecture kullanıyoruz.

Yeni bir feature geliştir.

Kurallar:

- Feature based architecture kullan
- Repository pattern kullan
- Riverpod state management kullan
- Firebase entegrasyonunu dikkate al
- Test edilebilir kod yaz
- Mevcut klasör yapısını bozma

Özellik:

[özellik açıklaması]
7. Kod Değişikliği Öncesi AI Kontrolü

AI'dan kod değişikliği istenirken:

Önce:

Bu dosyanın mevcut yapısını analiz et.

Değişiklik öncesi:
- bağımlılıkları
- kullanılan patternleri
- olası etkileri

açıkla.

Daha sonra implementasyon yapılmalıdır.

8. Database AI Kullanım Kuralları

Firestore değişikliklerinde AI:

Kontrol etmelidir:

Collection yapısı
Document ilişkileri
Index ihtiyacı
Security Rules etkisi

Örnek:

Yanlış:

users
   games
      scores

Doğru:

users

games

leagueMembers

gameResults

playerStatistics
9. Firebase Kodlama Kuralları

AI Firebase kodu üretirken:

Dikkat edilmesi gerekenler:

Client tarafında kritik hesap yapılmamalı
Yetki kontrolleri Security Rules içinde olmalı
Sensitive bilgiler tutulmamalı
Transaction kullanılmalı

Örneğin:

Skor güncelleme:

Yanlış:

puan = mevcutPuan + yeniPuan

Doğru:

Firestore Transaction
+
Server validation
10. Oyun Skoru ve Lig Mantığı İçin AI Kuralları

Mobil101Lig temel sistemi:

AI aşağıdaki kuralları dikkate almalıdır.

Oyun Sonucu

Bir oyun:

Game
 |
 |-- Players
 |
 |-- Scores
 |
 |-- Result

olarak modellenmelidir.

Skor Hesaplama

AI hiçbir zaman sabit puan mantığı yazmamalıdır.

Yanında:

ScoreCalculatorService

gibi ayrı servis oluşturmalıdır.

Örnek:

Base Score
+
Game Count Bonus
+
Performance Bonus
-
Penalty

şeklinde genişletilebilir olmalıdır.

11. Yazboz Sistemi İçin AI Kuralları

Yazboz ekranı:

Dinamik olmalıdır.

Desteklenmesi gerekenler:

Oyuncu sayısı seçimi
Tur ekleme
Tur silme
Ceza ekleme
Bonus ekleme
El sonucu girme
Otomatik hesaplama

Model:

ScoreBoard

 ├── GameSession

 ├── Round

 │     ├── PlayerScore

 │     ├── Penalty

 │     └── Bonus

 └── Result

şeklinde tasarlanmalıdır.

12. Test Yazım Kuralları

AI yeni özellik geliştirirken:

Minimum:

Unit Test

Zorunlu:

Business logic
Score calculation
Ranking calculation
Widget Test

Zorunlu:

Kritik ekranlar
Integration Test

Zorunlu:

Login
Game creation
Score submission
13. Refactoring Kuralları

AI refactoring yaparken:

Yapılacaklar:

Önce mevcut davranışı analiz et
Testleri koru
Büyük değişiklikleri küçük parçalara böl
Breaking change oluşturma
14. Commit Mesaj Standardı

AI commit mesajlarını aşağıdaki formatta önermelidir.

type: açıklama

Tipler:

feat:
Yeni özellik


fix:
Hata düzeltme


refactor:
Kod iyileştirme


docs:
Dokümantasyon


test:
Test değişikliği


chore:
Konfigürasyon değişikliği

Örnek:

feat: add league ranking calculation
15. Branch Kullanımı

Proje ana geliştirme yapısı:

main

|
|
develop

|
|
feature/*

AI geliştirme sırasında:

Direkt main üzerinde değişiklik önermemelidir.

Önerilen akış:

develop

↓

feature/new-feature

↓

pull request

↓

develop

↓

main release
16. AI Kod Review Checklist

Her AI çıktısından sonra kontrol:

Architecture

[ ] Clean Architecture uygun mu?

[ ] Feature yapısı korunuyor mu?

Code Quality

[ ] Gereksiz tekrar var mı?

[ ] Naming doğru mu?

Security

[ ] Firebase güvenliği uygun mu?

[ ] Kullanıcı verileri korunuyor mu?

Performance

[ ] Gereksiz Firebase çağrısı var mı?

[ ] Widget rebuild problemi var mı?

Testing

[ ] Test yazıldı mı?

17. Yasak Yaklaşımlar

AI aşağıdaki yaklaşımları kullanmamalıdır.

❌ Global değişkenler

❌ Business logic widget içinde

❌ Firebase çağrısı direkt UI içinde

❌ Hard coded skor değerleri

❌ Büyük tek dosya yapıları

❌ Gereksiz paket kullanımı

18. Gelecekteki AI Kullanımı

AI aşağıdaki alanlarda aktif kullanılacaktır:

Yeni feature geliştirme
Kod analizi
Refactoring
Test oluşturma
Dokümantasyon
Firebase rule kontrolü
Performans analizi
UI geliştirme
19. Son Kural

Mobil101Lig projesinde AI:

"Kodu yazan kişi"

değil,

"mimariye uygun kaliteli yazılım geliştirmeye yardımcı olan teknik ekip üyesi"

olarak kullanılmalıdır.

Tüm AI çıktıları proje standartlarına uygun olmak zorundadır.