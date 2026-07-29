# 05 - Security Architecture & Guidelines

## 1. Güvenlik Vizyonu

Mobil101Lig uygulaması kullanıcı verilerinin, oyun sonuçlarının ve lig bilgilerinin güvenli şekilde saklanmasını hedefler.

Güvenlik yaklaşımı aşağıdaki prensiplere dayanır:

- Kullanıcı sadece yetkili olduğu verilere erişebilir.
- Lig verileri sadece lig üyeleri tarafından görüntülenebilir.
- Oyun sonuçları manipüle edilemez olmalıdır.
- Kritik işlemler doğrulanmalıdır.
- Tüm güvenlik katmanlı olarak uygulanmalıdır.


---

# 2. Güvenlik Katmanları


Uygulama güvenliği aşağıdaki katmanlardan oluşacaktır.


```
Mobile Application

        |

Authentication Layer

        |

Authorization Layer

        |

Firestore Security Rules

        |

Cloud Functions Validation

        |

Database
```


Her katman farklı bir güvenlik sorumluluğu üstlenecektir.


---

# 3. Authentication Security


Firebase Authentication kullanılacaktır.


Desteklenen yöntemler:

- Email / Password
- Google Authentication
- Apple Authentication


## Kullanıcı Kimliği


Her kullanıcı Firebase tarafından oluşturulan UID ile takip edilir.


Örnek:

```
users/{firebase_uid}
```


Firebase UID:

- Değiştirilemez
- Benzersizdir
- Kullanıcının ana kimliğidir



---

# 4. Authorization Model


Kimlik doğrulama sonrası kullanıcının hangi işlemleri yapabileceği kontrol edilir.


Roller:


## User

Normal oyuncu.


Yetkileri:

- Profil görüntüleme
- Liglere katılma
- Oyun geçmişini görüntüleme
- Kendi istatistiklerini görme


---

## League Owner


Lig sahibi.


Yetkileri:

- Oyuncu davet etme
- Oyuncu çıkarma
- Lig ayarlarını değiştirme
- Oyun başlatma


---

## Admin


Sistem yöneticisi.


Yetkileri:

- Sistem yönetimi
- Kullanıcı yönetimi
- Hata inceleme



---

# 5. Firestore Security Rules


Firestore erişimleri mutlaka Security Rules ile korunacaktır.


Temel prensip:


```
Default Deny
```


Yani:

- Varsayılan olarak hiçbir erişim yoktur.
- Sadece izin verilen işlemler yapılabilir.



---

# 6. User Data Security


Collection:

```
users/{userId}
```


Kurallar:


Kullanıcı:

- Kendi profilini okuyabilir.
- Kendi profilini güncelleyebilir.


Başka kullanıcı:

- Sadece herkese açık bilgileri görebilir.


Örnek:


İzin verilen:

```
currentUser.uid == userId
```



Yasak:

```
Bir kullanıcının başka kullanıcının email bilgisini değiştirmesi
```


---

# 7. League Security


Collection:


```
leagues/{leagueId}
```


Kontroller:


Bir kullanıcı:


Okuyabilir:

- Üyesi olduğu ligleri


Yazabilir:

- Sahibi olduğu ligleri


Kontrol:


```
userId exists in leagueMembers
```



---

# 8. Game Result Security


Oyun sonuçları kritik veridir.


Collection:


```
leagues/{leagueId}/games/{gameId}
```


Kurallar:


Oyun sonucu:


- Normal kullanıcı tarafından değiştirilemez.
- Sadece oyun oluşturma yetkisi olan kullanıcı yazabilir.
- Tamamlanan oyun kilitlenir.


Örnek durum:


```
gameStatus = completed
```


Olduktan sonra:


```
update/delete disabled
```



---

# 9. Score Manipulation Protection


Oyuncular kendi puanlarını değiştiremez.


Yanlış:


```
User updates totalScore directly
```


