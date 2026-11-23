# Dex — SwiftUI Pokédex with widgets

An iOS 18 Pokédex built with SwiftUI. It downloads Pokémon from
[PokéAPI](https://pokeapi.co), stores them on the device for offline use,
and shows them in Home Screen widgets.

<p>
  <img src="https://github.com/user-attachments/assets/55675aaa-b24c-4f63-b5e2-2b0c245b05e9" height="300"/>
  <img src="https://github.com/user-attachments/assets/d6c37367-d1e9-4262-a5f2-497bbeb9464a" height="300"/>
  <img src="https://github.com/user-attachments/assets/66ed8f9c-5c38-4b4b-80dc-c9f7c4d9a4ef" height="300"/>
  <img src="https://github.com/user-attachments/assets/29909dff-4437-4038-affe-909c791933eb" height="300"/>
  <img src="https://github.com/user-attachments/assets/73d52bc1-3f2b-4751-9d42-8a4834c436b7" height="300"/>
  <img src="https://github.com/user-attachments/assets/3c899891-8165-4008-9de9-f37b9df60bc8" height="300"/>
  <img src="https://github.com/user-attachments/assets/57f901a6-56f8-4fed-b564-fc6373a4d249" height="300"/>
  <img src="https://github.com/user-attachments/assets/c8490cea-883b-4e56-86a0-f9b57c52559f" height="300"/>
  <img src="https://github.com/user-attachments/assets/f6c1a5e8-c3c4-4277-b46f-f16fc203c9ce" height="300"/>
  <img src="https://github.com/user-attachments/assets/35a5563f-4247-4180-82cd-f0f5183cdf30" height="300"/>
  <img src="https://github.com/user-attachments/assets/e299aca3-fc7f-4476-bcc0-77ce2d875ad0" height="300"/>
  <img src="https://github.com/user-attachments/assets/b786320e-a7df-4ad9-92e0-9d9882e2b8e5" height="300"/>
</p>

## ✨ Features
- Pokédex list with search, favourites filter and swipe actions
- Detail screen with types, a shiny toggle and base stats in a Swift Charts bar chart
- Offline-first: Pokémon data and images are downloaded once and kept on the device
- Empty states with `ContentUnavailableView`
- Widget extension in small, medium and large sizes, sharing data with the app

## 🛠️ Tech
- SwiftUI · Swift Charts · WidgetKit (`TimelineProvider`)
- SwiftData (`@Model`, `@Query`, `ModelContainer`) shared between the app and the widget
- `URLSession` with async/await to fetch from PokéAPI
- MVVM structure (Models · Services · ViewModels · Views)
- iOS 18.4+

## 🔄 How it evolved
I built the first version with Core Data, then migrated the model and the widget
to SwiftData and reorganised the code into MVVM.

## ▶️ Run it
Open `Dex.xcodeproj` in Xcode 16 or later, select the **Dex** scheme and run it
on an iOS 18.4 simulator. To try the widget, run the **DexWidgetExtension** scheme.

## 🎓 Credits
Built while following the Udemy course *iOS 18, SwiftUI 6 & Swift 6: Build iOS
Apps From Scratch*, then refactored on my own (SwiftData migration and MVVM).
Pokémon data from PokéAPI. Pokémon is © Nintendo / The Pokémon Company.
