<?php

namespace Tests\Integration;

use Tests\TestCase;
use App\Models\User;
use App\Models\Pet;
use App\Models\Pemilik;
use App\Models\TemuDokter;
use App\Models\RekamMedis;
use App\Models\Role;
use App\Http\Controllers\Admin\TemuDokterController;
use Illuminate\Foundation\Testing\DatabaseTransactions;
use Illuminate\Support\Facades\DB;

class JanjiTemuRekamMedisTest extends TestCase
{
    use DatabaseTransactions;

    private $admin;
    private $dokter;
    private $pet;
    private $dokterRoleUser;

    /**
     * SETUP: Mengisi data awal
     */
    protected function setUp(): void
    {
        parent::setUp();

        // 1. AMBIL Role yang sudah ada di database (JANGAN CREATE BARU)
        $adminRole = Role::where('nama_role', 'Administrator')->first();
        $dokterRole = Role::where('nama_role', 'Dokter')->first();

        // Pastikan role ada, jika tidak ada, skip test-nya daripada error
        if (!$adminRole || !$dokterRole) {
            $this->markTestSkipped('Skip: Master Role Administrator/Dokter belum ada di database.');
        }

        // 2. Buat User Admin & Dokter Dummy untuk Testing
        $this->admin = User::factory()->create([
            'nama' => 'Admin Test',
            'email' => 'admin_test_unik' . time() . '@test.com', // Hindari duplicate email
        ]);
        $this->admin->roles()->attach($adminRole->idrole, ['status' => 1]);

        $this->dokter = User::factory()->create([
            'nama' => 'Dokter Test',
            'email' => 'dokter_test_unik' . time() . '@test.com', // Hindari duplicate email
        ]);
        $this->dokter->roles()->attach($dokterRole->idrole, ['status' => 1]);
        
        // Ambil idrole_user untuk keperluan foreign key di temu_dokter
        $this->dokterRoleUser = DB::table('role_user')
            ->where('iduser', $this->dokter->iduser)
            ->where('idrole', $dokterRole->idrole)
            ->first();

        // 3. Buat Pemilik (Aman dari duplicate entry)
        $nextIdPemilik = (DB::table('pemilik')->max('idpemilik') ?? 0) + 1;

        DB::table('pemilik')->insert([
            'idpemilik' => $nextIdPemilik,
            'iduser' => $this->admin->iduser,
            'no_wa' => '08123456789',
            'alamat' => 'Surabaya'
        ]);

        $pemilik = Pemilik::where('idpemilik', $nextIdPemilik)->first();

        // 4. Ambil/Buat Master Data Hewan
        // Kita gunakan firstOrCreate agar tidak crash jika data ras 1 sudah ada di DB asli
        DB::table('jenis_hewan')->insertOrIgnore(['idjenis_hewan' => 1, 'nama_jenis_hewan' => 'Kucing']);
        DB::table('ras_hewan')->insertOrIgnore(['idras_hewan' => 1, 'nama_ras' => 'Persia', 'idjenis_hewan' => 1]);

        $this->pet = Pet::create([
            'nama' => 'Buddy',
            'idpemilik' => $pemilik->idpemilik,
            'idras_hewan' => 1,
            'jenis_kelamin' => 'L'
        ]);

        // 5. Ambil Kode Tindakan yang sudah ada di database (Jangan insert manual id 1)
        $kodeTindakan = DB::table('kode_tindakan_terapi')->first();
        if (!$kodeTindakan) {
            $this->markTestSkipped('Skip: Tidak ada master data kode_tindakan_terapi di database.');
        }
        
        // Simpan id kode tindakan ke property class agar bisa dipanggil di step 2 fungsi test
        $this->idTindakan = $kodeTindakan->idkode_tindakan_terapi;
    }

    /**
     * TEST: Alur Create Temu Dokter sampai Rekam Medis
     */
    public function test_alur_top_down_janji_temu_sampai_rekam_medis()
    {
        // --- STEP 1: Create Temu Dokter ---
        $appointmentData = [
            'idrole_user' => $this->dokterRoleUser->idrole_user,
            'waktu_daftar' => now()->format('Y-m-d H:i:s'),
            'no_urut' => 1
        ];

        $response1 = $this->actingAs($this->admin)
            ->post(route('data.temu-dokter.store'), $appointmentData);

        $response1->assertStatus(302); 
        $this->assertDatabaseHas('temu_dokter', ['no_urut' => 1]);

        $appointment = TemuDokter::latest('idreservasi_dokter')->first();

        // --- STEP 2: Create Rekam Medis (Integrasi) --- 
        $rekamMedisData = [
            'idpet' => $this->pet->idpet,
            'anamnesa' => 'Kucing lemas tidak mau makan',
            'temuan_klinis' => 'Suhu 39C',
            'diagnosa' => 'Flu Ringan',
            'detail_tindakan' => [
                [
                    'idkode_tindakan_terapi' => $this->idTindakan,
                    'detail' => 'Pemberian vitamin'
                ]
            ]
        ];

        $response2 = $this->actingAs($this->admin)
            ->postJson(route('data.temu-dokter.store-rekam-medis', ['id' => $appointment->idreservasi_dokter]), $rekamMedisData);

        // --- STEP 3: Verifikasi Hasil ---
        $response2->assertStatus(200);
        $response2->assertJson(['success' => true]);

        // Cek apakah data tersimpan di tabel rekam_medis
        $this->assertDatabaseHas('rekam_medis', [
            'idreservasi_dokter' => $appointment->idreservasi_dokter,
            'idpet' => $this->pet->idpet,
            'diagnosa' => 'Flu Ringan'
        ]);

        // Cek Detail Tindakan
        $this->assertDatabaseHas('detail_rekam_medis', [
            'detail' => 'Pemberian vitamin'
        ]);
    }
}