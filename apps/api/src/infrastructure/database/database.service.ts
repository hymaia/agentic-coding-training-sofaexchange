import { Injectable, OnModuleInit, OnModuleDestroy } from '@nestjs/common';
import { DatabaseSync } from 'node:sqlite';
import { randomUUID } from 'crypto';

const SEED_LISTINGS = [
  // LONDON — 5 listings
  { title: "Comfy sofa bed near Tower Bridge",  city: "LONDON",    pricePerNightCents: 4500,  sofaType: "SOFA_BED",    hasFreeWifi: 1 },
  { title: "Simple sofa in Shoreditch flat",    city: "LONDON",    pricePerNightCents: 2800,  sofaType: "SIMPLE_SOFA", hasFreeWifi: 1 },
  { title: "Quiet sofa near Hyde Park",         city: "LONDON",    pricePerNightCents: 6000,  sofaType: "SOFA_BED",    hasFreeWifi: 0 },
  { title: "Budget sofa in East London",        city: "LONDON",    pricePerNightCents: 1500,  sofaType: "SIMPLE_SOFA", hasFreeWifi: 0 },
  { title: "Luxury sofa bed, Kensington",       city: "LONDON",    pricePerNightCents: 15000, sofaType: "SOFA_BED",    hasFreeWifi: 1 },
  // PARIS — 3 listings
  { title: "Sofa in Marais apartment",          city: "PARIS",     pricePerNightCents: 5500,  sofaType: "SOFA_BED",    hasFreeWifi: 1 },
  { title: "Simple sofa near Eiffel Tower",     city: "PARIS",     pricePerNightCents: 7000,  sofaType: "SIMPLE_SOFA", hasFreeWifi: 1 },
  { title: "Budget sofa, Belleville",           city: "PARIS",     pricePerNightCents: 2000,  sofaType: "SIMPLE_SOFA", hasFreeWifi: 0 },
  // MILAN — 3 listings
  { title: "Sofa bed in Navigli loft",          city: "MILAN",     pricePerNightCents: 4800,  sofaType: "SOFA_BED",    hasFreeWifi: 1 },
  { title: "Simple sofa, Brera district",       city: "MILAN",     pricePerNightCents: 3200,  sofaType: "SIMPLE_SOFA", hasFreeWifi: 1 },
  { title: "Budget sofa near Duomo",            city: "MILAN",     pricePerNightCents: 2100,  sofaType: "SIMPLE_SOFA", hasFreeWifi: 0 },
  // MADRID — 3 listings
  { title: "Cosy sofa near Retiro Park",        city: "MADRID",    pricePerNightCents: 3900,  sofaType: "SOFA_BED",    hasFreeWifi: 1 },
  { title: "Simple sofa, Malasaña",             city: "MADRID",    pricePerNightCents: 2500,  sofaType: "SIMPLE_SOFA", hasFreeWifi: 0 },
  { title: "Sofa bed near Gran Via",            city: "MADRID",    pricePerNightCents: 5200,  sofaType: "SOFA_BED",    hasFreeWifi: 1 },
  // LISBON — 3 listings
  { title: "Sofa bed in Alfama",                city: "LISBON",    pricePerNightCents: 3500,  sofaType: "SOFA_BED",    hasFreeWifi: 1 },
  { title: "Simple sofa, Bairro Alto",          city: "LISBON",    pricePerNightCents: 2200,  sofaType: "SIMPLE_SOFA", hasFreeWifi: 1 },
  { title: "Budget sofa near LX Factory",       city: "LISBON",    pricePerNightCents: 1800,  sofaType: "SIMPLE_SOFA", hasFreeWifi: 0 },
  // BERLIN — 3 listings
  { title: "Sofa bed in Mitte",                 city: "BERLIN",    pricePerNightCents: 3000,  sofaType: "SOFA_BED",    hasFreeWifi: 1 },
  { title: "Simple sofa, Prenzlauer Berg",      city: "BERLIN",    pricePerNightCents: 1800,  sofaType: "SIMPLE_SOFA", hasFreeWifi: 0 },
  { title: "Sofa in Kreuzberg studio",          city: "BERLIN",    pricePerNightCents: 2400,  sofaType: "SOFA_BED",    hasFreeWifi: 1 },
  // DUBLIN — 3 listings
  { title: "Sofa bed near St Stephen's Green",  city: "DUBLIN",    pricePerNightCents: 5000,  sofaType: "SOFA_BED",    hasFreeWifi: 1 },
  { title: "Simple sofa in Temple Bar",         city: "DUBLIN",    pricePerNightCents: 3300,  sofaType: "SIMPLE_SOFA", hasFreeWifi: 1 },
  { title: "Budget sofa, Docklands",            city: "DUBLIN",    pricePerNightCents: 2000,  sofaType: "SIMPLE_SOFA", hasFreeWifi: 0 },
  // EDINBURGH — 3 listings
  { title: "Sofa bed in Old Town",              city: "EDINBURGH", pricePerNightCents: 4200,  sofaType: "SOFA_BED",    hasFreeWifi: 1 },
  { title: "Simple sofa, Leith",               city: "EDINBURGH", pricePerNightCents: 2600,  sofaType: "SIMPLE_SOFA", hasFreeWifi: 0 },
  { title: "Sofa near Edinburgh Castle",        city: "EDINBURGH", pricePerNightCents: 5500,  sofaType: "SOFA_BED",    hasFreeWifi: 1 },
  // VIENNA — 3 listings
  { title: "Sofa bed near Belvedere",           city: "VIENNA",    pricePerNightCents: 4600,  sofaType: "SOFA_BED",    hasFreeWifi: 1 },
  { title: "Simple sofa, Naschmarkt area",      city: "VIENNA",    pricePerNightCents: 2900,  sofaType: "SIMPLE_SOFA", hasFreeWifi: 1 },
  { title: "Budget sofa in Leopoldstadt",       city: "VIENNA",    pricePerNightCents: 1900,  sofaType: "SIMPLE_SOFA", hasFreeWifi: 0 },
];

