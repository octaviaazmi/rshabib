<?php

namespace Tests\Feature;

use Illuminate\Foundation\Testing\DatabaseTransactions;
use Tests\TestCase;
use App\Models\User;
use Illuminate\Support\Facades\DB;

class RekamMedisTest extends TestCase
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

    private function getRekamMedis()
    {
        return DB::table('rekam_medis')->whereNull('deleted_at')->first();
    }

    // ==========================================
    // SKENARIO A: ROLE PERAWAT (UPDATE DATA UTAMA)
    // ==========================================

    public function test_perawat_berhasil_memperbarui_data_utama_rekam_medis()
    {
        $perawat = $this->getUserByRole('Perawat');
        $perawat->email_verified_at = now(); // BARIS SAKTI
        $perawat->save();

        $rm = $this->getRekamMedis();
        if(!$rm) { $this->markTestSkipped('Skip: Tidak ada data rekam medis di database.'); }

        $response = $this->actingAs($perawat)->put('/data/rekam-medis/' . $rm->idrekam_medis . '/update-data', [
            'anamnesa' => 'Hewan tampak lesu dan tidak mau makan',
            'temuan_klinis' => 'Suhu tubuh 39 derajat, dehidrasi ringan',
            'diagnosa' => 'Feline Panleukopenia (Suspect)',
            'idpet' => $rm->idpet,
            'dokter_pemeriksa' => $rm->dokter_pemeriksa,
        ]);

        $response->assertStatus(302);
        $response->assertSessionHas('success');
    }

    public function test_perawat_gagal_update_karena_field_wajib_kosong()
    {
        $perawat = $this->getUserByRole('Perawat');
        $perawat->email_verified_at = now(); // BARIS SAKTI
        $perawat->save();

        $rm = $this->getRekamMedis();
        if(!$rm) { $this->markTestSkipped('Skip: Tidak ada data rekam medis di database.'); }

        $response = $this->actingAs($perawat)->put('/data/rekam-medis/' . $rm->idrekam_medis . '/update-data', [
            'anamnesa' => '', 
            'temuan_klinis' => '', 
            'diagnosa' => '', 
            'idpet' => $rm->idpet,
            'dokter_pemeriksa' => $rm->dokter_pemeriksa,
        ]);

        $response->assertSessionHasErrors(['anamnesa', 'temuan_klinis', 'diagnosa']);
    }

    // ==========================================
    // SKENARIO B: ROLE DOKTER (AKSES TINDAKAN)
    // ==========================================

    public function test_dokter_ditolak_mengedit_detail_jika_bukan_pemeriksa_aslinya()
    {
        $dokter = $this->getUserByRole('Dokter');
        $dokter->email_verified_at = now(); // BARIS SAKTI
        $dokter->save();

        $rm = $this->getRekamMedis();
        if(!$rm) { $this->markTestSkipped('Skip: Tidak ada data rekam medis di database.'); }

        $dokterRoleUserId = DB::table('role_user')->where('iduser', $dokter->iduser)->value('idrole_user');
        $otherRoleUser = DB::table('role_user')->where('idrole_user', '!=', $dokterRoleUserId)->first();

        // Manipulasi RM agar seolah-olah diperiksa oleh orang lain
        DB::table('rekam_medis')->where('idrekam_medis', $rm->idrekam_medis)->update(['dokter_pemeriksa' => $otherRoleUser->idrole_user]);

        $response = $this->actingAs($dokter)->put('/data/rekam-medis/' . $rm->idrekam_medis . '/update-detail', [
            'detail_tindakan' => []
        ]);

        $response->assertStatus(302);
        $response->assertSessionHas('error'); 
    }

    // ==========================================
    // SKENARIO C: HAK AKSES OLEH MIDDLEWARE
    // ==========================================

    public function test_pemilik_ditolak_mengakses_halaman_edit_rekam_medis()
    {
        $pemilik = $this->getUserByRole('Pemilik');
        $pemilik->email_verified_at = now(); // BARIS SAKTI YANG LUPA DIMASUKKAN
        $pemilik->save();

        $rm = $this->getRekamMedis();
        if(!$rm) { $this->markTestSkipped('Skip: Tidak ada data rekam medis di database.'); }

        $response = $this->actingAs($pemilik)->get('/data/rekam-medis/' . $rm->idrekam_medis . '/edit-data');

        $response->assertStatus(302);
        $response->assertSessionHas('error');
    }

    public function test_pemilik_ditolak_menghapus_rekam_medis()
    {
        $pemilik = $this->getUserByRole('Pemilik');
        $pemilik->email_verified_at = now(); // BARIS SAKTI YANG LUPA DIMASUKKAN
        $pemilik->save();

        $rm = $this->getRekamMedis();
        if(!$rm) { $this->markTestSkipped('Skip: Tidak ada data rekam medis di database.'); }

        // Pastikan ejaan variabel $rm->idrekam_medis sudah benar ada "s"-nya
        $response = $this->actingAs($pemilik)->delete('/data/rekam-medis/' . $rm->idrekam_medis);

        $response->assertStatus(302);
        $response->assertSessionHas('error');
    }
}