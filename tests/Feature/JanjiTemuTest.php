<?php

namespace Tests\Feature;

use Illuminate\Foundation\Testing\DatabaseTransactions;
use Tests\TestCase;
use App\Models\User;
use Illuminate\Support\Facades\DB; // <-- Ini tambahan biar bisa cari ID otomatis

class JanjiTemuTest extends TestCase
{
    use DatabaseTransactions;

    /**
     * Helper otomatis untuk mencari ID Role User milik DOKTER di database
     */
    private function getValidDokterId()
    {
        $dokter = DB::table('role_user')
            ->join('role', 'role_user.idrole', '=', 'role.idrole')
            ->where('role.nama_role', 'Dokter')
            ->where('role_user.status', 1)
            ->first();
            
        return $dokter ? $dokter->idrole_user : 1; 
    }

    // ==========================================
    // SKENARIO C: ROLE ADMIN
    // ==========================================

    // #JTA001: [Positif] Membuat janji temu manual
    public function test_admin_berhasil_membuat_janji_temu_manual()
    {
        $admin = User::where('email', 'admin@test.com')->first(); 
        $admin->email_verified_at = now(); 
        $admin->save(); 

        $response = $this->actingAs($admin)->post('/data/temu-dokter', [
            'idrole_user' => $this->getValidDokterId(), // <-- OTOMATIS CARI ID DOKTER
            'waktu_daftar' => '2026-03-25 09:00:00',
            'no_urut' => 1,
        ]);

        $response->assertStatus(302);
        $response->assertSessionHas('success');
    }

    // #JTA002: [Negatif] Mengosongkan field wajib
    public function test_admin_ditolak_karena_field_wajib_kosong()
    {
        $admin = User::where('email', 'admin@test.com')->first();
        $admin->email_verified_at = now(); 
        $admin->save(); 
        
        $response = $this->actingAs($admin)->post('/data/temu-dokter', [
            'idrole_user' => '', // Kosong
            'waktu_daftar' => '', // Kosong
            'no_urut' => 1,
        ]);

        $response->assertSessionHasErrors(['idrole_user', 'waktu_daftar']);
    }

    // #JTA003: [Bug] Crash karena salah tipe data (TERNYATA SUDAH FIX)
    public function test_admin_mengalami_fatal_error_saat_input_huruf_bug()
    {
        $admin = User::where('email', 'admin@test.com')->first();
        $admin->email_verified_at = now(); 
        $admin->save(); 
        
        $response = $this->actingAs($admin)->post('/data/temu-dokter', [
            'idrole_user' => $this->getValidDokterId(), // <-- OTOMATIS CARI ID DOKTER
            'waktu_daftar' => '2026-03-25 09:00:00',
            'no_urut' => 'ABC', 
        ]);

        // Karena sistem berhasil menahan huruf "ABC", kita expect error validasi
        $response->assertSessionHasErrors(['no_urut']);
    }

    // ==========================================
    // SKENARIO D: ROLE RESEPSIONIS
    // ==========================================

    // #JTR001: [Positif] Membuat janji otomatis
    public function test_resepsionis_berhasil_membuat_janji_temu_otomatis()
    {
        $resepsionis = User::where('email', 'resepsionis@test.com')->first(); 
        $resepsionis->email_verified_at = now(); 
        $resepsionis->save(); 
        
        $response = $this->actingAs($resepsionis)->post('/data/temu-dokter', [
            'idrole_user' => $this->getValidDokterId(), // <-- OTOMATIS CARI ID DOKTER
            'waktu_daftar' => '2026-03-25 10:00:00',
            'no_urut' => null, 
        ]);

        $response->assertStatus(302);
        $response->assertSessionHas('success');
    }

    // #JTR002: [Negatif] Format waktu salah
    public function test_resepsionis_ditolak_karena_format_waktu_salah()
    {
        $resepsionis = User::where('email', 'resepsionis@test.com')->first();
        $resepsionis->email_verified_at = now(); 
        $resepsionis->save(); 
        
        $response = $this->actingAs($resepsionis)->post('/data/temu-dokter', [
            'idrole_user' => $this->getValidDokterId(), // <-- OTOMATIS CARI ID DOKTER
            'waktu_daftar' => 'Kemarin Sore', 
            'no_urut' => null,
        ]);

        $response->assertSessionHasErrors(['waktu_daftar']);
    }

    // #JTR003: [Bug] Bisa mendaftar di tanggal libur
    public function test_resepsionis_tetap_bisa_membuat_janji_di_hari_libur_bug()
    {
        $resepsionis = User::where('email', 'resepsionis@test.com')->first();
        $resepsionis->email_verified_at = now(); 
        $resepsionis->save(); 
        
        $response = $this->actingAs($resepsionis)->post('/data/temu-dokter', [
            'idrole_user' => $this->getValidDokterId(), // <-- OTOMATIS CARI ID DOKTER
            'waktu_daftar' => '2026-12-25 10:00:00', 
            'no_urut' => null,
        ]);

        $response->assertSessionHasNoErrors();
    }
}