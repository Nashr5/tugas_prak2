# NshStore - Aplikasi Penjualan Handphone 📱🌊
> **Tugas Praktikum 2 - Pemrograman Perangkat Bergerak (PPB)**

Aplikasi katalog dan penjualan smartphone berbasis **Flutter** yang mengonsumsi REST API dari [DummyJSON Products API](https://dummyjson.com/docs/products) dengan desain antarmuka modern bertema **Sea Color Combinations** yang segar, elegan, dan estetik.

---

## 📌 Identitas Mahasiswa & Link Pengumpulan

- **Nama**: Mohammad Nashrudin Mahardhika
- **NIM**: 240102058
- **Kelas / Mata Kuliah**: Pemrograman Perangkat Bergerak (PPB)
- **Link Video YouTube**: `https://youtu.be/jVbfj0OljNI`

---

## ✨ Fitur-Fitur Aplikasi

### 1. Halaman Depan (Katalog Handphone)
- **Desain Skema Warna Sea Color Combinations**: Menggunakan kombinasi warna laut dan samudra yang harmonis (Deep Ocean Teal `#166A86`, Deep Navy `#053549`, Seafoam Aqua `#63CBC4`, Vibrant Sea Blue `#2E88BC`, Sky Breeze `#8FC8E3`, dan Golden Sand `#FEC23E`).
- **Banner Promo Interaktif**: Menampilkan penawaran spesial gadget dengan sentuhan gradient warna laut yang estetik.
- **Filter Kategori Cepat**: Filter produk berdasarkan brand (Semua, Apple, Samsung, Vivo, Oppo, Realme, Diskon Spesial, dan Top Rated).
- **Toggle Tampilan**: Pilihan tampilan **Grid (2 kolom)** atau **List (1 kolom)** sesuai kenyamanan pengguna.
- **Card Produk Modern**: Menampilkan foto produk, badge brand, diskon persentase, rating bintang, harga coret, serta harga terkini.
- **Pull to Refresh**: Tarik ke bawah untuk memperbarui data produk langsung dari server API DummyJSON.

### 2. Tombol Search Fungsional 🔍
- **Pencarian Real-Time & Tombol "Cari"**: Pengguna dapat mencari smartphone melalui input text, menekan tombol `Cari`, maupun menekan tombol `Enter` pada keyboard.
- **API Search Terintegrasi**: Menggunakan endpoint `https://dummyjson.com/products/search?q={query}`.
- **Clear Button (`X`) & Reset State**: Tombol reset untuk menghapus pencarian dan mengembalikan katalog produk semula.
- **Empty State Handler**: Tampilan informatif jika kata kunci handphone tidak ditemukan.

### 3. Halaman Detail Produk 📱
- **Image Carousel & Gallery Thumbnails**: Menampilkan galeri foto produk dengan indikator titik animasi dan pemilih thumbnail yang dapat disentuh.
- **Informasi Lengkap**:
  - Judul handphone, badge brand resmi, dan status ketersediaan stok (`In Stock`).
  - Rating bintang serta jumlah ulasan pelanggan.
  - Komparasi harga ritel, harga diskon, dan nominal penghematan.
- **Pilihan Varian Warna Eksklusif**: Interaktif memilih varian warna smartphone (Ocean Teal, Seafoam Aqua, Deep Navy, Sky Breeze, Golden Sand).
- **Pilihan Kapasitas Memori (ROM)**: Pilihan memori 128 GB, 256 GB, 512 GB, dan 1 TB.
- **Spesifikasi Detail Handphone**: Menampilkan informasi brand resmi, garansi, estimasi pengiriman, kebijakan pengembalian produk, dimensi, bobot, dan minimum order.
- **Ulasan Pelanggan (Reviews)**: Menampilkan rating bintang, nama reviewer, tanggal, dan testimoni ulasan asli dari API DummyJSON.
- **Bottom Action Bar**: Tombol chat penjual, tombol tambah keranjang, dan tombol **Beli Sekarang** yang memunculkan Bottom Sheet konfirmasi pembelian.

---

## 🎨 Referensi Skema Warna (Sea Color Combinations)

Warna-warna yang diterapkan merujuk pada palet tema Sea Color Combinations:
- **Primary / Ocean Teal**: `#166A86` / Light `#E2F6F7`
- **Secondary / Wave Blue**: `#2E88BC` / Light `#E8F4FA`
- **Deepest Navy (Text / Accents)**: `#053549`
- **Seafoam Aqua / Mint**: `#63CBC4` / Light `#D6FFF7`
- **Beach Sand**: `#E4C3A2` / Light `#FAF3EC`
- **Sky Breeze**: `#8FC8E3` / Light `#EFF7FC`
- **Golden Sun / Amber**: `#FEC23E`
- **Background**: `#F4F9FA` (Fresh Coastal Breeze)
- **Surface**: `#FFFFFF`

---

## 🛠️ Struktur Proyek

```text
lib/
├── main.dart                      # Inisialisasi aplikasi, tema Material 3, & font Google
├── models/
│   └── product.dart               # Model data Product, Review, Dimensions, & JSON parser
├── services/
│   └── api_service.dart           # Layanan HTTP fetch, search, dan detail DummyJSON API
├── theme/
│   └── pastel_colors.dart         # Definisi palet warna pastel & gradasi estetik
├── screens/
│   ├── home_screen.dart           # Halaman utama katalog handphone & fungsionalitas search
│   └── product_detail_screen.dart # Halaman detail smartphone lengkap & checkout modal
└── widgets/
    ├── banner_slider.dart         # Widget banner promo pastel
    ├── category_chips.dart        # Widget filter chip kategori & brand handphone
    ├── product_card.dart          # Widget card item smartphone
    └── search_bar_widget.dart     # Widget input pencarian & tombol search fungsional
```

---

## 📱 Cara Menjalankan Aplikasi di Handphone (Android Device)

> **Catatan Sesuai Ketentuan**: Pengujian **wajib** menggunakan Handphone (dilarang menggunakan browser).

1. **Hubungkan Handphone ke Laptop/PC**:
   - Aktifkan **Developer Options (Opsi Pengembang)** dan **USB Debugging** pada handphone Android Anda.
   - Sambungkan menggunakan kabel data USB.

2. **Cek Koneksi Perangkat**:
   ```bash
   flutter devices
   ```

3. **Jalankan Aplikasi Langsung ke HP**:
   ```bash
   flutter run
   ```

4. **Atau Build File APK**:
   ```bash
   flutter build apk --release
   ```
   File APK hasil build akan berada di `build/app/outputs/flutter-apk/app-release.apk` dan dapat langsung diinstal ke handphone.
