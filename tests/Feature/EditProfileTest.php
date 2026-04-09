<?php

namespace Tests\Feature;

use Illuminate\Foundation\Testing\DatabaseTransactions;
use Tests\TestCase;
use App\Models\User;
use Illuminate\Support\Facades\DB;

class EditProfileTest extends TestCase
{
    use DatabaseTransactions;

    private function getUserByRole($roleName)
    {
        $roleUser = DB::table('role_user')
            ->join('role', 'role_user.idrole', '=', 'role.idrole')
            ->where('role.nama_role', $roleName)
            ->first();

        return $roleUser ? User::where('iduser', $roleUser->iduser)->first() : User::first(); 
    }

    // ==========================================
    // SKENARIO A: ROLE ADMIN
    // ==========================================

    public function test_admin_berhasil_update_data_user()
    {
        $admin = $this->getUserByRole('Administrator'); 
        $admin->email_verified_at = now();
        $admin->save();

        $targetUser = User::where('iduser', '!=', $admin->iduser)->first();

        $response = $this->actingAs($admin)->put('/data/users/' . $targetUser->iduser, [
            'nama' => 'Nama Baru Update',
            'email' => 'email.baru.aman@test.com',
            'idrole' => 2, 
        ]);

        $response->assertStatus(302);
        $response->assertSessionHasNoErrors();
    }

    public function test_admin_gagal_update_karena_email_duplikat()
    {
        $admin = $this->getUserByRole('Administrator');
        $admin->email_verified_at = now();
        $admin->save();

        $targetUser = User::where('iduser', '!=', $admin->iduser)->first();

        $response = $this->actingAs($admin)->put('/data/users/' . $targetUser->iduser, [
            'nama' => 'Nama Baru Update',
            'email' => $admin->email, // Email yang sama dengan admin
            'idrole' => 2,
        ]);

        $response->assertSessionHasErrors(['email']);
    }

    // ==========================================
    // SKENARIO B: ROLE DOKTER (5 Test Case)
    // ==========================================

    public function test_dokter_berhasil_memperbarui_data_profil()
    {
        $dokter = $this->getUserByRole('Dokter');
        $dokter->email_verified_at = now();
        $dokter->save();

        $response = $this->actingAs($dokter)->put('/profile/dokter', [
            'jenis_kelamin' => 'M', 
            'no_hp' => '081234567890', 
            'alamat' => 'Jl. Sehat Selalu No 1',
            'bidang_dokter' => 'Spesialis Bedah', 
        ]);

        $response->assertStatus(302);
    }

    public function test_dokter_tetap_bisa_simpan_no_telp_huruf_bug()
    {
        $dokter = $this->getUserByRole('Dokter');
        $dokter->email_verified_at = now();
        $dokter->save();

        $response = $this->actingAs($dokter)->put('/profile/dokter', [
            'jenis_kelamin' => 'M',
            'no_hp' => 'abcdefg', // BUG: Tembus karena tipe string
            'alamat' => 'Jl. Sehat Selalu No 1',
            'bidang_dokter' => 'Spesialis Bedah',
        ]);

        $response->assertSessionHasNoErrors();
    }

    public function test_dokter_gagal_update_karena_no_hp_kosong()
    {
        $dokter = $this->getUserByRole('Dokter');
        $dokter->email_verified_at = now();
        $dokter->save();

        $response = $this->actingAs($dokter)->put('/profile/dokter', [
            'jenis_kelamin' => 'M',
            'no_hp' => '', // KOSONG
            'alamat' => 'Jl. Sehat Selalu No 1',
            'bidang_dokter' => 'Spesialis Bedah',
        ]);

        $response->assertSessionHasErrors(['no_hp']);
    }

    public function test_dokter_gagal_update_karena_alamat_kosong()
    {
        $dokter = $this->getUserByRole('Dokter');
        $dokter->email_verified_at = now();
        $dokter->save();

        $response = $this->actingAs($dokter)->put('/profile/dokter', [
            'jenis_kelamin' => 'M',
            'no_hp' => '081234567890',
            'alamat' => '', // KOSONG
            'bidang_dokter' => 'Spesialis Bedah',
        ]);

        $response->assertSessionHasErrors(['alamat']);
    }

    public function test_dokter_gagal_update_karena_jenis_kelamin_salah()
    {
        $dokter = $this->getUserByRole('Dokter');
        $dokter->email_verified_at = now();
        $dokter->save();

        $response = $this->actingAs($dokter)->put('/profile/dokter', [
            'jenis_kelamin' => 'Z', // Harus M/F
            'no_hp' => '081234567890',
            'alamat' => 'Jl. Jalan', 
            'bidang_dokter' => 'Spesialis Bedah',
        ]);

        $response->assertSessionHasErrors(['jenis_kelamin']);
    }

    // ==========================================
    // SKENARIO C: ROLE PERAWAT (5 Test Case)
    // ==========================================

    public function test_perawat_berhasil_memperbarui_data_profil()
    {
        $perawat = $this->getUserByRole('Perawat');
        $perawat->email_verified_at = now();
        $perawat->save();

        $response = $this->actingAs($perawat)->put('/profile/perawat', [
            'jenis_kelamin' => 'F', 
            'no_hp' => '081234567890', 
            'alamat' => 'Jl. Rawat Inap No 2',
            'pendidikan' => 'S1 Keperawatan', 
        ]);

        $response->assertStatus(302);
    }

