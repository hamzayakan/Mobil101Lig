# Mobil101Lig Database Design Document

## 1. Database Overview

Mobil101Lig uygulaması için veri yönetimi Firebase Cloud Firestore üzerinde gerçekleştirilecektir.

Database tasarımı aşağıdaki prensiplere göre oluşturulmuştur:

- Ölçeklenebilir yapı
- Dinamik oyun kuralları
- Geçmiş oyunların detaylı tutulması
- İstatistik üretilebilir olması
- Yeni özelliklerin kolay eklenebilmesi


## 2. Database Technology

Database:

Firebase Cloud Firestore


Kullanılacak Firebase servisleri:

- Firebase Authentication
- Cloud Firestore
- Firebase Storage
- Firebase Analytics
- Firebase Crashlytics



# 3. Collection Structure



users
|
|-- userId

leagues
|
|-- leagueId

league_members
|
|-- memberId

games
|
|-- gameId

game_rules
|
|-- ruleId

player_statistics
|
|-- statisticId

head_to_head
|
|-- recordId



# 4. Users Collection


Kullanıcı bilgileri.


Collection:

users


Document:

userId


Örnek:

```json
{
  "id": "user123",
  "name": "Ahmet",
  "username": "ahmet01",
  "avatarUrl": "",
  "createdAt": "",
  "updatedAt": "",
  "status": "active"
}

Alanlar:

Alan	Tip	Açıklama
id	String	Kullanıcı ID
name	String	Kullanıcı adı
username	String	Kullanıcı kullanıcı adı
avatarUrl	String	Profil resmi
createdAt	Timestamp	Oluşturulma tarihi
updatedAt	Timestamp	Güncelleme tarihi
status	String	Kullanıcı durumu
5. Leagues Collection

Lig gruplarını temsil eder.

Collection:

leagues

Örnek:

{
  "id": "league001",
  "name": "Arkadaş Grubu",
  "ownerId": "user123",
  "maxPlayers": 20,
  "createdAt": "",
  "status": "active"
}

Alanlar:

Alan	Tip	Açıklama
name	String	Lig adı
ownerId	String	Lig sahibi
maxPlayers	Number	Maksimum oyuncu
status	String	Aktif/Pasif
6. League Members Collection

Lig içerisindeki oyuncuları tutar.

Collection:

league_members

Örnek:

{
  "leagueId": "league001",
  "userId": "user123",
  "joinedAt": "",
  "totalScore": 2450,
  "gamesPlayed": 35
}

Alanlar:

Alan	Tip	Açıklama
leagueId	String	Lig ID
userId	String	Oyuncu ID
totalScore	Number	Toplam lig puanı
gamesPlayed	Number	Oynanan oyun sayısı
7. Games Collection

Her oynanan 101 oyununu temsil eder.

Collection:

games

Örnek:

{
 "id":"game001",
 "leagueId":"league001",
 "createdBy":"user123",
 "gameType":"team",
 "playerCount":4,
 "status":"completed",
 "createdAt":""
}

Alanlar:

Alan	Tip	Açıklama
leagueId	String	Hangi lig
gameType	String	single/team
playerCount	Number	Oyuncu sayısı
status	String	Oyun durumu
createdAt	Timestamp	Tarih
8. Game Rounds Collection

Bir oyun içerisinde oynanan elleri tutar.

Örnek:

13 el oynanan oyun:

games

game001

   rounds

      round1
      round2
      round3
      ...
      round13

Örnek:

{
 "roundNumber":1,
 "players":[
   {
    "userId":"user1",
    "score":-50
   },
   {
    "userId":"user2",
    "score":100
   }
 ],
 "penalty":0,
 "winner":"user2",
 "createdAt":""
}

Amaç:

Her elin ayrı analiz edilmesi
Ceza uygulanabilmesi
Sonradan hesaplama değiştirilebilmesi
9. Score Calculation System

Skor sistemi direkt sabit kodlanmayacaktır.

Dinamik hesaplama servisi kullanılacaktır.

Örnek:

ScoreCalculator

Görevleri:

El puanı hesaplama
Ceza uygulama
Kazanan puanı
Kaybeden puanı
Bonus hesaplama

Örnek:

Round Result

Player A
+100


Player B
-50


Player C
-30


Player D
-20

Sonuç:

Lig puan hesaplama servisine gönderilir.

10. Game Rules Collection

Değişebilir oyun kurallarını tutar.

Collection:

game_rules

Örnek:

{
 "name":"default_rule",
 "winnerPoint":100,
 "penaltyMultiplier":1,
 "extraGameBonus":5,
 "active":true
}

Alanlar:

Alan	Açıklama
winnerPoint	Kazanan puanı
penaltyMultiplier	Ceza katsayısı
extraGameBonus	Fazla oyun bonusu
active	Aktif kural
11. Player Statistics Collection

Oyuncu performans bilgileri.

Örnek:

{
"userId":"user123",
"leagueId":"league001",
"gamesPlayed":50,
"wins":30,
"losses":20,
"averageScore":75
}

Tutulan bilgiler:

Oyun sayısı
Galibiyet
Mağlubiyet
Ortalama skor
En yüksek skor
En düşük skor
12. Head To Head Statistics

Oyuncuların birbirine karşı performansı.

Örnek:

Ahmet vs Mehmet

{
"player1":"Ahmet",
"player2":"Mehmet",
"totalGames":20,
"player1Wins":13,
"player2Wins":7
}

Kullanım:

"Ahmet sana karşı kaç kere kazandı?"

sorusunun cevabı buradan alınır.

13. Ranking Calculation

Lig sıralaması direkt toplam puana bağlı olmayacaktır.

Hesaplama:

Final Score =

Base Score

+

Average Performance Score

+

Participation Bonus

+

Achievement Bonus

Örnek:

Oyuncu A:

1000 puan

20 oyun

Oyuncu B:

1200 puan

80 oyun

Adalet için:

Ortalama performans dikkate alınır.

14. Yazboz System Design

Yazboz ekranı uygulamanın temel oyun giriş ekranıdır.

Amaç:

Hızlı skor girişi
Manuel kullanım kolaylığı
Hata düzeltilebilir yapı

Akış:

Oyuncular seçilir
Oyun başlatılır
Her el sonucu girilir
Sistem otomatik hesaplar
Oyun tamamlanır
Lig puanı güncellenir
15. Future Database Improvements

İleride:

Turnuva sistemi
Global sıralama
Oyuncu rating sistemi
AI destekli analiz
Performans tahmini
Sezon sistemi
Özel lig kuralları

eklenebilir şekilde tasarlanmıştır.