Bu versiyonda özellikle söylediğin yazboz ekranı, 13 oyunluk seri takip, oyun bazlı ceza/bonus, değişebilir puan algoritması ve gelecekte genişletilebilir yapı dikkate alındı.

# Mobil101Lig - Product Requirements Document (PRD)

## Doküman Bilgileri

**Proje Adı:** Mobil101Lig  
**Platform:** Flutter Mobile Application  
**Backend:** Firebase  
**Versiyon:** MVP v1.0  
**Doküman Durumu:** Draft  

---

# 1. Ürün Tanımı

Mobil101Lig, 101 oyunu oynayan arkadaş gruplarının oyun sonuçlarını dijital ortamda takip edebileceği, oyuncu performanslarını analiz edebileceği ve uzun vadeli lig sıralaması oluşturabileceği mobil uygulamadır.

Uygulama temel olarak fiziksel yazboz kullanımını dijitalleştirir.

Oyuncular:

- Lig oluşturabilir
- Oyuncular ekleyebilir
- Oyun sonuçlarını girebilir
- Oyun bazlı puan kazanabilir veya kaybedebilir
- Genel lig sıralamasını takip edebilir
- Rakip bazlı istatistiklerini görebilir

---

# 2. Ürün Vizyonu

101 oyununun arkadaş grupları arasında daha düzenli, şeffaf ve eğlenceli şekilde takip edilmesini sağlamak.

Uygulama sadece basit bir skor takip sistemi olmayacak.

Uzun vadede:

- farklı puan algoritmaları
- sezon sistemi
- turnuva sistemi
- detaylı oyuncu analizleri
- başarı istatistikleri

desteklenebilecek şekilde geliştirilecektir.

---

# 3. Problem Tanımı

Mevcut durumda 101 oyunlarında:

- Skorlar kağıt üzerinde tutulmaktadır.
- Eski oyun kayıtları kaybolmaktadır.
- Oyuncuların geçmiş performansı bilinmemektedir.
- Kimin kime karşı daha başarılı olduğu takip edilememektedir.
- Çok oynayan oyuncular ile az oynayan oyuncular arasında adil olmayan durumlar oluşabilmektedir.

Mobil101Lig bu problemleri çözmeyi amaçlar.

---

# 4. Temel Kavramlar

## Lig

Oyuncuların bulunduğu ana gruptur.

Örnek:


Mahalle 101 Ligi

Oyuncular:

Hamza
Ahmet
Mehmet
Ali
Veli

Bir oyuncu birden fazla ligde bulunabilir.

Örnek:


Hamza

Arkadaş Ligi
İş Yeri Ligi
2026 Yaz Ligi


---

# 5. Oyun Yapısı

Bir lig içerisinde bulunan tüm oyuncular her oyuna katılmak zorunda değildir.

Örnek:

Lig:

10 oyuncu


Bir oyun:

4 oyuncu ile oynanabilir.

Katılanlar:


Hamza
Ahmet
Mehmet
Ali


Katılmayanlar:


Veli
Can
Burak
Emre
Hasan
Murat


Katılmayan oyuncular o oyun için puan almaz.

---

# 6. Yazboz Sistemi

Uygulamanın temel ekranlarından biridir.

Amaç:

Fiziksel kağıt üzerindeki yazboz mantığını dijital hale getirmek.

---

## Yazboz Oluşturma

Kullanıcı:

- Lig seçer
- Oyuncuları seçer
- Kaç oyun oynanacağını belirler

Örnek:


Yeni Yazboz

Lig:
Mahalle 101 Ligi

Oyuncular:
Hamza
Ahmet
Mehmet
Ali

Oyun Sayısı:
13


---

# 7. Çoklu Oyun Takibi

Bir yazboz içerisinde birden fazla oyun tutulabilir.

Örnek:

13 oyunluk seri:


Oyun 1
Hamza : 20
Ahmet : 80
Mehmet : 150
Ali : 220

Oyun 2
Hamza : 0
Ahmet : 60
Mehmet : 90
Ali : 170

...

Oyun 13


Her oyun bağımsız olarak kayıt edilir.

---

# 8. Oyun Sonuç Hesaplama Sistemi

Puan hesaplama sistemi sabit olmayacaktır.

Sistem geliştirilebilir şekilde tasarlanacaktır.

Amaç:

İleride yeni kurallar eklenebilmesi.

---

Örnek hesaplama yöntemleri:

## Sabit Puanlama

oyuncu:
+100 puan
oyuncu:
+50 puan
oyuncu:
-50 puan
oyuncu:
-100 puan

---

## Kalan Taş Bazlı Hesaplama

Örnek:


Hamza : 10
Ahmet : 50
Mehmet : 120
Ali : 200


