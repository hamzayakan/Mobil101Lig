# 09 - Test Plan Document

## 1. Doküman Amacı

Bu dokümanın amacı Mobil101Lig uygulamasının kalite standartlarını belirlemek, test süreçlerini tanımlamak ve uygulamanın güvenilir, sürdürülebilir ve hatasız şekilde geliştirilmesini sağlamaktır.

Test süreçleri;

- Fonksiyonel doğruluk
- Kullanıcı deneyimi
- Veri bütünlüğü
- Firebase güvenliği
- Performans
- Uygulama stabilitesi

kapsamlarını içerir.

---

# 2. Test Stratejisi

Mobil101Lig projesinde aşağıdaki test seviyeleri uygulanacaktır.

## 2.1 Unit Test

Amaç:

Kod içerisindeki küçük parçaların doğru çalıştığını doğrulamak.

Test edilecek alanlar:

- Puan hesaplama algoritmaları
- Oyun sonucu hesaplama
- Lig sıralama hesaplama
- Ceza/bonus hesaplama
- Ortalama puan hesaplama
- Kullanıcı istatistik hesaplamaları
- Repository katmanı
- Utility sınıfları

Örnek:

Bir oyuncu;

- Kazanan
- Kaybeden
- Elde kalan ceza puanı

bilgileriyle oyunu tamamladığında doğru skor hesaplanmalıdır.

---

# 3. Widget Testleri

Flutter widget seviyesinde kullanıcı arayüzleri test edilir.

Test kapsamı:

## Login

Kontroller:

- Login ekranı açılıyor mu?
- Hatalı giriş mesajı gösteriliyor mu?
- Başarılı giriş sonrası yönlendirme yapılıyor mu?


## Yazboz Ekranı

Kontroller:

- Oyuncu sayısı seçilebiliyor mu?
- Oyuncular listeleniyor mu?
- Skor giriş alanları çalışıyor mu?
- Hesaplama butonu aktif oluyor mu?
- Sonuç doğru gösteriliyor mu?


## Lig Ekranı

Kontroller:

- Oyuncular listeleniyor mu?
- Sıralama doğru mu?
- Puan değişimleri gösteriliyor mu?


## İstatistik Ekranı

Kontroller:

- Toplam oyun sayısı
- Galibiyet
- Mağlubiyet
- Rakip geçmişi

doğru gösteriliyor mu?

---

# 4. Integration Test

Uygulamanın farklı katmanlarının birlikte çalışması test edilir.

Kapsam:

## Authentication Flow

Senaryo:

1. Kullanıcı uygulamayı açar.
2. Login olur.
3. Kullanıcı bilgileri Firebase'den alınır.
4. Ana ekrana yönlendirilir.

Beklenen:

Kullanıcı başarılı şekilde uygulamaya giriş yapmalıdır.

---

# 5. Oyun Oluşturma Testleri

## Senaryo 1

4 kişilik oyun oluşturma.

Girdi:

Oyuncular:

- Ali
- Ahmet
- Mehmet
- Hasan


Sonuç:

Oyun başarıyla oluşturulmalı.


---

## Senaryo 2

Lig içerisinde 10 kişi bulunmaktadır.

Ancak oyuna sadece 4 kişi katılır.

Beklenen:

- Sadece oynayan oyuncular skor alır.
- Katılmayan oyuncular etkilenmez.
- Lig puanı doğru güncellenir.

---

# 6. Yazboz Modülü Testleri

## Amaç

101 oyununun el bazlı skor giriş sisteminin doğruluğunu kontrol etmek.


## Test Senaryoları


### Senaryo 1

13 el oynanan oyun.


Giriş:

Her el sonunda:

- Oyuncu skorları
- Elde kalan puanlar
- Ceza puanları


Beklenen:

Sistem tüm elleri toplamalıdır.


---

### Senaryo 2

Ceza uygulanması.


Giriş:

Oyuncu belirlenen ceza kuralını ihlal eder.


Beklenen:

Ceza otomatik veya manuel olarak uygulanmalıdır.


---

### Senaryo 3

Bonus uygulanması.


Beklenen:

Bonus puan oyuncunun toplam skoruna eklenmelidir.


---

# 7. Lig Puanlama Testleri


## Ortalama Sistem Testi


Amaç:

Fazla oyun oynayan oyuncunun haksız avantaj sağlamasını engellemek.


Örnek:


Oyuncu A:

10 oyun

900 puan


Ortalama:

900 / 10 = 90


Oyuncu B:

2 oyun

200 puan


Ortalama:

200 / 2 = 100


Beklenen:

Sıralama ortalama puana göre yapılabilir.


---

# 8. Bonus ve Katılım Puanı Testleri


