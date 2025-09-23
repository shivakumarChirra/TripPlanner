#  ReadMe

# Trip Planner  - iOS Trip Planning App

**Trip Planner** is an iOS app that allows users to plan trips, track trips, and share travel plans with friends. The app works online and offline with Firebase integration and Core Data persistence.

## Features
- User registration & login (offline & online)
- Profile management (profile image, username, email)
- Home page with recommended trips, most hyped places
- Search bar with expandable glass effect
- Completed, pending, and featured trips (UI ready)
- Popup for registration before planning trips
- Future planned features:
  - Trip sharing with other users
  - Real-time travel suggestions (trains, buses, flights)
  - Hotel and restaurant filtering
  - Level-based gamification

## Setup
1. Clone the repository.
2. Open `TopPlanner.xcodeproj` in Xcode.
3. Make sure your `GoogleService-Info.plist` is in the project (Firebase).
4. Run on iOS 15+ simulator or device.

## Folder Structure
- `Authentication/` → Reusable UI components (Authentication bar, cards)
- `Components/` → Reusable UI components (search bar, cards)
- `Views/` → All app views (Home, Profile, Trips, Budget)
- `Models/` → Data models
- `ViewModels/` → MVVM view models
- `Resources/` → Assets, images, icons
- `CoreData/` → Persistence models

## License
See `LICENSE.md`.

## Notes
- App works offline for login & registration.
- Admin can manage orders in food app module (if included).
- This project is under active development.

