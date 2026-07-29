# Branching Strategy

## 1. Amaç

Bu dokümanın amacı Mobil101Lig projesinde Git branch yönetim standartlarını belirlemektir.

Amaçlar:

- Stabil kod yönetimi sağlamak
- Geliştirme sürecini düzenlemek
- Hatalı değişikliklerin ana koda ulaşmasını engellemek
- Profesyonel bir geliştirme akışı oluşturmak


---

# 2. Branch Yapısı


Mobil101Lig aşağıdaki branch stratejisini kullanır.


```
main
 |
 |
develop
 |
 |
feature/*
```


Ana branch yapısı:


| Branch | Kullanım |
|-|-|
| main | Stabil ve yayınlanabilir kod |
| develop | Günlük geliştirme branch'i |
| feature/* | Yeni özellik geliştirme |


---

# 3. Main Branch


## Amaç

`main` branch projenin stabil halidir.


Özellikleri:


- Yayına hazır kod içerir.
- Direkt geliştirme yapılmaz.
- Test edilmemiş kod bulunmaz.
- Release noktalarını temsil eder.


Örnek:


```
main
 |
 v
v1.0.0
```


---

# 4. Develop Branch


## Amaç

`develop` günlük geliştirmelerin birleştiği ana geliştirme branch'idir.


Kullanım:


- Yeni özelliklerin birleştiği alan
- Test ortamına gönderilen kod
- Feature branch'lerin merge edildiği yer


Akış:


```
feature/login

        |
        v

develop
```


---

# 5. Feature Branch


## Amaç

Yeni özellik geliştirmek için kullanılır.


Format:


```
feature/{özellik-adi}
```


Örnek:


```
feature/user-authentication

feature/game-score

feature/scoreboard

feature/firebase-integration

feature/league-ranking
```


---

# 6. Feature Branch Oluşturma


Yeni geliştirme öncesi:


Önce develop güncellenir.


```bash
git checkout develop

git pull origin develop
```


Yeni branch oluşturulur.


```bash
git checkout -b feature/example-feature
```


---

# 7. Feature Geliştirme Süreci


Standart akış:


```
develop

    |

    |

feature/new-feature

    |

    |

commit

    |

    |

push

    |

    |

Pull Request

    |

    |

develop
```


---

# 8. Commit Kuralları


Commit mesajları anlamlı olmalıdır.


Format:


```
type: açıklama
```


Örnekler:


Yeni özellik:


```
feat: add scoreboard calculation
```


Bug düzeltme:


```
fix: correct player ranking calculation
```


Dokümantasyon:


```
docs: update database documentation
```


Refactoring:


```
refactor: improve score service structure
```


---

# 9. Merge Kuralları


## Feature → Develop


Feature tamamlandığında:


```
feature/*
      |
      |
      v
develop
```


merge edilir.


Merge öncesi:


Kontrol:


```
flutter analyze

flutter test
```


çalıştırılmalıdır.


---

# 10. Develop → Main


Sadece stabil sürümler main'e alınır.


Akış:


```
develop

   |

   |

release kontrolü

   |

   |

main
```


Main'e alınmadan önce:


Kontroller:


- Testler başarılı olmalı
- Kritik hatalar olmamalı
- Dokümantasyon güncel olmalı


---

# 11. Hotfix Süreci


Canlı ortamda kritik hata oluşursa:


Akış:


```
main

 |

 |

hotfix

 |

 |

main
```


Hotfix branch:


```
hotfix/{problem}
```


Örnek:


```
hotfix/login-crash
```


Düzeltme sonrası:


- main güncellenir
- develop ile senkronize edilir


---

# 12. Release Yönetimi


Büyük sürümlerde:


Örnek:


```
v1.0.0
v1.1.0
v2.0.0
```


kullanılır.


Release oluşturma:


```
develop

   |

   |

main

   |

   |

tag
```


Örnek:


```bash
git tag v1.0.0

git push origin v1.0.0
```


---

# 13. Branch İsimlendirme Kuralları


Küçük harf kullanılmalıdır.


Doğru:


```
feature/game-score
feature/firebase-auth
feature/player-statistics
```


Yanlış:


```
Feature/GameScore
YeniOzellik
testBranch
```


---

# 14. Mobil101Lig Özel Branch Kullanımı


## Oyun Sistemi


Örnek:


```
feature/game-engine
```


içerisinde:


- Oyun oluşturma
- Skor hesaplama
- Tur yönetimi


geliştirilebilir.


---

## Yazboz Sistemi


Örnek:


```
feature/scoreboard
```


içerisinde:


- Oyuncu ekleme
- Tur girişi
- Ceza/bonus hesaplama


geliştirilebilir.


---

## Lig Sistemi


Örnek:


```
feature/league-ranking
```


içerisinde:


- Puan hesaplama
- Sıralama
- İstatistikler


geliştirilebilir.


---

# 15. Yasaklanan Kullanımlar


Aşağıdaki işlemler yapılmamalıdır.


❌ Main üzerinde direkt geliştirme


❌ Develop üzerinde büyük deneysel değişiklik


❌ Commit geçmişini gereksiz değiştirmek


❌ Test edilmemiş kod merge etmek


❌ Anlamsız branch isimleri kullanmak



---

# 16. Günlük Geliştirme Akışı


Standart günlük akış:


```bash
git checkout develop

git pull origin develop


git checkout -b feature/my-feature


# geliştirme


git add .

git commit -m "feat: implement my feature"


git push origin feature/my-feature
```


Sonrasında Pull Request açılır.


---

# 17. Branch Temizliği


Merge edilen feature branch'ler silinebilir.


Local:


```bash
git branch -d feature/example
```


Remote:


```bash
git push origin --delete feature/example
```


---

# 18. Son Kural


Mobil101Lig Git yönetiminde öncelik:


1. Stabilite
2. İzlenebilir geliştirme
3. Temiz commit geçmişi
4. Güvenli release süreci


olacaktır.


Basit, anlaşılır ve sürdürülebilir branch yapısı kullanılacaktır.