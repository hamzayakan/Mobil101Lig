# Contributing Guide

## 1. Amaç

Bu dokümanın amacı Mobil101Lig projesinde geliştirme süreçlerinin standartlarını belirlemektir.

Bu kurallar:

- Kod kalitesini korumak
- Geliştirme sürecini düzenlemek
- Hataları azaltmak
- Sürdürülebilir bir yazılım yapısı oluşturmak

amacıyla hazırlanmıştır.


---

# 2. Geliştirme Prensipleri

Projeye yapılacak tüm katkılar aşağıdaki prensiplere uygun olmalıdır.


## Temel İlkeler

- Clean Architecture korunmalıdır.
- Mevcut klasör yapısı bozulmamalıdır.
- Yeni özellikler feature bazlı geliştirilmelidir.
- Kod tekrarından kaçınılmalıdır.
- Business logic UI katmanında yazılmamalıdır.
- Güvenlik kuralları dikkate alınmalıdır.


---

# 3. Branch Stratejisi


Proje iki ana branch üzerinden yönetilir.


```
main
 |
 |
develop
 |
 |
feature/*
```


## main

Amaç:

- Stabil
- Yayına hazır
- Test edilmiş kod


Direkt commit yapılmaz.


---

## develop

Amaç:

- Günlük geliştirme branch'i
- Yeni özelliklerin birleştiği alan


Geliştirme başlangıç noktasıdır.


---

## Feature Branch


Yeni geliştirmeler için kullanılır.


Format:


```
feature/{özellik-adi}
```


Örnek:


```
feature/login

feature/firebase-auth

feature/game-score

feature/league-ranking
```


---

# 4. Yeni Özellik Geliştirme Süreci


Yeni bir özellik için:


## 1. Gereksinim Analizi

Önce:

- PRD kontrol edilir
- Mimari etkiler değerlendirilir
- Database ihtiyacı belirlenir


## 2. Branch Oluşturma


Örnek:


```
git checkout develop

git pull origin develop

git checkout -b feature/game-score
```


## 3. Geliştirme


Geliştirme sırasında:


- Kod standartlarına uyulmalı
- Test yazılmalı
- Gereksiz değişiklik yapılmamalıdır


## 4. Test


Kontrol:


```
flutter test
```


Kod analizi:


```
flutter analyze
```


## 5. Commit


Değişiklikler anlamlı commitlerle gönderilmelidir.


---

# 5. Commit Standartları


Commit format:


```
type: açıklama
```


## Kullanılacak Tipler


### feat

Yeni özellik


Örnek:


```
feat: add game score calculation
```


---

### fix

Bug düzeltme


Örnek:


```
fix: resolve login validation issue
```


---

### docs

Dokümantasyon değişikliği


Örnek:


```
docs: update firestore documentation
```


---

### refactor

Kod iyileştirme


Örnek:


```
refactor: simplify score calculator service
```


---

### test

Test değişiklikleri


Örnek:


```
test: add league ranking tests
```


---

### chore

Konfigürasyon değişiklikleri


Örnek:


```
chore: update dependencies
```



---

# 6. Pull Request Kuralları


Pull Request açılmadan önce:


Kontrol:


```
flutter analyze

flutter test
```


Başlık formatı:


```
type: açıklama
```


Örnek:


```
feat: implement scoreboard calculation
```



---

# 7. Pull Request Açıklaması


Her PR aşağıdaki bilgileri içermelidir.


## Değişiklik

Yapılan geliştirme açıklanmalıdır.


Örnek:


```
Yazboz ekranına dinamik oyuncu skor girişi eklendi.
```


## Teknik Detay

Kullanılan yaklaşım açıklanmalıdır.


Örnek:


```
ScoreCalculatorService oluşturuldu.
Firestore transaction kullanıldı.
```


## Test

Yapılan testler belirtilmelidir.


Örnek:


```
flutter test başarılı.
```


---

# 8. Kod Review Kuralları


Review sırasında kontrol edilir:


## Architecture


- Doğru katmanda mı?
- Dependency yönü doğru mu?


