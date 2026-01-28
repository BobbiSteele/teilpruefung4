CREATE TABLE produkte (
    produkt_id SERIAL PRIMARY KEY,
    produktname VARCHAR(200) NOT NULL,
    kategorie VARCHAR(100) NOT NULL,
    preis NUMERIC(10, 2) NOT NULL CHECK (preis > 0),
    bestand INTEGER NOT NULL DEFAULT 0 CHECK (bestand >= 0),
    sku VARCHAR(50) UNIQUE NOT NULL,
    erstellt_am TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    ist_verfuegbar BOOLEAN GENERATED ALWAYS AS (bestand > 0) STORED
);

CREATE TABLE kunden (
    kunden_id SERIAL PRIMARY KEY,
    vorname VARCHAR(100) NOT NULL,
    nachname VARCHAR(100) NOT NULL,
    email VARCHAR(200) UNIQUE NOT NULL,
    telefon VARCHAR(20),
    adresse TEXT,
    stadt VARCHAR(100),
    plz VARCHAR(10),
    land VARCHAR(100) DEFAULT 'Deutschland',
    registriert_am TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    vollstaendiger_name VARCHAR(201) GENERATED ALWAYS AS (vorname || ' ' || nachname) STORED,
    kundenstatus VARCHAR(20) DEFAULT 'Aktiv' CHECK (kundenstatus IN ('Aktiv', 'Inaktiv', 'VIP'))
);

CREATE TABLE mitarbeiter (
    mitarbeiter_id SERIAL PRIMARY KEY,
    vorname VARCHAR(100) NOT NULL,
    nachname VARCHAR(100) NOT NULL,
    email VARCHAR(200) UNIQUE NOT NULL,
    position VARCHAR(100) NOT NULL,
    abteilung VARCHAR(100) DEFAULT 'Verkauf',
    gehalt NUMERIC(10, 2) CHECK (gehalt > 0),
    einstellungsdatum DATE NOT NULL DEFAULT CURRENT_DATE,
    ist_aktiv BOOLEAN DEFAULT TRUE,
    dienstjahre INTEGER GENERATED ALWAYS AS (
        EXTRACT(YEAR FROM AGE(CURRENT_DATE, einstellungsdatum))
    ) STORED,
    provisionsrate NUMERIC(5, 2) DEFAULT 2.50 CHECK (provisionsrate >= 0 AND provisionsrate <= 100)
);

CREATE TABLE verkaeufe (
    verkauf_id SERIAL PRIMARY KEY,
    kunden_id INTEGER NOT NULL,
    mitarbeiter_id INTEGER NOT NULL,
    produkt_id INTEGER NOT NULL,
    menge INTEGER NOT NULL CHECK (menge > 0),
    einzelpreis NUMERIC(10, 2) NOT NULL CHECK (einzelpreis > 0),
    gesamtsumme NUMERIC(10, 2) GENERATED ALWAYS AS (menge * einzelpreis) STORED,
    verkaufsdatum TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    rabatt_prozent NUMERIC(5, 2) DEFAULT 0 CHECK (rabatt_prozent >= 0 AND rabatt_prozent <= 100),
    endbetrag NUMERIC(10, 2) GENERATED ALWAYS AS (
        (menge * einzelpreis) * (1 - rabatt_prozent / 100)
    ) STORED,
    zahlungsmethode VARCHAR(50) DEFAULT 'Kreditkarte' 
        CHECK (zahlungsmethode IN ('Kreditkarte', 'PayPal', 'Überweisung', 'Bar', 'Rechnung')),
    status VARCHAR(20) DEFAULT 'Abgeschlossen' 
        CHECK (status IN ('Abgeschlossen', 'Storniert', 'Ausstehend', 'Erstattet')),
    
    CONSTRAINT fk_kunde FOREIGN KEY (kunden_id) 
        REFERENCES kunden(kunden_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_mitarbeiter FOREIGN KEY (mitarbeiter_id) 
        REFERENCES mitarbeiter(mitarbeiter_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_produkt FOREIGN KEY (produkt_id) 
        REFERENCES produkte(produkt_id) ON DELETE RESTRICT ON UPDATE CASCADE
);