Aradaki farklara göre puan hesaplanabilir.

---

## Ceza / Bonus Sistemi

Her oyun için ekstra puan hareketleri olabilir.

Örnek:


Oyun 5

Hamza:
+100 kazanma puanı

Ahmet:
-50 ceza

Mehmet:
+20 bonus


---

# 9. Puan Motoru (Score Engine)

Puan hesaplama kod içerisinde sabit olmayacaktır.

Ayrı bir yapı olarak geliştirilecektir.

Amaç:

Yeni kurallar eklenirken mevcut sistemin bozulmaması.

Örnek:


ScoreCalculator

calculateGameScore()

applyBonus()

applyPenalty()

calculateLeagueRanking()


---

# 10. Oyuncu Puan Sistemi

Oyuncunun lig puanı oyun sonuçlarından oluşur.

Örnek:


Hamza

Toplam Puan:
850

Oyun Sayısı:
10

Ortalama:
85


---

# 11. Fazla Oynama Dengesi

Çok fazla oyun oynayan oyuncunun sadece oyun sayısından dolayı avantaj elde etmemesi gerekir.

Bu nedenle:

Toplam puan yanında ortalama performans takip edilir.

Örnek:

Oyuncu A:


10 oyun
1000 puan

Ortalama:
100


Oyuncu B:


2 oyun
200 puan

Ortalama:
100


İki oyuncu dengeli değerlendirilir.

---

# 12. Katılım Bonus Sistemi

İleride eklenebilir.

Amaç:

Düzenli oynayan oyuncuyu desteklemek.

Örnek:


Her oyun katılımı:

+5 bonus puan


veya


10 oyun tamamlayan:

+50 lig bonusu


---

# 13. Rakip İstatistikleri

Oyuncular birbirlerine karşı performanslarını görebilecektir.

Örnek:


Hamza vs Ahmet

Toplam Oyun:
25

Hamza Kazandı:
15

Ahmet Kazandı:
10

Kazanma Oranı:
%60


---

# 14. Eşli Oyun Desteği

101 oyunu eşli oynanabildiği için sistem desteklemelidir.

Örnek:

Takım 1:


Hamza
Ahmet



Takım 2:


Mehmet
Ali


Puan hesaplama takım bazlı veya oyuncu bazlı çalışabilir.

---

# 15. MVP Kapsamı

## Kullanıcı Yönetimi

- Kullanıcı oluşturma
- Profil bilgileri


## Lig Yönetimi

- Lig oluşturma
- Oyuncu ekleme
- Oyuncu çıkarma


## Yazboz

- Oyun oluşturma
- Oyuncu seçme
- Skor girme
- Çoklu oyun takibi
- Sonuç hesaplama


## Puanlama

- Kazanan belirleme
- Puan ekleme
- Puan çıkarma
- Lig sıralaması


## İstatistik

- Oyun sayısı
- Kazanma sayısı
- Kaybetme sayısı
- Ortalama puan
- Rakip analizi

---

# 16. Non Functional Requirements

## Performans

- Hızlı veri yükleme
- Offline desteğe uygun mimari


## Güvenlik

- Firebase Authentication
- Firestore Security Rules
- Kullanıcı yetkilendirme


## Ölçeklenebilirlik

Sistem:

- Yeni oyun türleri
- Yeni puan kuralları
- Yeni istatistikler

eklenebilecek şekilde hazırlanmalıdır.


---

# 17. Veri Modeli Prensipleri

Sistem aşağıdaki temel varlıkları içerecektir:


User

League

LeagueMember

GameSession

Game

GamePlayerScore

ScoreTransaction

PlayerStatistic

PlayerVsPlayerStatistic


---

# 18. Gelecek Geliştirmeler

Planlanan özellikler:

- Sezon sistemi
- Turnuva sistemi
- Otomatik kura sistemi
- Arkadaş daveti
- Push bildirimleri
- Gelişmiş grafikler
- Başarı rozetleri
- Farklı oyun türleri
- Özelleştirilebilir puan kuralları

---

# 19. Başarı Kriterleri

MVP başarılı kabul edilir:

- Kullanıcı lig oluşturabiliyorsa
- Oyuncu ekleyebiliyorsa
- 101 oyunlarını kayıt edebiliyorsa
- Yazboz mantığı çalışıyorsa
- Puan hesaplama doğru yapılıyorsa
- Lig sıralaması oluşuyorsa
- Geçmiş oyunlar görüntülenebiliyorsa

---

# Sonuç

Mobil101Lig, basit bir skor uygulaması değil;

101 oyunu için esnek, geliştirilebilir ve uzun vadeli kullanılabilecek profesyonel bir lig yönetim platformudur.

Tüm geliştirmeler bu dokümandaki prensiplere uygun yapılacaktır.