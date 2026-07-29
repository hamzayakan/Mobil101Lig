# 11 - Product Roadmap Document

## 1. Doküman Amacı

Bu dokümanın amacı Mobil101Lig uygulamasının kısa, orta ve uzun vadeli geliştirme planını belirlemektir.

Roadmap aşağıdaki hedefleri kapsar:

- MVP ürünün ortaya çıkarılması
- Kullanıcı geri bildirimleri ile geliştirme
- Yeni oyun özelliklerinin eklenmesi
- Ölçeklenebilir lig sistemi oluşturulması
- Profesyonel oyun platformuna dönüşüm


---

# 2. Ürün Vizyonu

Mobil101Lig sadece bir skor takip uygulaması değil;

101 oyunu oynayan kullanıcıların:

- Lig oluşturabildiği
- Arkadaşlarını ekleyebildiği
- Oyun sonuçlarını kaydedebildiği
- Performanslarını takip edebildiği
- Rekabet oluşturabildiği

dijital bir oyun platformu olacaktır.


---

# 3. Roadmap Genel Bakış



Phase 1
|
|-- MVP Temel Sistem
|
Phase 2
|
|-- Gelişmiş Lig ve İstatistik
|
Phase 3
|
|-- Sosyal Özellikler
|
Phase 4
|
|-- Rekabet ve Turnuva Sistemi
|
Phase 5
|
|-- Platform Genişleme



---

# Phase 0 - Project Foundation

## Durum

Tamamlandı


## Kapsam


- Flutter proje kurulumu
- Clean Architecture
- Firebase altyapısı
- Git stratejisi
- Proje dokümantasyonu
- Kod standartları


## Çıktı


Profesyonel geliştirme altyapısı hazırlandı.


---

# Phase 1 - MVP Release

## Hedef

Çalışabilir ilk ürünün hazırlanması.


Versiyon:



v0.1.0



---

# 1. Kullanıcı Yönetimi


Özellikler:


- Kullanıcı kayıt
- Login
- Profil oluşturma
- Kullanıcı bilgileri


Gelecek geliştirme:


- Profil fotoğrafı
- Kullanıcı seviyesi
- Başarı rozetleri


---

# 2. Lig Sistemi


Amaç:

Arkadaş gruplarının kendi liglerini oluşturabilmesi.


Özellikler:


- Lig oluşturma
- Lig adı belirleme
- Oyuncu ekleme
- Lig üyelerini görüntüleme


Örnek:



101 Ligimiz

10 oyuncu



---

# 3. Oyun Oluşturma


Özellikler:


- Oyuncu seçimi
- Tekli oyun
- Eşli oyun desteği


Örnek:


Lig:

10 kişi


Aktif oyun:

4 kişi


Sonuç:

Sadece oyuna katılan oyuncular etkilenir.


---

# 4. Yazboz Sistemi


MVP'nin ana modülü.


Özellikler:


- Oyuncu sayısı seçimi
- El bazlı skor girişi
- Tur ekleme
- Tur silme
- Toplam hesaplama


Örnek:



Oyun 1

Ali -120
Mehmet 50
Ahmet 70

Oyun 2

Ali 80
Mehmet -40



Sonuç:


Oyun sonunda otomatik kazanan/kaybeden hesaplanır.


---

# 5. Temel Lig Puan Sistemi


Özellikler:


- Kazanan puanı
- Kaybeden puanı
- Ortalama puan


Örnek:


Kazanan:



+100 puan



Kaybeden:



-50 puan



---

# Phase 1 Çıkış Kriterleri


[ ] Kullanıcı oluşturulabiliyor

[ ] Lig oluşturulabiliyor

[ ] Oyun oynanabiliyor

[ ] Yazboz çalışıyor

[ ] Skor hesaplanıyor

[ ] Lig sıralaması oluşuyor


---

# Phase 2 - Advanced League System


## Hedef


Daha adil ve rekabetçi lig sistemi.


Versiyon:



v1.1.0



---

# 1. Gelişmiş Puan Algoritması


Amaç:

Çok oynayan oyuncunun haksız avantajını engellemek.


Sistem:


Toplam puan yerine:



Ortalama performans
+
Katılım bonusu



kullanılır.


Örnek:


Oyuncu A:



10 oyun
900 puan

Ortalama:
90



Oyuncu B:



3 oyun
300 puan

Ortalama:
100



