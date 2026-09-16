# 🌸 VRS Artelier UI Library — Developer Documentation

Welcome to the official developer guide for **VRSLib (v1.2.5)**. VRSLib is a high-performance, modular Roblox UI library designed with the **Obsidian/404hub desktop architecture**, featuring a sleek Cyber-Dark aesthetic, 100% Signature Neon Magenta Pink (`#FF408C`), dynamic 3–6 column reflow, free corner drag-resizing, and zero-compromise execution safety.

---

## 📑 Daftar Isi
1. [Fitur Unggulan](#-fitur-unggulan)
2. [Instalasi & Quick Start](#-instalasi--quick-start)
3. [Window (`VRSLib:CreateWindow`)](#-window-vrslibcreatewindow)
4. [Kategori Sidebar (`AddCategory`)](#-kategori-sidebar-addcategory)
5. [Tab & Sub-Tab Accordion](#-tab--sub-tab-accordion)
6. [Mode 1: Modular Cards (Grid & List View)](#-mode-1-modular-cards-grid--list-view)
7. [Mode 2: Split-Screen Dual Columns (Groupboxes)](#-mode-2-split-screen-dual-columns-groupboxes)
8. [Icon Engine (800+ Lucide Icons)](#-icon-engine-800-lucide-icons)
9. [Floating Mobile Widget & Drag-Resizing](#-floating-mobile-widget--drag-resizing)
10. [Notifikasi Toast (`VRSLib:Notify`)](#-notifikasi-toast-vrslibnotify)
11. [Addons (Theme & Save Manager)](#-addons-theme--save-manager)
12. [Full Working Example](#-full-working-example)

---

## ✨ Fitur Unggulan

- **Live Auto-Detect Game Name**: Membaca nama game yang sedang Anda mainkan secara dinamis via `MarketplaceService:GetProductInfo(game.PlaceId)` langsung di footer bar.
- **Wings Brand Logo**: Logo resmi VRS Artelier terintegrasi di sidebar kiri atas dan widget floating mobile.
- **Dynamic 3–6 Column Reflow**: Grid kartu otomatis menyesuaikan jumlah kolom secara dinamis saat window di-resize atau di layar berbeda.
- **Free Drag-Resizing**: Tarik pojok kanan-bawah (`⤡`) atau sisi kanan/bawah window untuk mengubah ukuran secara bebas (720px–1500px).
- **Dual View Layout**:
  1. **Card Mode (Grid & List)**: Kartu modular 78px ala 404hub dengan smooth pink pill toggle dan tombol action `▷`.
  2. **Split-Screen Mode**: 2 Kolom berdampingan dengan collapsible Groupbox ala Obsidian.
- **Instant Search**: Search bar di topbar memfilter kartu secara realtime berdasarkan judul maupun deskripsi modul.
- **Built-in Protection**: Bebas dari translasi otomatis Roblox (`AutoLocalize = false`) dan safe `cloneref` environment.

---

## 🚀 Instalasi & Quick Start

Untuk memuat VRSLib langsung ke executor Anda:

```lua
local repo = "https://raw.githubusercontent.com/vrsspace/VRSLib/v1.2.5/"
local VRSLib = loadstring(game:HttpGet(repo .. "VRSLib.lua?v=" .. tick()))()

-- Buat Window
local Window = VRSLib:CreateWindow({
    Title    = "VRS Artelier",
    SubTitle = "v1.2.5",
    Size     = UDim2.fromOffset(1020, 620),
    Accent   = Color3.fromRGB(255, 64, 140),
    Keybind  = Enum.KeyCode.RightControl
})
```

---

## 🪟 Window (`VRSLib:CreateWindow`)

### Konfigurasi Parameter
```lua
local Window = VRSLib:CreateWindow({
    Title    = "VRS Artelier",             -- Judul utama di header
    SubTitle = "v1.2.1",                   -- Sub-judul kecil di header
    GameName = nil,                        -- Opsional: biarkan nil agar auto-detect dari PlaceId
    Size     = UDim2.fromOffset(1020, 620),-- Ukuran awal window (Min: 720x440, Max: 1500x950)
    Accent   = Color3.fromRGB(255, 64, 140),-- Warna aksen utama (Default: Neon Magenta Pink)
    Keybind  = Enum.KeyCode.RightControl   -- Tombol keyboard untuk toggle buka/tutup window
})
```

### Method pada Window
| Method | Deskripsi |
| :--- | :--- |
| `Window:Toggle()` | Membuka atau menutup window dengan animasi smooth tween. |
| `Window:ToggleMaximize()` | Memperbesar window ke ukuran layar maksimal atau kembali ke ukuran semula. |
| `Window:Unload()` | Menutup window, membersihkan GUI dari CoreGui, dan mengeksekusi `Window.OnUnload`. |
| `Window.OnUnload = function()` | Callback yang dipanggil saat script di-unload (tombol `[X]` ditekan). |

---

## 📁 Kategori Sidebar (`AddCategory`)

Sidebar diorganisir menggunakan collapsible categories (dapat diklik untuk expand/collapse):

```lua
-- Tambahkan kategori dengan urutan layout (layoutOrder)
local CategoryUniversal = Window:AddCategory("UNIVERSAL", 10)
local CategoryCombat    = Window:AddCategory("COMBAT SYSTEMS", 20)
local CategoryMisc      = Window:AddCategory("MISCELLANEOUS", 30)
```

> [!NOTE]
> Kategori `QUICK` sudah otomatis dibuat secara bawaan dan berisi tab bawaan:
> - **All modules**: Menampilkan seluruh modul dari semua tab.
> - **Pinned**: Menampilkan modul yang di-pin/favorit.
> - **Active**: Menampilkan modul yang sedang menyala (`Value == true`).

---

## 📑 Tab & Sub-Tab Accordion

### Membuat Parent Tab
```lua
local TabCombat = Window:AddTabGroup({
    Name     = "Combat",
    Category = "COMBAT SYSTEMS", -- Hubungkan ke nama kategori di atas
    Icon     = "swords"          -- Nama Lucide icon
})
```

### Membuat Sub-Tab (Accordion Dropdown)
Parent Tab dapat memiliki beberapa Sub-Tab. Saat diklik di sidebar, anak sub-tab akan muncul di bawahnya dan Sub-NavBar horizontal akan aktif di atas kartu:

```lua
local SubAutoFarm = TabCombat:AddSubTab({
    Name = "Auto Farm",
    Icon = "activity"
})

local SubBossRush = TabCombat:AddSubTab({
    Name = "Boss Rush",
    Icon = "flame"
})
```

---

## 🎴 Mode 1: Modular Cards (Grid & List View)

Mode kartu modular ala 404hub adalah tata letak standar untuk modul cepat. Grid otomatis reflow dari 3 hingga 6 kolom berdasarkan lebar window.

### 1. Toggle Card (Saklar Pink)
```lua
local CardAutoFarm = SubAutoFarm:AddModule({
    Title       = "Auto Attack",
    Description = "Automatically locks onto nearest enemy and executes weapon strikes",
    Icon        = "zap",
    Type        = "Toggle",
    Default     = false,
    Callback    = function(state)
        print("Auto Attack:", state)
    end
})

-- Menambahkan Slider di dalam Card yang sama
CardAutoFarm:AddSlider({
    Name     = "Attack Distance",
    Min      = 5,
    Max      = 50,
    Default  = 15,
    Callback = function(val)
        print("Attack Distance:", val)
    end
})
```

### 2. Action Card (Tombol Play `▷`)
```lua
SubAutoFarm:AddModule({
    Title       = "Instant Kill Aura",
    Description = "Discharges a high-damage shockwave to all nearby monsters in range",
    Icon        = "flame",
    Type        = "Action",
    Callback    = function()
        print("Instant Kill Aura triggered!")
    end
})
```

---

## 📊 Mode 2: Split-Screen Dual Columns (Groupboxes)

Untuk konfigurasi yang membutuhkan banyak kontrol rapi berdampingan (seperti pengaturan auto-dungeon, teleport, config manager):

```lua
local SubSettings = TabCombat:AddSubTab({
    Name = "Raid Settings",
    Icon = "sliders"
})

-- Inisialisasi 2 kolom berdampingan
local LeftCol, RightCol = SubSettings:AddColumns()

-- Buat Groupbox di kolom kiri dan kanan
local LeftBox  = LeftCol:AddGroupbox({ Title = "Targeting & Rotation", Icon = "crosshair" })
local RightBox = RightCol:AddGroupbox({ Title = "Execution Telemetry", Icon = "activity" })
```

### Kontrol yang Didukung di Dalam Groupbox:

#### 1. Toggle Switch
```lua
LeftBox:AddToggle({
    Title    = "Prioritize Elites",
    Default  = true,
    Callback = function(enabled)
        print("Prioritize Elites:", enabled)
    end
})
```

#### 2. Action Button
```lua
LeftBox:AddButton({
    Title    = "Reset Skill Rotations",
    Icon     = "refresh-cw",
    Callback = function()
        print("Rotations reset!")
    end
})
```

#### 3. Slider dengan Value Badge
```lua
LeftBox:AddSlider({
    Title    = "Skill Cooldown Buffer",
    Min      = 0,
    Max      = 10,
    Default  = 2,
    Unit     = "s",
    Callback = function(val)
        print("Buffer set to:", val)
    end
})
```

#### 4. Dropdown Selector
```lua
LeftBox:AddDropdown({
    Title    = "Difficulty Level",
    Values   = { "Easy", "Normal", "Hard", "Nightmare" },
    Default  = "Normal",
    Callback = function(choice)
        print("Selected:", choice)
    end
})
```

#### 5. Status Indicator (Titik Status Menyala)
```lua
local StatusRow = RightBox:AddStatus({
    Label  = "Engine State:",
    Status = "IDLE",
    Color  = Color3.fromRGB(255, 75, 75)
})

-- Ubah status secara live:
StatusRow.Set("RUNNING (Floor 12)", Color3.fromRGB(0, 255, 128))
```

#### 6. Text Label
```lua
RightBox:AddLabel({
    Text  = "Current Dungeon: Frostspire Bastion",
    Color = Color3.fromRGB(170, 175, 195)
})
```

#### 7. Queue List (Daftar Antrean Berwarna)
```lua
RightBox:AddQueueList({
    Items = {
        { Text = "1. Clear Mob Wave 1",   Tag = "DONE",     IsActive = false },
        { Text = "2. Slay Mid-Boss Ogre", Tag = "ACTIVE ◀", IsActive = true },
        { Text = "3. Unlock Gate Key",    Tag = "WAITING",  IsActive = false },
        { Text = "4. Final Dragon Boss",  Tag = "WAITING",  IsActive = false },
    }
})
```

---

## 🎨 Icon Engine (800+ Lucide Icons)

VRSLib sudah dilengkapi dengan database icon Lucide resmi (>800 icon) tanpa ketergantungan moderasi Roblox.

```lua
-- Mengambil rbxassetid icon berdasarkan nama
local iconId = VRSLib.Icons.Get("shield")
local homeId = VRSLib.Icons.Get("house") -- Auto-aliased dari "home"
local userLogo = VRSLib.Icons.Wings      -- Wings brand logo resmi
```

---

## 📱 Floating Mobile Widget & Drag-Resizing

- **Floating Widget**: Tombol logo sayap transparan yang dapat digeser (drag) bebas di layar untuk membuka/menutup UI, sangat ramah untuk pengguna mobile/touch screen.
- **Resize Grip**: Tarik icon `⤡` di pojok kanan bawah footer bar atau drag border tepi window untuk resize window secara instan.

---

## 🔔 Notifikasi Toast (`VRSLib:Notify`)

Tampilkan popup notifikasi modern di layar:

```lua
VRSLib:Notify({
    Title       = "VRS Artelier",
    Description = "Module configuration saved successfully!",
    Duration    = 3,
    Icon        = VRSLib.Icons.Wings
})
```

---

## 🧩 Addons (Theme & Save Manager)

VRSLib kompatibel dengan addon modular:
```lua
local repo = "https://raw.githubusercontent.com/vrsspace/VRSLib/v1.2.1/"
local ThemeManager = loadstring(game:HttpGet(repo .. "addons/ThemeManager.lua"))()
local SaveManager  = loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))()

-- Inisialisasi Save Manager di executor
SaveManager:SetLibrary(VRSLib)
SaveManager:SetFolder("VRS_Configs")
SaveManager:BuildConfigSection(TabSettings)
```

---

## 💻 Full Working Example

```lua
-- 1. Bersihkan instance sebelumnya
if _G.VRS_SCRIPT_UNLOAD then pcall(_G.VRS_SCRIPT_UNLOAD) end

-- 2. Load VRSLib dari CDN
local repo = "https://raw.githubusercontent.com/vrsspace/VRSLib/v1.2.1/"
local VRSLib = loadstring(game:HttpGet(repo .. "VRSLib.lua?v=" .. tick()))()

-- 3. Inisialisasi Window
local Window = VRSLib:CreateWindow({
    Title    = "VRS Artelier",
    SubTitle = "v1.2.1 Pro",
    Size     = UDim2.fromOffset(1020, 620),
    Accent   = Color3.fromRGB(255, 64, 140),
    Keybind  = Enum.KeyCode.RightControl
})

Window.OnUnload = function()
    print("[VRS Artelier] Script unloaded cleanly!")
end
_G.VRS_SCRIPT_UNLOAD = Window.OnUnload

-- 4. Tambah Kategori
Window:AddCategory("MAIN SYSTEMS", 10)

-- 5. Tambah Tab & SubTab
local TabCombat = Window:AddTabGroup({
    Name     = "Combat",
    Category = "MAIN SYSTEMS",
    Icon     = "swords"
})

local SubFarm = TabCombat:AddSubTab({
    Name = "Auto Farm",
    Icon = "activity"
})

-- 6. Tambah Modul Kartu
local FarmCard = SubFarm:AddModule({
    Title       = "Auto Attack Mobs",
    Description = "Strikes nearest enemies within selected radius",
    Icon        = "zap",
    Type        = "Toggle",
    Default     = false,
    Callback    = function(state)
        print("Auto Farm Active:", state)
    end
})

FarmCard:AddSlider({
    Name     = "Range",
    Min      = 10,
    Max      = 100,
    Default  = 30,
    Callback = function(val)
        print("Range:", val)
    end
})

-- 7. Split-Screen Tab
local SubConfig = TabCombat:AddSubTab({
    Name = "Settings",
    Icon = "sliders"
})
local LeftCol, RightCol = SubConfig:AddColumns()
local Box = LeftCol:AddGroupbox({ Title = "Target Filter", Icon = "shield" })
Box:AddToggle({
    Title    = "Ignore Bosses",
    Default  = false,
    Callback = function(v) print("Ignore Bosses:", v) end
})

print("[VRS Artelier] UI Ready! ✨")
```
