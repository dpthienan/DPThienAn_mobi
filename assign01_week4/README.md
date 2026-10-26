# assign01_week4 — UTH Todo (Navigation + OOP)

Bài thực hành **Navigation + OOP** (Week 4).

## Yêu cầu đã làm

- **Splash** → **Onboarding (3 bước)** → **Home**
- **Tất cả dữ liệu dùng OOP** (`AppInfo`, `OnboardingPage`, `Task`, `TaskCategory`, …) qua `AppDataProvider`
- UI bám mockup UTH Todo (tím #6200EE)

## Chạy project

1. Mở thư mục `assign01_week4` bằng **Android Studio**
2. Sync Gradle → Run trên emulator/device

## Cấu trúc chính

```
app/src/main/java/com/example/uthtodo/
├── MainActivity.kt
├── data/AppDataProvider.kt          # nguồn dữ liệu OOP
├── model/                           # AppInfo, OnboardingPage, Task, ...
├── navigation/AppNavigation.kt      # NavHost: splash → onboarding → home
└── ui/
    ├── components/                  # Header, PageIndicator, Button, Illustration
    ├── screens/                     # Splash, Onboarding, Home
    └── theme/
```

## Luồng Navigation

| Route        | Màn hình    | Hành động                          |
|--------------|-------------|------------------------------------|
| `splash`     | Splash      | Tự chuyển sau ~2.2s                |
| `onboarding` | Onboarding  | Tiếp tục / Bỏ qua → Home           |
| `home`       | Home        | Danh sách Task (OOP)               |
