# 08 - API Architecture & Service Design


# 1. API Genel Yaklaşım


Mobil101Lig uygulaması Firebase tabanlı servis mimarisi kullanacaktır.

Mimari:


```
Flutter Application

        |

Service Layer

        |

Firebase SDK

        |

Cloud Firestore

        |

Cloud Functions
```


Amaç:

- Hızlı geliştirme
- Gerçek zamanlı veri akışı
- Ölçeklenebilir yapı
- Backend bağımsız servis mimarisi



---

# 2. API Katmanları


Uygulama içerisinde üç temel servis katmanı bulunacaktır.


## Presentation Layer


Sorumluluk:

- Kullanıcı etkileşimleri
- UI yönetimi
- State yönetimi


Örnek:


```
GamePage

LeaguePage

StatisticsPage
```



---

## Domain Layer


İş kuralları burada bulunur.


Örnek:


```
CalculateScoreUseCase

CreateLeagueUseCase

FinishGameUseCase
```



---

## Data Layer


Firebase iletişimini yönetir.


Örnek:


```
LeagueRepository

GameRepository

UserRepository
```



---

# 3. Authentication API


Firebase Authentication kullanılacaktır.



## Login


Amaç:

Kullanıcı girişi yapmak.


Method:


```
signIn()
```


Input:


```json
{
 "email":"user@test.com",
 "password":"123456"
}
```


Response:


```json
{
 "userId":"abc123",
 "status":"success"
}
```



---

# Register


Method:


```
register()
```


Input:


```json
{
 "displayName":"Ahmet",
 "email":"test@test.com",
 "password":"123456"
}
```


Response:


```json
{
 "userId":"abc123"
}
```



---

# Logout


Method:


```
logout()
```



---

# 4. User API


## Get User Profile


Amaç:

Kullanıcı bilgilerini almak.


Method:


```
getUserProfile(userId)
```



Response:


```json
{
 "id":"abc123",
 "name":"Ahmet",
 "totalGames":50,
 "totalScore":3500
}
```



---

## Update Profile


Method:


```
updateProfile()
```



Güncellenebilir alanlar:


- Kullanıcı adı
- Profil fotoğrafı



---

# 5. League API


# Create League


Yeni lig oluşturma.


Method:


```
createLeague()
```



Input:


```json
{
"name":"Pazar Ligi",
"ownerId":"abc123"
}
```



Response:


```json
{
"leagueId":"league001"
}
```



---

# Get User Leagues


Kullanıcının bulunduğu ligleri getirir.


Method:


```
getMyLeagues()
```



Response:


```json
[
 {
  "leagueId":"1",
  "name":"Pazar Ligi"
 }
]
```



---

# Join League


Method:


```
joinLeague()
```



Input:


```json
{
"leagueId":"league001",
"userId":"abc123"
}
```



---

# Remove Player


Sadece lig sahibi kullanabilir.


Method:


```
removePlayer()
```



---

# 6. Game API


# Create Game


Yeni oyun oluşturur.


Method:


```
createGame()
```



Input:


```json
{
"leagueId":"league001",

"players":[
"user1",
"user2",
"user3",
"user4"
],

"gameType":"single"
}
```



Response:


```json
{
"gameId":"game001"
}
```



---

# Start Game


Oyunu başlatır.


Method:


```
startGame(gameId)
```



Durum:


```
CREATED

        |

STARTED
```



---

# 7. Yazboz API


Yazboz ekranı için özel servisler.


---

# Add Round


Yeni el ekler.


Method:


```
addRound()
```



Input:


```json
{
"gameId":"game001",

"roundNumber":5,

"scores":[

 {
  "playerId":"user1",
  "score":120
 },

 {
  "playerId":"user2",
  "score":-50
 }

]
}
```



---

# Update Round


Yanlış girilen eli düzeltmek için.


Method:


```
updateRound()
```



Yetki kontrolü yapılacaktır.



---

# Delete Round


Method:


```
deleteRound()
```



Sadece oyun tamamlanmadan önce kullanılabilir.



---

# 8. Game Finish API


Oyunu tamamlar.


Method:


```
finishGame()
```



Akış:


```
Finish Request

        |

Validate Scores

        |

Calculate Score

        |

Update League Ranking

        |

Create Statistics

        |

Send Notification
```



Response:


```json
{
"winner":"user1",

"earnedPoint":100,

"status":"completed"
}
```



---

# 9. Score Calculation API


Puan hesaplama servisi.


Method:


```
calculateGameScore()
```



Input:


```json
{
"gameId":"game001"
}
```



Response:


```json
{
"players":[

{
"id":"user1",
"point":100
},

{
"id":"user2",
"point":-50
}

]
}
```



---

# 10. Statistics API


## Player Statistics


Method:


```
getPlayerStatistics()
```



Response:


```json
{
"totalGames":100,

"wins":60,

"winRate":60,

"averageScore":75
}
```



---

# Player vs Player Statistics


Rakip analizi.


Method:


```
getPlayerComparison()
```



Response:


```json
{
"player1":"Ahmet",

"player2":"Mehmet",

"games":25,

"player1Wins":15,

"player2Wins":10
}
```



---

# 11. Ranking API


Lig sıralaması.


Method:


```
getLeagueRanking()
```



Response:


```json
[
{
"name":"Ahmet",

"score":2500,

"rank":1
}
]
```



---

# 12. Notification API


Firebase Cloud Messaging kullanılacaktır.


Bildirim tipleri:


```
LEAGUE_INVITE

GAME_STARTED

GAME_COMPLETED

RANKING_CHANGED
```



Örnek:


```json
{
"title":"Oyun Tamamlandı",

"message":"Ahmet kazandı"
}
```



---

# 13. Error Handling


Tüm servislerde standart hata yapısı kullanılacaktır.


Format:


```json
{
"success":false,

"errorCode":"GAME_NOT_FOUND",

"message":"Oyun bulunamadı"
}
```



---

# 14. API Error Codes


Örnek:


|Kod|Açıklama|
|-|-|
|AUTH_001|Yetkisiz kullanıcı|
|USER_001|Kullanıcı bulunamadı|
|LEAGUE_001|Lig bulunamadı|
|GAME_001|Oyun bulunamadı|
|SCORE_001|Skor hatalı|
|PERMISSION_001|Yetki yok|



---

# 15. Offline Strategy


Firebase offline desteği kullanılacaktır.


Offline yapılabilecekler:


- Yazboz skor girişi
- Son oyun görüntüleme


Online olduğunda:


```
Local Cache

      |

Firebase Sync

      |

Update Database
```



---

# 16. Future Backend Migration


İleride Firebase yerine özel backend kullanılabilir.


Hazırlanan yapı:


```
Repository Pattern
```


sayesinde:


Firebase:


```
FirebaseGameRepository
```


değiştirilerek:


```
ApiGameRepository
```


kullanılabilir.



---

# 17. API Security


Tüm kritik işlemler:


- Authentication kontrolü
- Authorization kontrolü
- Input validation


ile korunacaktır.



---

# Sonuç


Mobil101Lig API mimarisi;


- Firebase uyumlu,
- Flutter Clean Architecture destekli,
- değiştirilebilir,
- güvenli,
- gelecekte backend'e taşınabilir


bir servis yapısı üzerine kurulacaktır.