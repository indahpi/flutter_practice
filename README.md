# Flutter JSONPlaceholder API App

Aplikasi mobile berbasis Flutter yang mnenggunakan public REST API dari [JSONPlaceholder](https://jsonplaceholder.typicode.com/) untuk proses pemanggilan API (HTTP Request), manajemen state, navigasi parameter dinamis, hingga operasi CRUD (Create, Read, Update, Delete).

## 📌 Riwayat Pengembangan & Fitur
### 1. Versi 1: Multi Menu (Post, Comment, & Album Foto)
Pada versi awal ini, aplikasi berfokus pada struktur modular multi-halaman dan navigasi dinamis:
**Menu Utama (Dashboard):** Menyediakan pilihan menu untuk mengakses *Daftar Post* dan *Daftar Album*.
**Daftar Post & Komentar Dinamis:** 
  - Menampilkan list postingan menggunakan `ListView.builder`.
  - Ketika salah satu post diklik (`onTap`), aplikasi bernavigasi ke halaman komentar (`CommentScreen`) dengan membawa parameter `postId`.
  - Komentar diambil secara dinamis dari endpoint `posts/{postId}/comments` dan ditampilkan menggunakan `Card` yang memuat informasi *Name*, *Email*, dan *Body*.
**Daftar Album & Galeri Foto:**
  - Menampilkan daftar album dari endpoint `/albums`.
  - Saat sebuah album diklik, aplikasi membuka halaman galeri foto (`PhotoScreen`) secara dinamis berdasarkan `albumId`, lengkap dengan informasi judul album dan grid foto (`GridView.builder`).
**Custom Font Arimo:** Menggunakan *Google Fonts Arimo* secara global pada tema aplikasi.

### 2. Versi 2: Fokus CRUD Post (Create, Read, Update, Delete)
Berdasarkan pembaruan terkini, fitur album dihilangkan dan aplikasi difokuskan penuh untuk melakukan operasi CRUD pada Post serta terintegrasi langsung dengan layar:
**Direct to Post Screen:** Saat aplikasi pertama kali di-*run*, langsung menampilkan halaman daftar seluruh postingan dengan judul AppBar **"Daftar Post"**.
**Tombol Refresh:** Ikon *refresh* di pojok kanan atas AppBar untuk menarik ulang data dari server dan me-reset perubahan lokal.
**Create (Tambah Post):** Terdapat tombol Floating Action Button (`+`) di kanan bawah untuk membuka halaman form input post baru (`CreatePostScreen`). Data yang berhasil dikirim akan langsung **muncul secara real-time di urutan teratas layar utama**.
**Update (Edit Post):** Setiap *Card* postingan dilengkapi tombol *Edit* yang mengarahkan ke `UpdatePostScreen`. Perubahan judul/konten akan langsung **terupdate secara nyata di layar**.
**Delete (Hapus Post):** Tombol *Delete* pada setiap post akan menghapus data dari layar seketika, disertai munculnya pop-up notifikasi **"Post telah terhapus"** dan log di konsol debug.
