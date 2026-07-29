# 07 - Game Rules & Scoring Engine Design

# 1. Amaç

Mobil101Lig içerisinde oynanan 101 oyunlarının sonuçlarını standart şekilde hesaplamak, oyuncu performanslarını ölçmek ve lig puan sistemine aktarmak için esnek bir oyun kuralları altyapısı oluşturulacaktır.

Sistem sadece mevcut 101 kurallarına bağlı kalmayacaktır.

İleride aşağıdaki değişikliklere açık olacaktır:

- Farklı ceza hesaplama yöntemleri
- Farklı kazanma puanları
- Yeni oyun türleri
- Takımlı oyun geliştirmeleri
- Sezon bazlı puanlama
- Özel lig kuralları


---

# 2. Oyun Türleri


## 2.1 Tekli Oyun


Oyuncular bireysel olarak yarışır.


Örnek:


```
Ahmet
Mehmet
Ali
Veli
```


Her oyuncunun kendi skoru bulunur.


Kazanan:

- En düşük ceza puanına sahip oyuncu


Kaybeden:

- Daha yüksek ceza puanı kalan oyuncular



---

## 2.2 Eşli Oyun


Oyuncular takım şeklinde yarışır.


Örnek:


```
Takım A

Ahmet
Mehmet


Takım B

Ali
Veli
```


Takım skoru:


```
Oyuncu1 Skoru
+
Oyuncu2 Skoru

=

Takım Skoru
```


Kazanan takım belirlenir.



---

# 3. Oyun Yapısı


Bir oyun aşağıdaki yapılardan oluşur.


```
League

 |

Game

 |

Rounds

 |

Player Scores

 |

Calculation Engine

 |

League Score Update
```



---

# 4. Yazboz Sistemi


101 oyununun her eli ayrı kayıt edilir.


Amaç:


- Geçmiş elleri görmek
- Hatalı girişleri düzeltmek
- Yeni hesaplama kuralları uygulamak



Örnek:


```
Oyun: 13 El


1. El

Ahmet   50
Mehmet  0
Ali     -30
Veli    20



2. El

Ahmet   80
Mehmet -50
Ali     0
Veli    30
```



---

# 5. Round (El) Modeli


Her el aşağıdaki bilgileri tutar.


```
Round
{
 roundNumber,
 players,
 scores,
 createdAt
}
```


Örnek:


```json
{
 "roundNumber":5,

 "players":[

   {
    "userId":"abc",
    "score":120
   },

   {
    "userId":"xyz",
    "score":-50
   }

 ]

}
```



---

# 6. Skor Hesaplama Motoru


Skor hesaplama uygulama içerisinde sabit olmayacaktır.


Ayrı bir servis olarak tasarlanacaktır.


```
Score Engine
```


Görevleri:


- El skorlarını toplamak
- Ceza hesaplamak
- Kazananı belirlemek
- Lig puanını hesaplamak
- İstatistikleri güncellemek



---

# 7. Temel Puan Hesaplama


Örnek sistem:


## Kazanan


```
+100 Lig Puanı
```


## Kaybeden


Elde kalan puana göre:


```
Ceza = Elde Kalan Puan
```



Örnek:


```
Ahmet

Kazandı

+100


Mehmet

50 kaldı

-50


Ali

120 kaldı

-120
```



---

# 8. Oyun Sayısı Dengesi


Amaç:

Çok fazla oynayan kişinin otomatik avantaj sağlamasını engellemek.


Problem:


```
Oyuncu A

10 oyun

1000 puan


Oyuncu B

100 oyun

8000 puan
```


Sadece toplam puana bakmak adil olmayabilir.


Bu nedenle:


```
Ortalama Puan

=

Toplam Lig Puanı

/

Toplam Oyun Sayısı
```



---

# 9. Katılım Bonus Sistemi


Çok oynayan oyuncunun emeğini korumak için bonus sistemi olacaktır.


Örnek:


```
Her oyun:

+5 bonus puan
```


Hesap:


```
Final Score

=

Performans Puanı

+

Katılım Bonusları
```



Bonus değeri ileride değiştirilebilir olacaktır.



---

# 10. Dinamik Kural Sistemi


Kurallar sabit kod içine yazılmayacaktır.


Örnek:


```
GameRuleConfig
```


Model:


```json
{
 "winnerPoint":100,

 "participationBonus":5,

 "penaltyMultiplier":1,

 "maxPlayers":4
}
```



Avantajları:


- Yeni kurallar eklenebilir
- Lig özel kuralları olabilir
- Geçmiş oyunlar tekrar hesaplanabilir



---

# 11. Rakip İstatistik Sistemi


Oyuncular arası geçmiş tutulacaktır.


Amaç:


Bir oyuncunun başka oyuncuya karşı performansını görmek.



Örnek:


```
Ahmet vs Mehmet


Toplam Oyun:

25


Ahmet Kazandı:

15


Mehmet Kazandı:

10
```



Tutulacak bilgiler:


- Toplam karşılaşma
- Galibiyet
- Mağlubiyet
- Ortalama skor
- En yüksek fark



---

# 12. Lig Sıralama Algoritması


Sıralama:


Öncelik:


1. Ortalama puan

2. Toplam puan

3. Kazanma oranı

4. Oyun sayısı



Örnek:


```
1. Ahmet

Ortalama:
85


2. Mehmet

Ortalama:
82
```



---

# 13. Oyun Durumları


Game Status:


```
CREATED

STARTED

PLAYING

COMPLETED

CANCELLED
```



Açıklamalar:


## CREATED

Oyun oluşturuldu.


## STARTED

Oyuncular seçildi.


## PLAYING

Skor girişi devam ediyor.


## COMPLETED

Sonuç hesaplandı.


## CANCELLED

İptal edildi.



---

# 14. Veri Değişikliği


Tamamlanan oyunlarda değişiklik kontrol altında yapılacaktır.


Normal kullanıcı:


```
Update Yok
```


Yetkili kullanıcı:


```
Correction Mode
```



Düzeltme yapıldığında:


```
Audit Log
```


oluşturulur.



---

# 15. Sezon Sistemi Hazırlığı


İleride sezon desteği olacaktır.


Örnek:


```
2026 Yaz Sezonu


Başlangıç:

01.06.2026


Bitiş:

01.09.2026
```



Her sezon:

- Ayrı sıralama
- Ayrı istatistik
- Şampiyon


tutabilir.



---

# 16. Gelecek Oyun Modları


Desteklenebilecek:


- 2 kişilik oyun
- 3 kişilik oyun
- 4 kişilik oyun
- Eşli turnuva
- Eleme sistemi
- Özel lig kuralları



---

# 17. Hedeflenen Mimari


Oyun sistemi aşağıdaki katmanlara ayrılacaktır.


```
Presentation

      |

Game Controller

      |

Score Engine

      |

Rule Configuration

      |

Database
```



Bu sayede:


- UI değişebilir
- Hesaplama değişebilir
- Database değişebilir


ama sistem bozulmaz.



---

# Sonuç


Mobil101Lig oyun motoru;


- değiştirilebilir,
- genişletilebilir,
- adil puanlama yapan,
- istatistik üreten,
- farklı 101 oyun kurallarına uyum sağlayan


bir yapı olarak geliştirilecektir.


Temel amaç:

Sadece skor tutan bir uygulama değil, uzun süre kullanılabilecek profesyonel bir 101 lig platformu oluşturmaktır.