@Injectable()
export class DatabaseService implements OnModuleInit, OnModuleDestroy {
  private db: DatabaseSync;

  onModuleInit() {
    const dbPath = process.env.DB_PATH ?? './dev.db';
    this.db = new DatabaseSync(dbPath);
    this.db.exec('PRAGMA journal_mode = WAL');
    this.db.exec(`
      CREATE TABLE IF NOT EXISTS listings (
        id                 TEXT    PRIMARY KEY,
        title              TEXT    NOT NULL,
        city               TEXT    NOT NULL,
        pricePerNightCents INTEGER NOT NULL,
        sofaType           TEXT    NOT NULL,
        hasFreeWifi        INTEGER NOT NULL DEFAULT 0,
        createdAt          TEXT    NOT NULL,
        updatedAt          TEXT    NOT NULL
      );
      CREATE INDEX IF NOT EXISTS idx_listings_city         ON listings(city);
      CREATE INDEX IF NOT EXISTS idx_listings_price        ON listings(pricePerNightCents);
      CREATE INDEX IF NOT EXISTS idx_listings_sofaType     ON listings(sofaType);
      CREATE INDEX IF NOT EXISTS idx_listings_hasFreeWifi  ON listings(hasFreeWifi);
    `);
    this.seedIfEmpty();
  }

  onModuleDestroy() {
    this.db.close();
  }

  get database(): DatabaseSync {
    return this.db;
  }

  private seedIfEmpty() {
    const row = this.db.prepare('SELECT COUNT(*) as count FROM listings').get() as unknown as { count: number };
    if (row.count > 0) return;

    const insert = this.db.prepare(`
      INSERT INTO listings (id, title, city, pricePerNightCents, sofaType, hasFreeWifi, createdAt, updatedAt)
      VALUES (@id, @title, @city, @pricePerNightCents, @sofaType, @hasFreeWifi, @createdAt, @updatedAt)
    `);
    const now = new Date().toISOString();
    this.db.exec('BEGIN');
    for (const listing of SEED_LISTINGS) {
      insert.run({ ...listing, id: randomUUID(), createdAt: now, updatedAt: now });
    }
    this.db.exec('COMMIT');
  }
}
