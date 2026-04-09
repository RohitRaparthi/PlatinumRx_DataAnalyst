CREATE TABLE clinics (
    cid TEXT PRIMARY KEY,
    clinic_name TEXT,
    city TEXT,
    state TEXT,
    country TEXT
);

CREATE TABLE customer (
    uid TEXT PRIMARY KEY,
    name TEXT,
    mobile TEXT
);

CREATE TABLE clinic_sales (
    oid TEXT PRIMARY KEY,
    uid TEXT,
    cid TEXT,
    amount REAL,
    datetime DATETIME,
    sales_channel TEXT
);

CREATE TABLE expenses (
    eid TEXT PRIMARY KEY,
    cid TEXT,
    description TEXT,
    amount REAL,
    datetime DATETIME
);