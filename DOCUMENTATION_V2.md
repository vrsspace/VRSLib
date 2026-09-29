# ⬛ VRS Mono Engine (V2 Reborn) — Documentation

Modern Roblox Luau UI Library engineered with 1:1 precision according to the minimalist dark design specifications:
* **Solid Charcoal Abu-Abu Body** (`#131419`, pure solid matte finish, no unwanted transparent gradients).
* **Floating Frosted Glass Sidebar** (`#0E0F14`, `0.22` translucency with specular glass sheen).
* **Top-Left Brand Logo** (VRS Wings emblem `rbxassetid://132717088484517` inside a rounded container).
* **Active Tab Capsule Indicator** (Sleek pure white vertical pill on the left edge).
* **Bottom Profile Footer** (Circular headshot avatar with emerald green online status indicator dot).
* **Strict Monochrome Palette** (Charcoal, dark slate, and pure white accents — zero neon pink).
* **Unified Drag Container** (Zero detached shadow frames, no double-window visual bugs).
* **Embedded Lucide Icon Engine** (100+ high-frequency icons embedded directly).

---

## 📂 Struktur File

```
[ UI LIB ]/
├── VRSLibV2.lua           # Master UI Library Engine (Mono V2 Reborn)
├── ExampleV2.lua          # General Component Test Script
├── DOCUMENTATION_V2.md    # Panduan & Dokumentasi Lengkap
└── src/
    └── Icons.lua          # Full Lucide Icon Engine
```

---

## 🚀 Cara Menjalankan

### Melalui Executor (Synapse / Wave / Solara / dll.)

Pastikan file `VRSLibV2.lua` berada di folder workspace executor Anda atau di dalam path `[ UI LIB ]/VRSLibV2.lua`.

```lua
local VRSLibV2 = loadstring(readfile("VRSLibV2.lua"))()

local Window = VRSLibV2:CreateWindow({
    Title    = "auto", -- Otomatis: "Welcome to <GameName>!"
    SubTitle = "v0.167",
    Size     = UDim2.fromOffset(1020, 620),
    Keybind  = Enum.KeyCode.RightControl
})
```

---

## 🧭 Navigasi Sidebar & Sub-Tabs

### 1. Menambahkan Tab Sidebar
Sidebar otomatis menampilkan logo Wings di kiri atas, daftar tab dengan indikator kapsul putih di sisi kiri tab yang sedang aktif, serta widget profil dengan titik hijau di bagian bawah.

```lua
local TabHome     = Window:AddTab({ Name = "Home",     Icon = "home",     HeaderTitle = "auto" })
local TabControls = Window:AddTab({ Name = "Controls", Icon = "sliders",  HeaderTitle = "Component Testing" })
local TabSettings = Window:AddTab({ Name = "Settings", Icon = "settings", HeaderTitle = "System Configuration" })
```

### 2. Menambahkan Sub-Tab (Horizontal Pill Bar di Header)
Sub-tab akan dirender horizontal di bawah judul jendela (`[田 Overview] [▷ Main Menu]`):

```lua
local SubOverview = TabHome:AddSubTab({ Name = "Overview",  Icon = "overview" })
local SubMenu     = TabHome:AddSubTab({ Name = "Main Menu", Icon = "menu" })
```

---

## 📊 Dashboard & Status Components

### 1. Profile / Hero Card
Menampilkan avatar pemain saat ini, nama display, handle username, dan badge versi di kanan atas:
```lua
SubOverview:AddProfileCard({
    Badge = "v0.167"
})
```

### 2. Live Stat Row
Menampilkan deretan kartu stat horizontal interaktif (Players, Friends, Execs, Session, FPS, Ping) yang nilainya dapat di-update secara live:
```lua
local Stats = SubOverview:AddStatRow({
    { Title = "Players", Value = "1/1",     Icon = "players" },
    { Title = "Friends", Value = "0",       Icon = "friends" },
    { Title = "Execs",   Value = "5",       Icon = "execs" },
    { Title = "Session", Value = "0m 00s",  Icon = "session" },
    { Title = "FPS",     Value = "240",     Icon = "fps" },
    { Title = "Ping",    Value = "28ms",    Icon = "ping" }
})

-- Update nilai secara live:
Stats["FPS"].UpdateValue("245")
Stats["Ping"].UpdateValue("18ms")
```

