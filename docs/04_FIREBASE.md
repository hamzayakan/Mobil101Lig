# 04 - Firebase Architecture & Design

## 1. Firebase Genel Mimari

Mobil101Lig uygulaması backend altyapısı olarak Firebase servislerini kullanacaktır.

Temel Firebase servisleri:

- Firebase Authentication
- Cloud Firestore
- Firebase Storage
- Firebase Cloud Messaging (FCM)
- Firebase Analytics
- Firebase Crashlytics
- Firebase Remote Config

Firebase kullanımı uygulamanın hızlı geliştirilmesi, gerçek zamanlı veri akışı ve ölçeklenebilirlik hedefleri doğrultusunda planlanmıştır.


---

# 2. Firebase Authentication

## Amaç

Kullanıcıların güvenli şekilde sisteme giriş yapması ve oyuncu kimliklerinin yönetilmesi.

Desteklenecek giriş yöntemleri:

- Email / Password
- Google Sign-In
- Apple Sign-In (iOS için)


## Kullanıcı Akışı


Kullanıcı
|
|
Firebase Authentication
|
|
User UID oluşturulur
|
|
Firestore users collection oluşturulur



## User Identity

Firebase Authentication tarafından verilen UID sistemde ana kullanıcı anahtarı olarak kullanılacaktır.

Örnek:


users/{uid}



---

# 3. Cloud Firestore Database Tasarımı

Firestore uygulamanın ana veri kaynağıdır.

Veri modeli aşağıdaki koleksiyonlardan oluşacaktır.


# 3.1 Users Collection

Kullanıcı bilgileri.


Path:


users/{userId}



Örnek:

```json
{
  "userId": "abc123",
  "displayName": "Ahmet",
  "email": "ahmet@test.com",
  "photoUrl": "",
  "createdAt": "timestamp",
  "lastLoginAt": "timestamp",
  "isActive": true
}

Alanlar:

Alan	Tip	Açıklama
userId	String	Firebase UID
displayName	String	Oyuncu adı
email	String	Kullanıcı maili
photoUrl	String	Profil resmi
createdAt	Timestamp	Kayıt tarihi
isActive	Boolean	Aktiflik durumu
3.2 Leagues Collection

Lig grupları burada tutulacaktır.

Path:

leagues/{leagueId}

Örnek:

{
  "name": "Pazar 101 Ligi",
  "ownerId": "abc123",
  "createdAt": "timestamp",
  "status": "active"
}

Alanlar:

Alan	Tip	Açıklama
name	String	Lig adı
ownerId	String	Lig sahibi
createdAt	Timestamp	Oluşturma tarihi
status	String	active/passive
3.3 League Members Collection

Lig içindeki oyuncular.

Path:

leagues/{leagueId}/members/{userId}

Örnek:

{
 "userId":"abc123",
 "role":"player",
 "joinedAt":"timestamp",
 "totalScore":2500,
 "totalGames":45
}

Amaç:

Lig oyuncularını takip etmek
Sıralama oluşturmak
Oyuncu istatistiklerini hızlı getirmek
3.4 Games Collection

Oynanan her 101 oyunu burada tutulacaktır.

Path:

leagues/{leagueId}/games/{gameId}

Örnek:

{
 "date":"timestamp",
 "playersCount":4,
 "gameType":"single",
 "status":"completed"
}

Alanlar:

Alan	Tip	Açıklama
date	Timestamp	Oyun tarihi
playersCount	Integer	Oyuncu sayısı
gameType	String	single/team
status	String	completed
3.5 Game Players Collection

Oyundaki oyuncu sonuçları.

Path:

leagues/{leagueId}/games/{gameId}/players/{userId}

Örnek:

{
 "userId":"abc123",
 "remainingScore":150,
 "rank":2,
 "earnedPoint":75
}

Alanlar:

Alan	Tip	Açıklama
remainingScore	Integer	Elde kalan ceza
rank	Integer	Oyundaki sıra
earnedPoint	Integer	Kazanılan lig puanı
3.6 Player Match History

Oyuncuların birbirleriyle geçmiş performansları.

Path:

playerRelations/{relationId}

Amaç:

Bir oyuncunun diğer oyuncuya karşı geçmiş başarısını tutmak.

Örnek:

{
 "player1":"abc",
 "player2":"xyz",
 "totalGames":20,
 "player1Wins":12,
 "player2Wins":8
}

Bu yapı sayesinde:

"Ahmet sana karşı kaç kere kazandı?"
"En zor rakibim kim?"
"Hangi oyuncuya karşı daha başarılıyım?"

gibi istatistikler üretilebilir.

4. Yazboz Sistemi Firebase Modeli

101 oyununun detaylı kayıt sistemi.

Amaç:

Her elin ayrı ayrı takip edilmesi.

Path:

games/{gameId}/rounds/{roundId}

Örnek:

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

Avantajları:

Sonradan kural değişebilir
Ceza sistemi değiştirilebilir
Yeni hesaplama algoritmaları eklenebilir
Eski oyunlar tekrar hesaplanabilir
5. Puan Hesaplama Sistemi

Firebase üzerinde ham sonuç tutulacaktır.

Örnek:

Game Result
      |
      |
Score Calculation Service
      |
      |
League Score Update

Hesaplama Firebase Function veya uygulama servis katmanında yapılabilir.

Örnek:

Kazanan:
+100 puan


Kaybeden:
Elde kalan ceza kadar puan kaybı


Bonus:
Oyun başına katılım puanı

Hesaplama kuralları değişebilir olduğu için sabit kod içine gömülmeyecektir.

6. Firebase Cloud Functions

Kullanılacak alanlar:

Score Calculation

Görevi:

Oyun bitince puan hesaplamak
Oyuncu skorlarını güncellemek
Statistics Generator

Görevi:

Oyuncu istatistiklerini oluşturmak
Liderlik tablolarını güncellemek
Notification Service

Görevi:

Yeni oyun bildirimi
Lig daveti
Sonuç bildirimi
7. Firebase Storage

Kullanım alanları:

storage/
 |
 ├── profile-images
 |
 ├── league-images
 |
 └── attachments

Profil fotoğrafları ve lig görselleri burada tutulacaktır.

8. Firestore Security Rules Prensipleri

Temel güvenlik:

Kullanıcı

Kendi profilini düzenleyebilir.

Lig

Sadece üyeler:

Lig bilgilerini okuyabilir
Oyun sonuçlarını görebilir
Oyun

Sadece lig üyeleri:

Oyun geçmişini görebilir
Admin

Lig sahibi:

Oyuncu ekleyebilir
Oyuncu çıkarabilir
Kural yönetebilir
9. Offline Support

Firestore offline cache kullanılacaktır.

Amaç:

İnternet yokken yazboz ekranında veri kaybını önlemek
Son yapılan oyunları saklamak
10. Firebase Environment Yönetimi

Ortamlar:

Firebase Dev

Firebase Test

Firebase Production

Her ortam farklı Firebase projesine bağlanacaktır.

Örnek:

mobil101lig-dev

mobil101lig-test

mobil101lig-prod
11. Backup ve Veri Koruma

Plan:

Firestore backup
Storage backup
Kritik koleksiyon export

Özellikle:

games
gameResults
leagueScores

koleksiyonları düzenli yedeklenecektir.

12. Gelecek Geliştirmeler

Firebase mimarisi aşağıdaki özelliklere hazır olacaktır:

Turnuva sistemi
Lig sezonları
Oyuncu seviyeleri
Rozet sistemi
Global sıralama
Arkadaş sistemi
Canlı oyun takibi
Çoklu oyun türleri
Sonuç

Firebase mimarisi;

değişebilir oyun kurallarını destekleyen,
yüksek kullanıcı sayısına ölçeklenebilir,
istatistik üretmeye uygun,
güvenli,
gerçek zamanlı çalışan

bir yapı üzerine kurulacaktır.