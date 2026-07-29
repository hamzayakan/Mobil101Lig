# 10 - Release Plan Document

## 1. Doküman Amacı

Bu dokümanın amacı Mobil101Lig uygulamasının geliştirme sürecinden production yayın sürecine kadar olan release yönetimini tanımlamaktır.

Release plan aşağıdaki hedefleri kapsar:

- Kontrollü geliştirme süreci
- Stabil sürüm yönetimi
- Test süreçlerinin uygulanması
- Kullanıcıya kaliteli ürün sunulması
- Gelecek geliştirmelerin planlanması

---

# 2. Release Stratejisi

Mobil101Lig geliştirme süreci aşamalı olarak ilerleyecektir.


## Branch Stratejisi


Ana branch yapısı:



main
|
|
develop
|
|
feature branches



## Main Branch

Amaç:

Production'a çıkmaya hazır stabil kod.


Kurallar:

- Direkt kod gönderilmez.
- Sadece test edilmiş sürümler merge edilir.
- Her release sonrası tag oluşturulur.


Örnek:


v1.0.0
v1.1.0
v1.2.0



---

## Develop Branch

Amaç:

Aktif geliştirme alanı.


Kurallar:

- Yeni özellikler burada birleşir.
- Production öncesi test edilir.
- Stabil hale geldiğinde main'e merge edilir.


---

# 3. Release Aşamaları


Mobil101Lig aşağıdaki aşamalar ile geliştirilecektir.


# Phase 0 - Project Foundation


Durum:

Tamamlandı


Kapsam:


- Flutter proje kurulumu
- Clean Architecture yapısı
- Repository yapısı
- Dokümantasyon sistemi
- Git branch yapısı
- Coding standartları


Çıktı:


Temel geliştirme altyapısı hazır.


---

# Phase 1 - MVP Development


Hedef:

Çalışabilir ilk ürün.


Versiyon:


v0.1.0 MVP



Kapsam:


## Kullanıcı Yönetimi


- Kullanıcı oluşturma
- Login
- Profil bilgileri


## Lig Yönetimi


- Lig oluşturma
- Lig katılımı
- Oyuncu ekleme


## Oyun Yönetimi


- Oyun başlatma
- Oyuncu seçme
- Yazboz ekranı
- El skorlarının girilmesi


## Skor Sistemi


- Kazanan belirleme
- Kaybeden belirleme
- Lig puanı hesaplama


## Temel İstatistik


- Toplam oyun
- Galibiyet
- Mağlubiyet


Çıkış kriterleri:


[ ] Temel oyun akışı tamamlandı

[ ] Firebase bağlantısı tamamlandı

[ ] Kritik hatalar giderildi

[ ] Testler başarılı


---

# Phase 2 - Beta Release


Versiyon:



v0.5.0 Beta



Amaç:

Gerçek kullanıcı testleri.


Eklenen özellikler:


## Gelişmiş Lig Sistemi


- Ortalama puan sistemi
- Oyun sayısı etkisi
- Bonus puan sistemi
- Ceza sistemi


## Gelişmiş İstatistikler


- Rakip analizi
- İkili karşılaşma geçmişi
- Kazanma oranları


## Kullanıcı Deneyimi


- Animasyonlar
- Daha iyi hata mesajları
- Loading ekranları
- Empty state ekranları


Test:


- Kapalı beta kullanıcıları
- Gerçek oyun kayıtları
- Performans testleri


---

# Phase 3 - Production Release


Versiyon:



v1.0.0



Amaç:

İlk resmi yayın.


Kapsam:


## Stabil Özellikler


- Kullanıcı yönetimi
- Lig sistemi
- Oyun sistemi
- Yazboz ekranı
- Skor hesaplama
- İstatistik sistemi


## Production Hazırlıkları


- Firebase production ortamı
- Security rules kontrolü
- Crash monitoring
- Analytics


## Store Hazırlıkları


Android:

- APK/AAB oluşturma
- Google Play hazırlığı


iOS:

- IPA oluşturma
- App Store hazırlığı


---

# 4. Version Yönetimi


Semantic Versioning kullanılacaktır.


Format:



MAJOR.MINOR.PATCH



Örnek:



1.2.3



## MAJOR


Büyük değişiklik.


Örnek:



v2.0.0



Yeni mimari veya uyumsuz değişiklik.


---

## MINOR


Yeni özellik.


Örnek:



v1.3.0



Yeni:

- Yeni istatistik ekranı
- Yeni oyun modu


---

## PATCH


Hata düzeltmesi.


Örnek:



v1.3.1



Bug fix.


---

# 5. Release Süreci


Her release aşağıdaki adımlardan geçer.


## 1. Feature Tamamlama


Feature branch:


feature/*



üzerinde geliştirilir.


---

## 2. Code Review


Kontroller:


- Kod standartları
- Architecture uyumu
- Test durumu


---

## 3. Develop Merge


Feature:



feature/*



↓


develop



---

## 4. Test Süreci


Kontroller:


- Unit test
- Widget test
- Integration test
- Manuel test


---

## 5. Release Branch


Hazır olduğunda:



release/v1.0.0



oluşturulur.


Bu aşamada:

- Yeni özellik eklenmez.
- Sadece bug fix yapılır.


---

## 6. Production Merge


Release:



release/v1.0.0



↓


main



---

## 7. Tag Oluşturma


Örnek:


```bash
git tag v1.0.0

git push origin v1.0.0
6. CI/CD Release Pipeline

Her release öncesi:

Static Analysis
flutter analyze

Beklenen:

Hata olmamalı.

Test
flutter test

Beklenen:

Tüm testler başarılı.

Build

Android:

flutter build appbundle

iOS:

flutter build ios
7. Environment Yönetimi

Üç farklı ortam kullanılacaktır.

Development

Amaç:

Geliştirme.

Dosya:

.env.dev

Kullanım:

Test Firebase
Debug log
Test

Amaç:

QA.

Dosya:

.env.test

Kullanım:

Test kullanıcıları
Test Firebase
Production

Amaç:

Gerçek kullanıcı.

Dosya:

.env.prod

Kullanım:

Production Firebase
Analytics aktif
8. Release Checklist
Kod

[ ] Kod review tamamlandı

[ ] Branch temiz

[ ] Merge conflict yok

Test

[ ] Unit test başarılı

[ ] Integration test başarılı

[ ] Manuel test tamamlandı

Firebase

[ ] Security rules kontrol edildi

[ ] Indexler güncel

[ ] Backup kontrol edildi

Uygulama

[ ] Version artırıldı

[ ] Release note hazırlandı

[ ] Logo ve görseller hazır

Store

[ ] Android build alındı

[ ] iOS build alındı

[ ] Store açıklamaları hazırlandı

9. Hotfix Süreci

Production ortamında kritik hata olması durumunda:

Branch:

hotfix/*

Akış:

main

↓

hotfix

↓

main

Örnek:

hotfix/login-crash

Sonrasında:

Patch version artırılır.

Örnek:

v1.0.1
10. Release Notes Standardı

Her release aşağıdaki formatta hazırlanır.

Örnek:

# v1.0.0


## Yeni Özellikler

- Lig oluşturma eklendi
- Yazboz sistemi eklendi


## İyileştirmeler

- Performans geliştirildi


## Bug Fix

- Skor hesaplama hatası düzeltildi
11. Gelecek Release Planı
v1.1.0

Planlanan özellikler:

Daha gelişmiş istatistik ekranı
Grafik analizleri
Oyuncu performans karşılaştırması
v1.2.0

Planlanan özellikler:

Bildirim sistemi
Lig davet sistemi
Arkadaş sistemi
v2.0.0

Planlanan özellikler:

Online gerçek zamanlı oyun
Turnuva sistemi
Gelişmiş sıralama algoritmaları
12. Release Başarı Kriterleri

Bir sürüm yayınlanabilmesi için:

Kritik hata olmamalı.
Test coverage hedefleri sağlanmalı.
Firebase güvenlik kontrolleri tamamlanmalı.
Kullanıcı deneyimi kabul edilebilir seviyede olmalı.
Performans kabul kriterlerini sağlamalıdır.

Bu süreç ile Mobil101Lig sürdürülebilir, güvenilir ve profesyonel seviyede geliştirilecektir.