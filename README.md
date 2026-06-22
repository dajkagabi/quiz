# Magyar Rock Kvíz
Egy modern, letisztult és kifejezetten látványos Flutter alapú kvízalkalmazás, amely a magyar rockzene legendás korszakaiba, ikonikus zenekaraiba és örökzöld dalaiba kalauzolja el a játékosokat. A projekt különlegessége, hogy a szórakoztatás mellett oktatási célt is szolgál: minden kérdés mögött hiteles, hivatalos zenetörténeti adatok (Hungaroton katalógusinformációk és Artisjus ISWC kódok) találhatók meg, amelyek a válaszadást követően extra érdekességként jelennek meg a képernyőn.

## Telepítés
Előfeltételek
A projekt futtatásához az alábbi környezeti elemek megléte szükséges:
- Flutter SDK: 3.0.0 vagy újabb (javasolt stabil verzió)
- Dart SDK: Megfelelő párosított verzió a Flutter verzióhoz
- IDE (Visual Studio Code), Android-Studio: Emulator
- Fizikai eszközök

# Telepítési lépések
Klónozd a tárolót (Repository):
Bash
```
git clone https://github.com/dajkagabi/quiz.git
cd quiz
```

# Függőségek, csomagok
Bash
```
flutter pub get
```
Bash
```
flutter run
```
vagy F5

# Funkciók
- 3 különböző nehézségi szint:

- 🟢 Klasszikus Rock (Easy): A legszélesebb körben ismert slágerek és alapvető zenei információk.

- 🟡 Haladó Rocker (Medium): Mélyebb zenei ismereteket igénylő kérdések, progresszív és underground elemekkel fűszerezve.

- 🔴 EXTRÉM Rocklegenda (Extreme): Igazi ritkaságok, thrash metal zúzások, fúziós jazz-rock formációk és kultikus underground titkok.

- Változatos és egyedi kérdéssor: A kvíz szigorú strukturális szabálya, hogy minden zenekar vagy előadó pontosan egyszer szerepel a teljes játékban, ezáltal garantált a maximális diverzitás és az ismétlődések elkerülése.

- Hiteles háttérinformációk (SourceCard): A játékos minden megválaszolt kérdés után azonnali visszajelzést kap a dal hátteréről. Megtekinthetők a hivatalos Hungaroton lemezadatok (eredeti album címe, kiadás éve, al-kiadó) és az Artisjus adatai (zeneszerzők/szövegírók pontos megnevezése, hivatalos ISWC kód).

- Intelligens időzítések és animációk: A válasz gombra kattintva az alkalmazás 500 ms vizuális visszajelzést ad (helyes válasz esetén zöld, tévesnél piros kiemeléssel), majd automatikusan legördül a forráskártyához, végül 1 másodperc elteltével elegáns áttűnéssel vált a következő kérdésre.

- Részletes értékelő képernyő: A kvíz végén az elért pontszám és a százalékos teljesítmény függvényében egyedi rangot, színes ikont és szöveges értékelést kap a felhasználó.

# Technológia
Főbb technológiák
- Flutter Framework: Deklaratív, keresztplatformos UI fejlesztés a natív teljesítményért.
- BLoC / Cubit Mintázat: Az üzleti logika és az UI állapotának (State Management) szigorú elválasztása a tiszta, tesztelhető és fenntartható kód érdekében (QuizCubit és QuizState).
- Repository Pattern: Az adatforrások biztonságos kezelése (QuizRepository), amely aszinkron módon olvassa be és alakítja át (pásztázza) a helyi JSON állományt Dart objektumokká.

# Könyvtárak
Az alkalmazás az alábbi kulcsfontosságú csomagokra támaszkodik:
- flutter_bloc – A reaktív állapotkezelés megvalósításához.
- lucide_icons_flutter – A modern, minimalista és letisztult rock-zenei ikonok (például a bakelit/CD lemezt szimbolizáló LucideIcons.disc) megjelenítéséhez.
- flutter/services.dart – A beépített rootBundle használatával a helyi erőforrások (JSON fájl) hatékony és aszinkron eléréséhez.

<img width="318" height="743" alt="Képernyőkép 2026-06-22 202947" src="https://github.com/user-attachments/assets/011e79d4-5a5d-4f94-8c8b-d038aea53285" />
<img width="318" height="743" alt="Képernyőkép 2026-06-22 202927" src="https://github.com/user-attachments/assets/78d6e22b-4eff-43ac-820f-f1a4d23bf7e0" />
<img width="318" height="743" alt="Képernyőkép 2026-06-22 202904" src="https://github.com/user-attachments/assets/1b990eb7-3438-4303-aa45-35e0e5da3402" />
<img width="318" height="743" alt="Képernyőkép 2026-06-22 202856" src="https://github.com/user-attachments/assets/ec58c893-23bc-42a2-9bc4-e1c34017ab58" />
<img width="318" height="743" alt="Képernyőkép 2026-06-22 202843" src="https://github.com/user-attachments/assets/f2fa9527-dcec-487b-867e-78a93fc1338b" />
<img width="318" height="743" alt="Képernyőkép 2026-06-22 202837" src="https://github.com/user-attachments/assets/9ceedd55-8558-4bc5-b061-51e1901e98f1" />
