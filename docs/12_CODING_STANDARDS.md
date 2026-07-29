# 12 - Coding Standards Document

## 1. Doküman Amacı

Bu dokümanın amacı Mobil101Lig uygulamasında geliştirilecek tüm kodların;

- Okunabilir
- Sürdürülebilir
- Test edilebilir
- Genişletilebilir
- Takım çalışmasına uygun

olmasını sağlamaktır.

Bu standartlar tüm geliştirme süreçlerinde uygulanacaktır.


---

# 2. Genel Kod Prensipleri


## Clean Code Prensipleri


Kod aşağıdaki prensiplere uygun yazılmalıdır:


- Anlaşılır isimlendirme kullanılmalıdır.
- Metotlar tek bir sorumluluk taşımalıdır.
- Gereksiz karmaşıklıktan kaçınılmalıdır.
- Tekrarlayan kod oluşturulmamalıdır.
- Magic number kullanılmamalıdır.
- Business logic UI içerisinde yazılmamalıdır.


---

# 3. Architecture Kuralları


Mobil101Lig aşağıdaki mimari yapıyı kullanır:



Presentation

↓

Domain

↓

Data

↓

External Services



---

# Presentation Layer


Sorumlulukları:


- UI gösterimi
- Kullanıcı etkileşimi
- State yönetimi


İçermemesi gerekenler:


❌ Firebase çağrıları

❌ Database işlemleri

❌ Business logic


Örnek:


Yanlış:


