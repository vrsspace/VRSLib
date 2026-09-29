# 🌸 VRSLib V2 — Developer Documentation & API Reference

Dokumentasi resmi untuk **VRSLib V2 (`VRSLibV2.lua`)** — Engine UI Roblox generasi terbaru dengan desain **Matte Obsidian (#0F1015) & Signature Neon Pink (#FF408C)** yang terinspirasi 1:1 dari UI modern hub (Ouroboros / Slayer 2 design language).

---

## 🎨 Desain & Tampilan Utama

1. **Floating Left Sidebar (76px)**:
   - Logo Wings / emblem di bagian atas dengan efek hover glow.
   - Tombol tab vertikal (58x50px) dengan **Active Indicator Bar** (vertical neon pink pill) di sisi kiri saat tab aktif.
   - User Profile Card di bagian bawah sidebar dengan headshot thumbnail pemain, online green status dot, dan nama pemain.
2. **Modern Top Header**:
   - Icon tab aktif + judul utama dinamis ("Welcome to <GameName>!").
   - **Horizontal Sub-Nav Pills**: Menu sub-tab horizontal (seperti `[ ⊞ Overview ]`, `[ ▷ Main Menu ]`, `[ ⚔ Quests & Mobs ]`, dll.).
   - Search Bar kapsul responsif dengan auto-filter.
   - Kontrol Window minimalis: Minimize (`—`) dan Close / Unload (`✕`).
3. **Full Dashboard Suite (Screenshot 1)**:
   - **User Welcome Card**: Avatar bulat besar, display name, handle `@username`, version badge (`⚔ v0.141`), serta switch streamer mode (`Name` & `Profile`).
   - **6-Box Quick Stat Grid**: Players, Friends, Execs, Session timer (live), FPS counter (live 60/240), dan Ping (live ms).
   - **Game Information Card**: Thumbnail game, nama game, creator, Job ID, Place ID, Universe ID, serta tombol server action (`Rejoin`, `Server Hop`, `Copy Job ID`, `Copy Universe`, `Join Lowest Server`).
   - **Warning / Notice Banner**: Shield icon dengan warna status (oranye/pink), deskripsi, dan hotkey pill (`RCtrl to hide`).
   - **Two-Column Quick Links**: Kartu Discord komunitas dan link game yang didukung dengan tombol copy.
   - **Feature List Card**: Ringkasan jumlah fitur dan tab dengan tombol action.
4. **Groupbox & Dual-Column Section Suite (Screenshot 2 / Farm & Combat)**:
   - 2-Kolom fleksibel dengan collapsible groupboxes.
   - Komponen: Animated Neon Pink Pill Toggle, Numeric Sliders, Action Buttons, Inline Searchable Dropdowns (Single & Multi-Select), Text Inputs, Keybinds, dll.
5. **Mobile & Viewport Auto-Scaling**:
   - `UIScale` otomatis mendeteksi ukuran layar sehingga window tidak pernah terpotong di layar HP/tablet.
   - Floating logo button yang draggable saat window di-minimize.

---

## 🚀 Cara Menjalankan

### 1. Menjalankan Showcase Lengkap (`ExampleV2.lua`)
Di executor Anda:
```lua
-- Jalankan file lokal
loadstring(readfile("ExampleV2.lua"))()

-- Atau via link raw GitHub setelah push
-- loadstring(game:HttpGet("https://raw.githubusercontent.com/.../ExampleV2.lua"))()
```

### 2. Import & Inisialisasi Manual
```lua
local VRSLibV2 = loadstring(readfile("VRSLibV2.lua"))()

local Window = VRSLibV2:CreateWindow({
    Title    = "auto", -- Otomatis menjadi "Welcome to <GameName>!"
    SubTitle = "v0.141",
    Size     = UDim2.fromOffset(1020, 620),
    Accent   = Color3.fromRGB(255, 64, 140), -- VRS Signature Neon Pink
    Keybind  = Enum.KeyCode.RightControl
})
```

---

## 📑 API Reference

### `Window:AddTab(config)`
Menambahkan tab navigasi ke sidebar kiri.
```lua
local TabHome = Window:AddTab({
    Name = "Home",
    Icon = "home", -- Nama icon Lucide
    LayoutOrder = 1
})
```

### `Tab:AddSubTab(config)`
Menambahkan sub-tab horizontal di topbar (seperti `Overview` atau `Main Menu`).
```lua
local SubOverview = TabHome:AddSubTab({
    Name = "Overview",
    Icon = "grid"
})
```

### Dashboard Elements (Dipanggil pada Tab atau SubTab)

#### 1. `AddUserCard(config)`
```lua
SubOverview:AddUserCard({
    Greeting    = "Welcome back,",
    DisplayName = "NcangRowenss",
    Username    = "ZyrexDiandra",
    Version     = "v0.141",
    LayoutOrder = 1
})
```

#### 2. `AddStatGrid(config)`
Membuat 6 kotak stat live:
```lua
SubOverview:AddStatGrid({
    LayoutOrder = 2
})
```

#### 3. `AddGameCard(config)`
```lua
SubOverview:AddGameCard({
    GameName    = "Slayers 2",
    Creator     = "Ouw Productions",
    LayoutOrder = 3
})
```

#### 4. `AddBanner(config)`
```lua
SubOverview:AddBanner({
    Title       = "Madium",
    Description = "Not on the supported list. Some features may not work.",
    Icon        = "shield",
    Color       = Color3.fromRGB(255, 175, 60),
    Badge       = "RCtrl to hide",
    LayoutOrder = 4
})
```

#### 5. `AddLinksRow(config)`
```lua
SubOverview:AddLinksRow({
    Left = {
        Title      = "Join the community",
        Subtitle   = "https://discord.gg/synapsex",
        ButtonText = "Copy Invite",
        Icon       = "message-square",
        Url        = "https://discord.gg/synapsex"
    },
    Right = {
        Title      = "Supported games",
        Subtitle   = "https://ouroboros-hub-rbx.web.app/",
        ButtonText = "Copy Website",
        Icon       = "monitor",
        Url        = "https://ouroboros-hub-rbx.web.app/"
    },
    LayoutOrder = 5
})
```

#### 6. `AddFeatureList(config)`
```lua
SubOverview:AddFeatureList({
    Title      = "Feature list",
    Subtitle   = "7 features across 2 tabs",
    ButtonText = "View Features",
    Icon       = "list",
    Callback   = function() print("Open features") end,
    LayoutOrder = 6
})
```

---

### Section & Groupbox Suite (Untuk Tab Farm, Combat, dll.)

#### 1. `AddColumns()`
Membagi halaman menjadi 2 kolom:
```lua
local LeftCol, RightCol = TabFarm:AddColumns()
```

#### 2. `AddGroupbox(config)`
```lua
local Box = LeftCol:AddGroupbox({
    Title = "Auto Leveling",
    Icon  = "swords"
})
```

#### 3. `Box:AddToggle(config)`
```lua
local myToggle = Box:AddToggle({
    Name     = "Auto Quest Farm",
    Default  = false,
    Callback = function(enabled)
        print("Toggle:", enabled)
    end
})
```

#### 4. `Box:AddSlider(config)`
```lua
local mySlider = Box:AddSlider({
    Name      = "Attack Distance",
    Min       = 5,
    Max       = 50,
    Default   = 15,
    Suffix    = " studs",
    Precision = 0,
    Callback  = function(val)
        print("Distance:", val)
    end
})
```

#### 5. `Box:AddDropdown(config)`
Single select atau multi-select dengan inline bar & search:
```lua
-- Single Select
Box:AddDropdown({
    Name     = "Target Mob",
    Options  = { "Bandit", "Demon", "Slayer" },
    Default  = "Bandit",
    Callback = function(selected)
        print("Target:", selected)
    end
})

-- Multi Select
Box:AddDropdown({
    Name     = "Filter Rarities",
    Options  = { "Common", "Rare", "Epic", "Legendary" },
    Default  = { ["Legendary"] = true },
    Multi    = true,
    Callback = function(selectedTbl)
        print("Updated:", selectedTbl)
    end
})
```

#### 6. `Box:AddButton(config)`
```lua
Box:AddButton({
    Name     = "Execute Action",
    Icon     = "zap",
    Callback = function()
        print("Button clicked!")
    end
})
```

#### 7. Toast Notification: `VRSLibV2:Notify(config)`
```lua
VRSLibV2:Notify({
    Title       = "VRS Artelier V2",
    Description = "Config saved successfully!",
    Duration    = 3.5,
    Icon        = "check"
})
```