## Code Quality


- İsimlendirme uygun mu?
- Gereksiz karmaşıklık var mı?


## Performance


- Gereksiz Firebase çağrısı var mı?
- Gereksiz rebuild oluyor mu?


## Security


- Kullanıcı yetkileri kontrol edilmiş mi?
- Hassas bilgiler korunuyor mu?


---

# 9. Database Değişiklikleri


Firestore değişikliklerinde:


Zorunlu:


- Database dokümanı güncellenmeli
- Security rules kontrol edilmeli
- Index ihtiyacı değerlendirilmelidir


Örneğin:


Yeni collection:


```
gameResults
```


eklendiğinde:


Güncellenmesi gerekenler:


```
docs/03_DATABASE.md

firebase/collections.md

firebase/firestore.rules
```


---

# 10. Firebase Değişiklikleri


Firebase tarafında:


Dikkat edilmesi gerekenler:


- Client güvenilir kabul edilmemelidir.
- Kritik hesaplamalar doğrulanmalıdır.
- Yetki kontrolleri yapılmalıdır.


Özellikle:


- Skor hesaplama
- Lig sıralaması
- Oyuncu istatistikleri


kontrollü çalışmalıdır.


---

# 11. Test Gereksinimleri


Yeni özelliklerde:


## Zorunlu Testler


Business Logic:

```
Unit Test
```


UI:

```
Widget Test
```


Kritik akış:

```
Integration Test
```


Özellikle test edilmesi gerekenler:


- Kullanıcı girişi
- Oyun oluşturma
- Skor hesaplama
- Lig sıralaması


---

# 12. Dosya ve Klasör Kuralları


Yeni dosyalar:


Doğru:


```
features/game/domain/usecases/create_game.dart
```


Yanlış:


```
utils/game_helper.dart
```


Business logic uygun katmanda tutulmalıdır.


---

# 13. Dependency Yönetimi


Yeni paket eklenmeden önce:


Kontrol:


- Gerçek ihtiyaç var mı?
- Alternatif mevcut mu?
- Proje performansını etkiler mi?


Gereksiz paket kullanılmamalıdır.


---

# 14. Dokümantasyon Güncelleme


Aşağıdaki durumlarda ilgili doküman güncellenmelidir:


| Değişiklik | Güncellenecek Doküman |
|-|-|
| Yeni özellik | PRD |
| Mimari değişiklik | Architecture |
| Database değişikliği | Database |
| Firebase değişikliği | Firebase |
| UI değişikliği | UI/UX |
| Yeni kural | Game Rules |


---

# 15. Mobil101Lig Özel Kuralları


## Oyun Sistemi


101 oyun mantığında:


- Skor kayıtları silinmemelidir.
- Geçmiş oyun sonuçları korunmalıdır.
- Oyuncu istatistikleri geçmiş veriden hesaplanmalıdır.


## Yazboz Sistemi


Yazboz:


- Dinamik oyuncu sayısını desteklemeli
- Tur bazlı kayıt yapmalı
- Ceza/bonus eklenebilir olmalı
- Gelecekte yeni kurallar eklenebilir olmalıdır


## Lig Sistemi


Lig hesaplamaları:


- Merkezi servis üzerinden yapılmalıdır.
- Hard coded puan sistemi kullanılmamalıdır.
- Yeni puan algoritmaları desteklenebilir olmalıdır.


---

# 16. Katkı Sonrası Kontrol Listesi


Her geliştirme sonunda:


```
[ ] Kod formatlandı

[ ] Flutter analyze çalıştı

[ ] Testler geçti

[ ] Dokümantasyon güncellendi

[ ] Commit mesajı uygun

[ ] PR açıklaması hazır
```


---

# 17. Son Kural


Mobil101Lig projesinde yapılan her geliştirme:

- Okunabilir
- Test edilebilir
- Genişletilebilir
- Güvenli

olmalıdır.


Kısa vadeli çözümler yerine uzun vadeli sürdürülebilir yazılım yaklaşımı benimsenmelidir.