# 06 - UI / UX Design Document

# 1. UI / UX Vizyonu

Mobil101Lig uygulaması, kullanıcıların 101 oyunlarını kolay şekilde takip edebildiği, lig rekabetini artıran ve uzun süre kullanılabilir bir mobil deneyim sunan bir uygulama olarak tasarlanacaktır.

Temel hedefler:

- Kullanıcıların hızlı şekilde oyun başlatabilmesi
- Yazboz işlemlerinin kolay yapılabilmesi
- Lig durumunun anlık takip edilebilmesi
- Oyuncu performanslarının detaylı görülebilmesi
- Karmaşık hesaplamaların kullanıcıdan gizlenmesi


---

# 2. Tasarım Prensipleri


## Basitlik

Kullanıcı mümkün olduğunca az işlemle sonuca ulaşmalıdır.


Örnek:

Yanlış:

```
5 ekran geçerek oyun sonucu girme
```


Doğru:

```
Lig seç
    |
Oyuncuları seç
    |
Skorları gir
    |
Oyunu tamamla
```



---

## Hız

101 oyunu sırasında kullanıcıların hızlı işlem yapması gerekir.


Bu nedenle:

- Büyük butonlar
- Kolay veri girişi
- Minimum klavye kullanımı
- Hızlı kayıt


öncelikli olacaktır.



---

## Görsel Rekabet


Uygulama sadece kayıt uygulaması değil, aynı zamanda rekabet platformudur.


Kullanılacak öğeler:

- Sıralama kartları
- Oyuncu başarıları
- Kazanma oranları
- Lig liderliği göstergeleri



---

# 3. Uygulama Navigasyon Yapısı


Ana navigasyon:


```
Splash

 |

Authentication

 |

Home

 |

Bottom Navigation

 |----------------|
 |                |
Ligler        Profil

 |                
Oyunlar

 |

İstatistikler

 |

Ayarlar
```



---

# 4. Ekranlar


# 4.1 Splash Screen


Amaç:

Uygulama açılış kontrolü.


Görevler:

- Firebase bağlantısı kontrolü
- Kullanıcı oturum kontrolü
- İlk yönlendirme


Gösterilecek:


- Logo
- Uygulama adı
- Loading animasyonu



---

# 4.2 Authentication Screens


## Login Screen


Alanlar:


- Email
- Şifre


Butonlar:

- Giriş Yap
- Google ile giriş
- Apple ile giriş


Ek:

- Şifremi unuttum



---

## Register Screen


Alanlar:

- Kullanıcı adı
- Email
- Şifre
- Şifre tekrar


Kontroller:

- Email formatı
- Şifre güvenliği
- Kullanıcı adı kontrolü



---

# 4.3 Home Dashboard


Ana ekran kullanıcının genel durumunu gösterir.


İçerik:


## Aktif Ligler


Örnek:


```
Pazar 101 Ligi

Sıra:
3

Puan:
2450
```



## Son Oyunlar


Örnek:


```
Bugünkü oyun

Kazanan:
Ahmet

Sen:
+120 puan
```



## Hızlı İşlemler


Butonlar:


- Yeni Oyun Başlat
- Yazboz Aç
- Lig Oluştur



---

# 4.4 League Screen


Lig detay ekranı.


İçerik:


## Lig Bilgisi


```
Lig Adı

Oyuncu Sayısı

Kuruluş Tarihi
```



## Oyuncu Listesi


Kart görünümü:


```
Ahmet

Puan:
2500

Sıra:
1
```



## Lig İşlemleri


- Oyuncu ekle
- Oyun başlat
- Lig ayarları



---

# 4.5 Create League Screen


Yeni lig oluşturma ekranı.


Alanlar:


- Lig adı
- Açıklama
- Oyuncu daveti


Opsiyonlar:


- Tekli oyun
- Eşli oyun
- Özel kurallar



---

# 4.6 Game Setup Screen


Oyun başlamadan önce kullanılan ekran.


Amaç:

Oyuncuları belirlemek.


İçerik:


```
Lig Oyuncuları


☑ Ahmet

☑ Mehmet

☑ Ali

☑ Veli
```



Kurallar:


- Minimum 2 oyuncu
- Maximum 4 oyuncu



