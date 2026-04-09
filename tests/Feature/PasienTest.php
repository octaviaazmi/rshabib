<?php

namespace Tests\Feature;

use Illuminate\Foundation\Testing\DatabaseTransactions;
use Tests\TestCase;
use App\Models\User;

class PasienTest extends TestCase
{
    // Menggunakan DatabaseTransactions agar data testing tidak mengotori database asli
    use DatabaseTransactions; 

    // ==========================================
    // SKENARIO A: ROLE ADMIN
    // ==========================================

    // #PTA001: [Positif] Menyimpan data pasien valid
    public function test_admin_berhasil_menyimpan_data_pasien_valid()
    {
        $admin = User::where('email', 'admin@test.com')->first(); 
        $admin->email_verified_at = now(); 
        $admin->save(); 

        $response = $this->actingAs($admin)->post('/data/pet', [
            'nama' => 'Boli',
            'tanggal_lahir' => '2024-01-01',
            'jenis_kelamin' => 'M',
            'idpemilik' => 4, // GANTI JADI 4 BIAR SAMA KAYAK RESEPSIONIS
            'idras_hewan' => 2,
        ]);

        $response->assertStatus(302);
        $response->assertSessionHas('success');
    }

    // #PTA002: [Negatif] Field wajib kosong
    public function test_admin_gagal_menyimpan_karena_field_wajib_kosong()
    {
        $admin = User::where('email', 'admin@test.com')->first();

        // --- DUA BARIS SAKTI TAMBAHAN ---
        $admin->email_verified_at = now(); 
        $admin->save(); 
        // --------------------------------
        
        $response = $this->actingAs($admin)->post('/data/pet', [
            'nama' => '', 
            'tanggal_lahir' => '2024-01-01',
            'jenis_kelamin' => 'M',
            'idpemilik' => '', 
            'idras_hewan' => 2,
        ]);

        $response->assertSessionHasErrors(['nama', 'idpemilik']);
    }

    // #PTA003: [Bug] Validasi enum Jenis Kelamin tembus
    public function test_admin_tetap_bisa_simpan_jenis_kelamin_tidak_valid_bug()
    {
        $admin = User::where('email', 'admin@test.com')->first();
        $admin->email_verified_at = now(); 
        $admin->save(); 
        
        $response = $this->actingAs($admin)->post('/data/pet', [
            'nama' => 'Boli',
            'tanggal_lahir' => '2024-01-01',
            'jenis_kelamin' => 'Z', 
            'idpemilik' => 4, // GANTI JADI 4 JUGA
            'idras_hewan' => 2,
        ]);

        // GANTI BARIS PALING BAWAH INI:
        // Karena sistem berhasil menolak huruf 'Z', kita expect muncul error validasi
        $response->assertSessionHasErrors(['jenis_kelamin']);
    }

    // ==========================================
    // SKENARIO B: ROLE RESEPSIONIS
    // ==========================================

    // #PTR001: [Positif] Menyimpan data pasien baru
    public function test_resepsionis_berhasil_menyimpan_data_pasien()
    {
        $resepsionis = User::where('email', 'resepsionis@test.com')->first();
        
        $response = $this->actingAs($resepsionis)->post('/data/pet', [
            'nama' => 'Koko',
            'tanggal_lahir' => '2023-05-10',
            'jenis_kelamin' => 'M',
            'idpemilik' => 4,
            'idras_hewan' => 3,
        ]);

        $response->assertStatus(302);
        $response->assertSessionHas('success');
    }

    // #PTR002: [Negatif] ID Pemilik fiktif
    public function test_resepsionis_ditolak_karena_id_pemilik_fiktif()
    {
        $resepsionis = User::where('email', 'resepsionis@test.com')->first();
        
        $response = $this->actingAs($resepsionis)->post('/data/pet', [
            'nama' => 'Koko',
            'tanggal_lahir' => '2023-05-10',
            'jenis_kelamin' => 'M',
            'idpemilik' => 9999, // ID tidak ada di DB
            'idras_hewan' => 3,
        ]);

        $response->assertSessionHasErrors(['idpemilik']);
    }

    // #PTR003: [Bug] Tanggal lahir masa depan tembus
    public function test_resepsionis_tetap_bisa_simpan_tanggal_masa_depan_bug()
    {
        $resepsionis = User::where('email', 'resepsionis@test.com')->first();
        
        $response = $this->actingAs($resepsionis)->post('/data/pet', [
            'nama' => 'Koko',
            'tanggal_lahir' => '2050-12-12', // Masa depan
            'jenis_kelamin' => 'M',
            'idpemilik' => 4,
            'idras_hewan' => 3,
        ]);

        // Ekspektasi: Sistem menerima tanpa error validasi (Membuktikan temuan BUG)
        // GANTI BARIS INI:
        // Karena validasinya ternyata berfungsi (bukan bug), kita expect dia melempar error
        $response->assertSessionHasErrors(['tanggal_lahir']);
    }
}