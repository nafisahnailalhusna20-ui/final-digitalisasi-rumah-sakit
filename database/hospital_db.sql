
CREATE TABLE poli (
    id SERIAL PRIMARY KEY,
    nama VARCHAR(100) NOT NULL UNIQUE,
    deskripsi TEXT NOT NULL,
    ikon TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(30) NOT NULL UNIQUE,
    email VARCHAR(120) NOT NULL UNIQUE,
    password_hash TEXT NOT NULL,
    role VARCHAR(10) NOT NULL CHECK (role IN ('admin', 'dokter', 'pasien')),
    full_name VARCHAR(120),
    phone VARCHAR(30),
    address TEXT,
    birth_date DATE,
    photo TEXT,
    poli_id INT REFERENCES poli(id) ON DELETE SET NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE schedules (
    id SERIAL PRIMARY KEY,
    dokter_id INT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    hari SMALLINT NOT NULL CHECK (hari BETWEEN 1 AND 7),
    jam_mulai TIME NOT NULL,
    UNIQUE (dokter_id, hari, jam_mulai)
);


CREATE TABLE medicines (
    id SERIAL PRIMARY KEY,
    nama VARCHAR(120) NOT NULL,
    deskripsi TEXT NOT NULL,
    tipe VARCHAR(10) NOT NULL CHECK (tipe IN ('keras', 'biasa')),
    stok INT NOT NULL DEFAULT 0 CHECK (stok >= 0),
    gambar TEXT,
    tanggal_kadaluarsa DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


CREATE TABLE appointments (
    id SERIAL PRIMARY KEY,
    pasien_id INT NOT NULL REFERENCES users(id),
    dokter_id INT NOT NULL REFERENCES users(id),
    schedule_id INT NOT NULL REFERENCES schedules(id),
    tanggal_booking DATE NOT NULL,
    keluhan TEXT NOT NULL,
    status VARCHAR(12) DEFAULT 'Pending'
        CHECK (status IN ('Pending', 'Approved', 'Rejected', 'Selesai', 'Dibatalkan')),
    alasan_penolakan TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


CREATE TABLE medical_records (
    id SERIAL PRIMARY KEY,
    appointment_id INT NOT NULL UNIQUE REFERENCES appointments(id),
    diagnosis TEXT NOT NULL,
    tindakan TEXT NOT NULL,
    catatan TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


CREATE TABLE prescriptions (
    id SERIAL PRIMARY KEY,
    medical_record_id INT NOT NULL UNIQUE REFERENCES medical_records(id),
    status VARCHAR(20) DEFAULT 'Menunggu Diproses'
        CHECK (status IN ('Menunggu Diproses', 'Siap Diambil', 'Sudah Diambil')),
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE prescription_items (
    id SERIAL PRIMARY KEY,
    prescription_id INT NOT NULL REFERENCES prescriptions(id),
    medicine_id INT NOT NULL REFERENCES medicines(id),
    jumlah INT NOT NULL CHECK (jumlah > 0)
);

CREATE TABLE feedbacks (
    id SERIAL PRIMARY KEY,
    appointment_id INT NOT NULL UNIQUE REFERENCES appointments(id),
    pasien_id INT NOT NULL REFERENCES users(id),
    dokter_id INT NOT NULL REFERENCES users(id),
    rating INT CHECK (rating BETWEEN 1 AND 5),
    komentar TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE notifications (
    id SERIAL PRIMARY KEY,
    user_id INT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    pesan TEXT NOT NULL,
    link TEXT,
    is_read BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);