Sistem dengeli sıralama yapar.


---

# 2. Bonus Sistemi


Özellikler:


- Oyun katılım bonusu
- Seri galibiyet bonusu
- Başarı bonusları


Örnek:


Her oyun:



+2 katılım puanı



---

# 3. Ceza Sistemi


Destek:


- Elde kalan puan cezası
- Kural ihlali cezası
- Manuel ceza


Kurallar değiştirilebilir olacaktır.


---

# 4. Rakip Analizi


Özellikler:


Oyuncu bazlı:



Mehmet vs Ali

Toplam:
25 oyun

Mehmet:
15 galibiyet

Ali:
10 galibiyet



---

# Phase 3 - User Experience Improvements


Versiyon:



v1.5.0



Amaç:


Uygulama deneyimini geliştirmek.


---

# Özellikler


## Dashboard


Ana ekran:


- Lig sıralaması
- Son oyunlar
- Performans özeti


---

## Grafikler


Eklenecek:


- Puan değişim grafiği
- Galibiyet oranı
- Performans analizi


---

## Bildirim Sistemi


Örnek:


"Ahmet seni ligde geçti"


"Yeni oyun sonucu eklendi"


---

# Phase 4 - Social Features


Versiyon:



v2.0.0



Amaç:


Oyuncular arası etkileşim.


---

# 1. Arkadaş Sistemi


Özellikler:


- Arkadaş ekleme
- Oyuncu arama
- Arkadaş listesi


---

# 2. Lig Davet Sistemi


Özellikler:


- Davet linki
- QR kod
- Davet bildirimi


---

# 3. Oyuncu Profili


Profil:


- Toplam oyun
- Kazanma oranı
- En iyi rakip
- En kötü rakip


---

# Phase 5 - Competitive Platform


Versiyon:



v3.0.0



Amaç:


Mobil101Lig'i gerçek rekabet platformuna dönüştürmek.


---

# Özellikler


## Turnuva Sistemi


Destek:


- Eleme
- Lig usulü
- Final sistemi


---

## Global Sıralama


Özellik:


- Dünya sıralaması
- Bölgesel sıralama
- Sezon sistemi


---

## Sezon Sistemi


Örnek:



2026 Yaz Sezonu

Başlangıç:
01.06.2026

Bitiş:
01.09.2026



---

# 6. Teknik Geliştirme Roadmap


## Backend


Gelecek:


- Firebase Functions
- Server-side skor hesaplama
- API Gateway


---

## Database


Gelecek:


- Daha gelişmiş raporlama
- Arşiv sistemi
- Veri analizi


---

## Analytics


Takip:


- Aktif kullanıcı
- Oyun sayısı
- En popüler kurallar


---

# 7. Önceliklendirme Mantığı


Yeni özellikler değerlendirilirken:


Öncelik sırası:


1. Kullanıcı değerine etkisi

2. Teknik gereklilik

3. Geliştirme maliyeti

4. Uzun vadeli fayda


---

# 8. Gelecek Özellik Havuzu


Planlanan ancak zamanı belirlenmemiş özellikler:


## Oyun Modları


- 5 kişilik oyun
- Farklı 101 kuralları
- Özel oyun kuralları


---

## Yapay Zeka Özellikleri


- Performans tahmini
- Rakip analizi
- Strateji önerileri


---

## Paylaşım


- Oyun sonucu paylaşma
- Lig kartı oluşturma
- Sosyal medya paylaşımı


---

# 9. Roadmap Güncelleme Politikası


Roadmap yaşayan bir dokümandır.


Yeni ihtiyaçlar:


- Kullanıcı geri bildirimleri
- Teknik gereksinimler
- Yeni fikirler


doğrultusunda güncellenebilir.


Ancak mevcut mimari kararlar korunarak kontrollü şekilde geliştirme yapılacaktır.


---

# 10. Başarı Kriterleri


Mobil101Lig başarılı kabul edilir:


- Kullanıcılar kolayca oyun oluşturabiliyorsa
- Skor hesaplama hatasız çalışıyorsa
- Lig rekabeti oluşturuyorsa
- Kullanıcılar tekrar tekrar uygulamayı kullanıyorsa
- Sistem yeni özelliklere kolay adapte olabiliyorsa


Mobil101Lig uzun vadede ölçeklenebilir bir 101 oyun platformu olarak geliştirilecektir.