    public function test_perawat_tetap_bisa_simpan_no_telp_huruf_bug()
    {
        $perawat = $this->getUserByRole('Perawat');
        $perawat->email_verified_at = now();
        $perawat->save();

        $response = $this->actingAs($perawat)->put('/profile/perawat', [
            'jenis_kelamin' => 'F', 
            'no_hp' => 'bukanangka', // BUG
            'alamat' => 'Jl. Rawat Inap No 2',
            'pendidikan' => 'S1 Keperawatan', 
        ]);

        $response->assertSessionHasNoErrors();
    }

    public function test_perawat_gagal_update_karena_no_hp_kosong()
    {
        $perawat = $this->getUserByRole('Perawat');
        $perawat->email_verified_at = now();
        $perawat->save();

        $response = $this->actingAs($perawat)->put('/profile/perawat', [
            'jenis_kelamin' => 'F',
            'no_hp' => '', // KOSONG
            'alamat' => 'Jl. Rawat Inap No 2',
            'pendidikan' => 'S1 Keperawatan',
        ]);

        $response->assertSessionHasErrors(['no_hp']);
    }

    public function test_perawat_gagal_update_karena_alamat_kosong()
    {
        $perawat = $this->getUserByRole('Perawat');
        $perawat->email_verified_at = now();
        $perawat->save();

        $response = $this->actingAs($perawat)->put('/profile/perawat', [
            'jenis_kelamin' => 'F',
            'no_hp' => '081234567890',
            'alamat' => '', // KOSONG
            'pendidikan' => 'S1 Keperawatan',
        ]);

        $response->assertSessionHasErrors(['alamat']);
    }

    public function test_perawat_gagal_update_karena_jenis_kelamin_salah()
    {
        $perawat = $this->getUserByRole('Perawat');
        $perawat->email_verified_at = now();
        $perawat->save();

        $response = $this->actingAs($perawat)->put('/profile/perawat', [
            'jenis_kelamin' => 'Z', 
            'no_hp' => '081234567890',
            'alamat' => 'Jl. Rawat Inap No 2',
            'pendidikan' => 'S1 Keperawatan',
        ]);

        $response->assertSessionHasErrors(['jenis_kelamin']);
    }

    // ==========================================
    // SKENARIO D: ROLE PEMILIK (5 Test Case)
    // ==========================================

    public function test_pemilik_berhasil_memperbarui_data_profil()
    {
        $pemilik = $this->getUserByRole('Pemilik');
        $pemilik->email_verified_at = now();
        $pemilik->save();

        $response = $this->actingAs($pemilik)->put('/profile/pemilik', [
            'jenis_kelamin' => 'M', 
            'no_wa' => '081234567890', 
            'alamat' => 'Jl. Sayang Hewan No 3',
        ]);

        $response->assertStatus(302);
    }

    public function test_pemilik_tetap_bisa_simpan_no_telp_huruf_bug()
    {
        $pemilik = $this->getUserByRole('Pemilik');
        $pemilik->email_verified_at = now();
        $pemilik->save();

        $response = $this->actingAs($pemilik)->put('/profile/pemilik', [
            'jenis_kelamin' => 'M', 
            'no_wa' => 'huruflagi', // BUG
            'alamat' => 'Jl. Sayang Hewan No 3',
        ]);

        $response->assertSessionHasNoErrors();
    }

    public function test_pemilik_gagal_update_karena_no_wa_kosong()
    {
        $pemilik = $this->getUserByRole('Pemilik');
        $pemilik->email_verified_at = now();
        $pemilik->save();

        $response = $this->actingAs($pemilik)->put('/profile/pemilik', [
            'jenis_kelamin' => 'M',
            'no_wa' => '', // KOSONG
            'alamat' => 'Jl. Sayang Hewan No 3',
        ]);

        $response->assertSessionHasErrors(['no_wa']);
    }

    public function test_pemilik_gagal_update_karena_alamat_kosong()
    {
        $pemilik = $this->getUserByRole('Pemilik');
        $pemilik->email_verified_at = now();
        $pemilik->save();

        $response = $this->actingAs($pemilik)->put('/profile/pemilik', [
            'jenis_kelamin' => 'M',
            'no_wa' => '081234567890',
            'alamat' => '', // KOSONG
        ]);

        $response->assertSessionHasErrors(['alamat']);
    }

    public function test_pemilik_gagal_update_karena_no_wa_kepanjangan()
    {
        $pemilik = $this->getUserByRole('Pemilik');
        $pemilik->email_verified_at = now();
        $pemilik->save();

        $response = $this->actingAs($pemilik)->put('/profile/pemilik', [
            // Sengaja dibuat lebih dari 45 karakter biar ditolak sistem
            'no_wa' => '0812345678901234567890123456789012345678901234567890',
            'alamat' => 'Jl. Sayang Hewan No 3',
        ]);

        $response->assertSessionHasErrors(['no_wa']);
    }
}