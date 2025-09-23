#  Documentation

# Trip Planner Documentation

## Opening the Project
1. Open Xcode.
2. Click `File → Open` and select `TopPlanner.xcodeproj`.
3. Select the target device / simulator.

## Key Files
- `AppDelegate.swift` / `SceneDelegate.swift` → App lifecycle
- `Views/` → 
    - `LoginView.swift`
    - `RegisterView.swift`
    - `HomeView.swift`
    - `ProfileView.swift`
    - `TripsView.swift`
- `ViewModels/` → 
    - `LoginViewModel.swift`
    - `RegisterViewModel.swift`
    - `HomeViewModel.swift`
    - `ProfileViewModel.swift`
- `Components/` → Reusable UI elements:
    - `SearchBar.swift`
    - `TripCard.swift`
- `CoreData/` → Persistence models
- `Resources/` → Images, assets

## Flow
1. **Launch** → Checks if user is logged in:
   - Logged in → HomeView
   - Not logged in → LoginView
2. **Register/Login**
   - Offline support → Saves locally, syncs with Firebase when online
3. **HomeView**
   - Shows profile, trips cards, categories
   - Search bar (expandable)
   - Bell button (planned for trip sharing)
4. **ProfileView**
   - Shows user info, editable profile picture
   - Completed/pending trips (dummy)
5. **TripsView**
   - Allows trip creation (future: fetch real trains/buses/flights)
6. **Popup for registration**
   - Restricts trip planning for unregistered users