### 3. Notice / Warning Banner
Kartu notifikasi dengan icon perisai kuning/emas, deskripsi, dan tombol badge di sebelah kanan:
```lua
SubOverview:AddBanner({
    Title   = "Mono Engine",
    Message = "Pure monochrome aesthetic active. Frosted glass floating sidebar enabled.",
    Icon    = "shield",
    Badge   = "RCtrl to hide"
})
```

### 4. InfoRow (Key-Value Row dengan Tombol Aksi)
Sangat cocok untuk link Discord, tautan website, atau informasi konfigurasi:
```lua
MyGroupbox:AddInfoRow({
    Name       = "Join the community",
    Value      = "https://discord.gg/synapsex",
    Icon       = "globe",
    ButtonText = "Copy Invite",
    Callback   = function(val)
        if setclipboard then setclipboard(val) end
        Window:Notify({ Title = "Success", Description = "Link copied!" })
    end
})
```

---

## 🎛️ Interactive Controls (Groupbox Components)

Buat kontainer groupbox terlebih dahulu:
```lua
local Box = SubOverview:AddGroupbox({ Title = "General Settings", Icon = "sliders" })
```

### 1. Toggle / Switch (Pill iOS Monochrome)
Knob halus, background putih saat ON dan abu-abu gelap saat OFF:
```lua
local Toggle = Box:AddToggle({
    Name     = "Auto Attack",
    Default  = false,
    Callback = function(enabled)
        print("State:", enabled)
    end
})

Toggle:SetValue(true) -- Mengubah state secara programmatik
print(Toggle:GetValue())
```

### 2. Slider (dengan Value Pill Badge)
Dilengkapi value pill badge di kanan atas (`50%` / `10s`), track bar halus, dan knob draggable:
```lua
local Slider = Box:AddSlider({
    Name     = "WalkSpeed",
    Min      = 16,
    Max      = 250,
    Default  = 32,
    Step     = 1,
    Suffix   = " spd",
    Callback = function(val)
        print("Speed:", val)
    end
})

Slider:SetValue(50)
print(Slider:GetValue())
```

### 3. Inline Drop Bar (Dropdown)
Mendukung single select maupun multi select dengan menu popout mengambang yang halus:
```lua
-- Single Select
local Dropdown = Box:AddDropdown({
    Name     = "Target Mode",
    Items    = { "Closest Distance", "Lowest HP", "Highest Level" },
    Default  = "Closest Distance",
    Multi    = false,
    Callback = function(selected)
        print("Selected:", selected)
    end
})

-- Multi Select
local MultiDrop = Box:AddDropdown({
    Name     = "Active Zones",
    Items    = { "Village", "Cave", "Forest", "Mountain" },
    Default  = { "Village", "Cave" },
    Multi    = true,
    Callback = function(selectedList)
        print("Selected zones:", table.concat(selectedList, ", "))
    end
})
```

### 4. Input Box (TextBox)
Input teks modern dengan placeholder dan highlight fokus:
```lua
local Input = Box:AddInput({
    Name        = "Target Name",
    Placeholder = "e.g. Demon King",
    Default     = "",
    Callback    = function(text, enterPressed)
        print("Entered:", text)
    end
})
```

### 5. Action Button
Tombol interaktif dengan efek hover dan animasi klik:
```lua
Box:AddButton({
    Name     = "Execute Action",
    Callback = function()
        print("Button pressed!")
    end
})
```

### 6. Keybind
Badge tombol interaktif yang dapat di-rebind secara realtime:
```lua
local Keybind = Box:AddKeybind({
    Name     = "Quick Teleport",
    Default  = Enum.KeyCode.F,
    Callback = function(key)
        print("Key pressed:", key.Name)
    end
})
```

---

## 🔔 Sistem Notifikasi

```lua
Window:Notify({
    Title       = "Information",
    Description = "Action completed successfully.",
    Duration    = 3
})
```