---

# 4.7 Yazboz Screen


Uygulamanın en önemli ekranıdır.


Amaç:

101 oyun skorlarının hızlı girilmesi.



## Genel Görünüm


```
Oyun No: 5


Ahmet     120

Mehmet    -50

Ali       80

Veli      0


[Tur Ekle]

[Oyunu Bitir]
```



---

# 4.8 Yazboz Tur Sistemi


Her el ayrı kayıt edilir.


Örnek:


```
1. El

Ahmet:
120

Mehmet:
0

Ali:
-50

Veli:
30
```



Sonuç:


```
Toplam skor hesaplanır
```



Avantaj:


- Geçmiş eller görülebilir
- Hatalı giriş düzeltilebilir
- Yeni kurallar eklenebilir



---

# 4.9 Game Result Screen


Oyun tamamlandığında gösterilir.


İçerik:


## Kazanan


```
🏆 Ahmet

+100 Lig Puanı
```



## Kaybedenler


```
Mehmet

-80 Puan
```



## Özet


```
Toplam El:
13

En yüksek ceza:
Mehmet

Oyun Süresi:
45 dakika
```



---

# 4.10 Ranking Screen


Lig sıralama ekranı.


Gösterilecek:


```
1. Ahmet

2500 Puan


2. Mehmet

2300 Puan


3. Ali

1800 Puan
```



Ek bilgiler:


- Oyun sayısı
- Kazanma oranı
- Ortalama skor



---

# 4.11 Player Detail Screen


Oyuncu profili.


İçerik:


## Genel


```
Toplam Oyun:
120

Galibiyet:
70

Başarı:
58%
```



## Rakip Analizi


Örnek:


```
Ahmet'e karşı:

20 oyun

12 galibiyet

8 mağlubiyet
```



---

# 4.12 Statistics Screen


Detaylı analiz ekranı.


Gösterilecek:


- En çok kazanan
- En çok kaybeden
- Ortalama skor
- En fazla oynanan rakip
- Performans grafikleri



---

# 4.13 Profile Screen


Kullanıcı bilgileri.


Alanlar:


- Profil fotoğrafı
- Kullanıcı adı
- İstatistikler


İşlemler:


- Profil düzenle
- Hesap ayarları



---

# 4.14 Settings Screen


Ayarlar:


- Bildirim ayarları
- Tema seçimi
- Dil seçimi
- Hesap işlemleri



---

# 5. UI Component Standardları


Ortak kullanılacak bileşenler:


## Buttons

Standart:

- Primary Button
- Secondary Button
- Danger Button



## Cards


Kullanım:

- Oyuncu kartı
- Lig kartı
- Skor kartı



## Dialog


Kullanım:

- Silme onayı
- Oyuncu çıkarma
- Oyun bitirme



---

# 6. Responsive Design


Desteklenecek:


- Android telefonlar
- iPhone cihazlar
- Tabletler


Yaklaşım:


Flutter responsive layout kullanılacaktır.



---

# 7. Theme Design


Destek:


- Light Theme
- Dark Theme


Tema yönetimi merkezi olacaktır.


Dosya:


```
theme/

app_theme.dart

colors.dart

text_styles.dart
```



---

# 8. Animation Kullanımı


Kullanılacak alanlar:


- Sayfa geçişleri
- Skor değişimleri
- Kazanan animasyonu
- Loading durumları



Aşırı animasyondan kaçınılacaktır.



---

# 9. Accessibility


Dikkat edilecekler:


- Font boyutları
- Kontrast oranları
- Büyük dokunma alanları
- Screen reader desteği



---

# 10. Gelecek UI Geliştirmeleri


Planlanan özellikler:


- Canlı oyun modu
- Lig kupaları
- Oyuncu rozetleri
- Sezon ekranı
- Arkadaş listesi
- Global leaderboard



---

# Sonuç


Mobil101Lig UI/UX yapısı;


- kolay kullanım,
- hızlı skor girişi,
- rekabet odaklı tasarım,
- geliştirilebilir ekran mimarisi


üzerine kurulacaktır.


Tüm ekranlar Flutter Clean Architecture yapısına uygun geliştirilecek ve tekrar kullanılabilir component mantığı ile oluşturulacaktır.