```dart
onPressed(){
 FirebaseFirestore.instance
 .collection("games")
 .add(data);
}

Doğru:

onPressed(){

 createGameUseCase.execute();

}
Domain Layer

Uygulamanın iş kuralları burada bulunur.

İçerir:

Entity
Use Case
Repository Interface

Örnek:

domain

 ├── entities
 ├── repositories
 └── usecases
Data Layer

Dış kaynak işlemleri burada bulunur.

İçerir:

Model
Repository Implementation
Datasource

Örnek:

data

 ├── models
 ├── repositories
 └── datasources
4. Flutter Proje Yapısı Standartları

Feature bazlı yapı kullanılacaktır.

Örnek:

features

 └── game

     ├── data

     ├── domain

     └── presentation

Her yeni özellik kendi feature klasörüne sahip olmalıdır.

5. Naming Convention
Dosya İsimleri

Dosya isimleri:

snake_case

kullanmalıdır.

Doğru:

game_detail_page.dart

score_calculator.dart

Yanlış:

GameDetailPage.dart

ScoreCalculator.dart
Class İsimleri

PascalCase kullanılmalıdır.

Doğru:

class GameScoreCalculator
{

}

Yanlış:

class game_score_calculator
{

}
Variable İsimleri

camelCase kullanılmalıdır.

Doğru:

int playerScore;

Yanlış:

int PlayerScore;
Constant İsimleri

lowerCamelCase:

Doğru:

const maxPlayerCount = 4;
Boolean İsimleri

Anlamlı olmalıdır.

Doğru:

bool isWinner;

bool hasPermission;

Yanlış:

bool check;
6. Widget Standartları

Widget isimleri:

Page

Screen

View

Widget

Component

şeklinde isimlendirilebilir.

Örnek:

LoginPage

LeagueScreen

ScoreCardWidget
Widget Kuralları

Widget içerisinde:

Olmamalı:

❌ API çağrısı

❌ Firebase işlemi

❌ Hesaplama algoritması

Olmalı:

✅ UI oluşturma

✅ Event gönderme

✅ State gösterme

7. State Management Standartları

State yönetimi merkezi yapılmalıdır.

Kurallar:

UI içerisinde global state tutulmaz.
Business state provider/controller içerisinde yönetilir.
Async işlemler için loading/error/success durumları yönetilir.

Örnek:

enum Status {

initial,

loading,

success,

failure

}
8. Model Standartları

Model sınıfları:

Immutable olmalıdır.
fromJson/toJson desteklemelidir.
Null güvenliği sağlamalıdır.

Örnek:

class PlayerModel {

final String id;

final String name;


PlayerModel({

required this.id,

required this.name

});

}
9. Entity Standartları

Entity:

Uygulamanın gerçek iş nesnesidir.

Örnek:

Player:

class PlayerEntity {

final String id;

final String name;

final int score;

}

Entity içerisinde:

Olmamalı:

❌ Firebase kodu

❌ JSON işlemi

10. Repository Standartları

Repository:

Domain ile Data arasında köprüdür.

Örnek:

Interface:

abstract class GameRepository {


Future<GameEntity> createGame();


}

Implementation:

class GameRepositoryImpl

implements GameRepository {


}
11. Error Handling Standartları

Uygulamada exception yönetimi merkezi yapılmalıdır.

Kullanılacak yapı:

core

 └── errors

      ├── exceptions

      └── failures

Örnek:

try {

await repository.save();

}

catch(e){

throw ServerException();

}
12. Logging Standartları

Production ortamında:

Yasak:

print("data");

Kullanılmalı:

logger.info();

logger.error();
13. Firebase Kullanım Kuralları

Firebase çağrıları:

Sadece:

data layer

içerisinden yapılmalıdır.

Yanlış:

Widget

↓

Firebase

Doğru:

Widget

↓

UseCase

↓

Repository

↓

Firebase
14. Magic Number Kullanımı

Yanlış:

if(score > 101)
{

}

Doğru:

const maxScore = 101;


if(score > maxScore)

{

}
15. Comment Kullanımı

Kod açıklaması için:

Kötü:

// score artır
score++;

İyi:

// Applies participation bonus after completed game
applyBonus();

Kod kendini açıklamalıdır.

16. Async Kod Standartları

Future işlemler:

Her zaman hata yönetmeli.

Yanlış:

await saveGame();

Doğru:

try{

await saveGame();

}catch(e){

handleError();

}
17. Null Safety Kuralları

Dart null safety aktif kullanılacaktır.

Kaçınılmalı:

!

Örnek:

Yanlış:

user!.name

Doğru:

user?.name
18. Test Standartları

Yeni geliştirilen her özellik:

Zorunlu:

Unit test
Widget test

Ek olarak:

Kritik özelliklerde:

Integration test

yazılmalıdır.

19. Git Commit Standartları

Conventional Commit kullanılacaktır.

Format:

type(scope): message

Örnekler:

Feature:

feat(game): add score calculation

Bug fix:

fix(auth): resolve login issue

Documentation:

docs: update architecture document

Refactor:

refactor(score): improve calculation engine
20. Branch Kuralları

Ana yapı:

main

develop

Geliştirme:

feature/*

Örnek:

feature/game-score-engine

Bug:

hotfix/*

Örnek:

hotfix/login-crash
21. Pull Request Standartları

PR içerisinde:

Bulunmalı:

Açıklama
Yapılan değişiklikler
Test bilgisi
Screenshot (UI değişikliği varsa)
22. Code Review Kontrol Listesi

Kontrol:

[ ] Clean Architecture uygun mu?

[ ] Kod tekrar ediyor mu?

[ ] Test yazılmış mı?

[ ] Naming doğru mu?

[ ] Firebase erişimi doğru yerde mi?

[ ] Performans problemi var mı?

23. Performance Standartları

Dikkat edilecek noktalar:

Gereksiz rebuild yapılmamalı.
Büyük listelerde pagination kullanılmalı.
Firebase sorguları optimize edilmeli.
Gereksiz network çağrıları yapılmamalı.
24. Security Standartları

Kurallar:

Kullanıcı verileri korunmalıdır.
Firebase rules aktif olmalıdır.
Hassas bilgiler kod içine yazılmamalıdır.
Environment variable kullanılmalıdır.
25. Development Prensibi

Her geliştirme şu sırayla yapılmalıdır:

Requirement belirlenir.
Architecture kontrol edilir.
Domain tasarlanır.
Data bağlantısı yapılır.
UI geliştirilir.
Test yazılır.
Review yapılır.
Merge edilir.
26. Sonuç

Bu standartlar Mobil101Lig projesinin;

Profesyonel seviyede geliştirilmesini,
Yeni özelliklerin kolay eklenmesini,
Kod kalitesinin korunmasını,
Uzun vadeli sürdürülebilir olmasını

sağlamak amacıyla oluşturulmuştur.