Doğru:


```
Game Result

        |

Score Calculation Service

        |

Update Player Score
```


Puan hesaplama merkezi olarak yapılacaktır.


---

# 10. Cloud Functions Security


Kritik işlemler Cloud Functions üzerinden çalıştırılacaktır.


Kullanım alanları:


## Score Calculation


Görev:


- Oyun sonucunu doğrulamak
- Puan hesaplamak
- Lig sıralamasını güncellemek



## Statistics Update


Görev:


- Kazanma/kaybetme oranlarını güncellemek
- Rakip istatistiklerini oluşturmak



## Notification


Görev:


- Lig daveti
- Oyun sonucu
- Yeni etkinlik bildirimi



---

# 11. Input Validation


Kullanıcıdan gelen tüm veriler kontrol edilecektir.


Kontrol edilen alanlar:


## Kullanıcı adı

Kontroller:

- Minimum uzunluk
- Maksimum uzunluk
- Özel karakter kontrolü


---

## Oyun Skoru


Kontroller:


- Negatif değer kontrolü
- Maksimum skor kontrolü
- Oyuncu sayısı kontrolü



Örnek:


```
Oyuncu sayısı:

Minimum: 2
Maximum: 4
```



---

# 12. Firebase Storage Security


Storage üzerinde:


```
profile-images

league-images
```


alanları korunacaktır.


Kurallar:


Kullanıcı:

- Kendi profil resmini yükleyebilir.


Lig sahibi:

- Lig görseli değiştirebilir.



---

# 13. Environment Security


Firebase ortamları ayrılacaktır.


Ortamlar:


```
Development

Test

Production
```


Amaç:


- Test verilerinin gerçek kullanıcıları etkilememesi
- Production verisinin korunması



---

# 14. Secret Management


Gizli bilgiler uygulama içine yazılmayacaktır.


Yasak:


```
API_KEY = "xxxx"
PASSWORD = "xxxx"
```


Kullanılacak:


```
.env.dev

.env.test

.env.prod
```


Git içerisine gönderilmeyecek:


```
.env*
```


Dosyaları `.gitignore` içerisinde olacaktır.



---

# 15. Application Security


Flutter tarafında:


Uygulanacak güvenlikler:


- Secure Storage kullanımı
- Token güvenliği
- Sensitive data encryption
- Debug log temizliği


---

# 16. Logging Security


Loglarda hassas bilgiler tutulmayacaktır.


Yasak:


```
Password

Token

Email

Private Data
```


İzin verilen:


```
Error Code

Timestamp

Operation Type
```



---

# 17. Crash Reporting


Firebase Crashlytics kullanılacaktır.


Amaç:


- Uygulama hatalarını takip etmek
- Kullanıcı deneyimini iyileştirmek
- Kritik hataları hızlı çözmek



---

# 18. Abuse Prevention


Sistemi kötüye kullanmaya karşı:


Önlemler:


- Rate limiting
- Request validation
- Duplicate operation kontrolü
- Spam engelleme



---

# 19. Backup Security


Kritik veriler düzenli olarak yedeklenecektir.


Öncelikli koleksiyonlar:


```
users

leagues

games

gameResults

playerStatistics
```



---

# 20. Future Security Improvements


Gelecekte uygulanabilecek geliştirmeler:


- Two Factor Authentication
- Advanced Admin Panel
- Fraud Detection
- Audit Log System
- Permission Management
- Data Export Controls



---

# Sonuç


Mobil101Lig güvenlik mimarisi;


- Firebase Authentication,
- Firestore Security Rules,
- Cloud Functions validation,
- Role Based Access Control,
- Secure data management


yaklaşımı ile tasarlanacaktır.


Amaç:

Kullanıcı bilgilerinin korunması,
oyun sonuçlarının manipülasyonunun engellenmesi,
adil ve güvenilir bir lig sistemi oluşturulmasıdır.