# 🌸 VRS Artelier UI Library (Obsidian Architecture)

Proprietary, modular Roblox Luau UI Library engineered for **VRS Artelier**, featuring the 404hub desktop card-grid interface, dynamic 3–6 column reflow, free corner drag-resizing, and a clean Obsidian-style modular architecture.

📖 **[Baca Dokumentasi Lengkap & Panduan Developer Disini (DOCUMENTATION.md)](./DOCUMENTATION.md)**

---

## 📂 Struktur Repositori (Obsidian Standard)

```
[ UI LIB DATA ]/
├── VRSLib.lua                    # Master Engine Entrypoint (Bundle & Loader)
├── Example.lua                   # Showcase Script (Lengkap 47 Modules)
├── README.md                     # Dokumentasi & Panduan
├── src/                          # Core Modular Source
│   ├── Icons.lua                 # Engine 818+ Verified Lucide Icons + Smart Resolver
│   ├── Theme.lua                 # Design Tokens & VRS Neon Magenta Pink (#FF408C)
│   ├── Utils.lua                 # Safe Containers, Dragging, Tweens, Brand Logo Loader
│   └── Components/               # Dedicated UI Elements
│       ├── Window.lua            # Window frame, header, controls, resize logic
│       ├── Sidebar.lua           # Quick filters, custom categories, user profile
│       ├── ModuleCard.lua        # Compact 78px cards, pill toggles, action buttons
│       └── Notifications.lua     # Floating toast notifications
└── addons/                       # Obsidian-style Addons
    ├── ThemeManager.lua          # Runtime theme switcher & accent customization
    └── SaveManager.lua           # Config manager & JSON settings persistence
```

---

## ✨ Fitur Unggulan

1. **800+ Verified Lucide Icons**:
   - Dilengkapi fungsi `Icons.Get(name)` dengan auto-fallback.
   - Tidak ada lagi icon yang hilang/blank atau moderasi Roblox.
2. **Signature Branding VRS Artelier**:
   - Official Wings Logo di kiri atas via FiveManage CDN & Spritesheet fallback.
   - 100% Signature Neon Magenta Pink (`#FF408C`).
3. **Free Drag-Resizing**:
   - Tarik pojok kanan-bawah (`⤡`) atau border kanan/bawah untuk memperbesar window secara bebas.
   - Grid kartu otomatis reflow dari 3 hingga 6 kolom secara dinamis.
4. **Tombol Close [X] Permanen**:
   - Tombol `[X]` di pojok kanan atas selalu mengeksekusi `Window:Unload()` untuk membersihkan GUI, disconnect listener, dan reset state.
5. **Addons System**:
   - `addons/ThemeManager.lua`: Penggantian tema dan warna aksen secara live.
   - `addons/SaveManager.lua`: Penyimpanan & pemuatan konfigurasi otomatis ke disk executor.

---

## 🚀 Cara Menjalankan

### Melalui Executor (Raw GitHub)
```lua
local repo = "https://raw.githubusercontent.com/vrsspace/VRSLib/main/"
local VRSLib = loadstring(game:HttpGet(repo .. "VRSLib.lua?v=" .. tick()))()
local ThemeManager = loadstring(game:HttpGet(repo .. "addons/ThemeManager.lua"))()
local SaveManager = loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))()

local Window = VRSLib:CreateWindow({
    Title    = "VRS Artelier",
    SubTitle = "v1.2.3 Pro",
    Size     = UDim2.fromOffset(1020, 620),
    Accent   = Color3.fromRGB(255, 64, 140),
})
```

### Menjalankan Showcase Lengkap (47 Modules)
Tinggal eksekusi 1 baris ini di executor Anda:
```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/vrsspace/VRSLib/v1.2.3/Example.lua"))()
```