Amaç:

Oyuna katılım teşvik sistemi.


Örnek:


Oyuncu:

50 oyun oynadı.


Sistem:

Her oyun için +2 bonus verir.


Sonuç:

50 x 2 = 100 bonus puan


Kontrol:

Bonus doğru hesaplanmalıdır.


---

# 9. Rakip İstatistik Testleri


Amaç:

Oyuncuların birbirleriyle geçmiş performanslarını takip etmek.


Örnek:


Mehmet - Ali karşılaşmaları:


Toplam:

20 oyun


Mehmet:

13 galibiyet


Ali:

7 galibiyet


Beklenen:

Sistem doğru geçmiş bilgiyi göstermelidir.


---

# 10. Firebase Testleri


## Firestore


Kontroller:

- Veri kaydı başarılı mı?
- Yetkisiz kullanıcı veri okuyabiliyor mu?
- Yetkisiz kullanıcı veri değiştirebiliyor mu?


---

## Security Rules Test


Test:

Normal kullanıcı:

Lig verisini okuyabilir.


Ancak:

Başka kullanıcının skorunu değiştiremez.


---

# 11. Performans Testleri


Kontrol edilecek alanlar:


## Büyük Lig Testi

Senaryo:

500 oyunculu lig.


Beklenen:

- Listeleme performansı kabul edilebilir seviyede olmalı.
- Sayfa yükleme süresi düşük olmalı.


---

## Büyük Oyun Geçmişi


Senaryo:

Bir oyuncunun 5000 oyun geçmişi.


Beklenen:

İstatistik ekranı performans kaybetmemeli.


---

# 12. Offline Testleri


Amaç:

İnternet bağlantısı olmadığında davranış.


Kontroller:


- Offline durumda hata yönetimi
- Cache kullanımı
- Tekrar bağlantı sonrası senkronizasyon


---

# 13. UI/UX Testleri


Kontroller:


## Responsive Tasarım

Test cihazları:

- Küçük ekran telefon
- Büyük ekran telefon
- Tablet


Kontrol:

- Taşma olmamalı.
- Butonlar erişilebilir olmalı.


---

# 14. Regression Test


Her yeni geliştirmeden sonra aşağıdaki alanlar tekrar test edilir:


- Login
- Lig oluşturma
- Oyuncu ekleme
- Oyun oluşturma
- Yazboz hesaplama
- Skor güncelleme
- İstatistikler


---

# 15. Test Ortamları


## Development

Amaç:

Geliştirici testleri.


Firebase:

Development Firebase Project


---

## Test

Amaç:

QA testleri.


Firebase:

Test Firebase Project


---

## Production

Amaç:

Gerçek kullanıcı ortamı.


Firebase:

Production Firebase Project


---

# 16. CI/CD Test Süreci


Her Pull Request öncesi:


Çalıştırılacak işlemler:


1. Flutter analyze

```bash
flutter analyze
Unit test
flutter test
Build kontrolü

Android:

flutter build apk

iOS:

flutter build ios
17. Test Coverage Hedefleri

Minimum hedef:

Alan	Coverage
Domain Layer	%90
Use Case	%90
Repository	%80
Widget	%70
Genel	%80
18. Bug Yönetimi

Her hata aşağıdaki bilgiler ile kayıt edilir:

Başlık:

Kısa hata açıklaması.

Ortam:

Development
Test
Production

Adımlar:

Hatayı tekrar oluşturma adımları.

Beklenen:

Olması gereken davranış.

Gerçek:

Gerçekleşen davranış.

Önem Seviyesi:

Critical

Uygulama kullanılamıyor.

High

Ana özellik çalışmıyor.

Medium

Fonksiyon etkileniyor.

Low

Görsel veya küçük hata.

19. Release Öncesi Kontrol Listesi
Fonksiyonel

[ ] Login çalışıyor

[ ] Lig oluşturma çalışıyor

[ ] Oyuncu ekleme çalışıyor

[ ] Yazboz hesaplama doğru

[ ] Skor güncelleme doğru

[ ] İstatistikler doğru

Teknik

[ ] Testler başarılı

[ ] Analyze başarılı

[ ] Firebase rules kontrol edildi

[ ] Crash kontrol edildi

Release

[ ] Version artırıldı

[ ] Release note hazırlandı

[ ] Production build alındı

20. Gelecek Geliştirmeler İçin Test Yaklaşımı

Yeni özelliklerde:

Önce test senaryosu yazılır.
Kod geliştirilir.
Unit test eklenir.
Integration test yapılır.
Release öncesi regression çalıştırılır.

Bu yaklaşım ile Mobil101Lig uzun vadede sürdürülebilir ve güvenilir şekilde geliştirilecektir.