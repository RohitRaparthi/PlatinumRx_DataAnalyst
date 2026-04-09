CREATE TABLE users (
    user_id TEXT PRIMARY KEY,
    name TEXT,
    phone_number TEXT,
    mail_id TEXT,
    billing_address TEXT
);

CREATE TABLE bookings (
    booking_id TEXT PRIMARY KEY,
    booking_date DATETIME,
    room_no TEXT,
    user_id TEXT
);

CREATE TABLE items (
    item_id TEXT PRIMARY KEY,
    item_name TEXT,
    item_rate REAL
);

CREATE TABLE booking_commercials (
    id TEXT PRIMARY KEY,
    booking_id TEXT,
    bill_id TEXT,
    bill_date DATETIME,
    item_id TEXT,
    item_quantity REAL
);