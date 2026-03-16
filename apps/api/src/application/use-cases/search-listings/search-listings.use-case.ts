import { Injectable } from '@nestjs/common';
import { Listing } from '../../../domain/entities/listing.entity';
import { City } from '../../../domain/enums/city.enum';
import { SofaType } from '../../../domain/enums/sofa-type.enum';
import { DatabaseService } from '../../../infrastructure/database/database.service';
import { SearchListingsQuery } from './search-listings.query';

interface ListingRow {
  id: string;
  title: string;
  city: string;
  pricePerNightCents: number;
  sofaType: string;
  hasFreeWifi: number;
  createdAt: string;
  updatedAt: string;
}

@Injectable()
export class SearchListingsUseCase {
  constructor(private readonly db: DatabaseService) {}

  async execute(query: SearchListingsQuery): Promise<Listing[]> {
    const conditions: string[] = [];
    const params: (string | number)[] = [];

    if (query.city?.length) {
      conditions.push(`city IN (${query.city.map(() => '?').join(', ')})`);
      params.push(...query.city);
    }
    if (query.hasFreeWifi !== undefined) {
      conditions.push('hasFreeWifi = ?');
      params.push(query.hasFreeWifi ? 1 : 0);
    }
    if (query.sofaType !== undefined) {
      conditions.push('sofaType = ?');
      params.push(query.sofaType);
    }
    const where = conditions.length ? `WHERE ${conditions.join(' AND ')}` : '';
    const sql = `SELECT * FROM listings ${where} ORDER BY createdAt ASC`;
    const rows = this.db.database.prepare(sql).all(...params) as unknown as ListingRow[];

    return rows.map(row => new Listing(
      row.id,
      row.title,
      row.city as City,
      row.pricePerNightCents,
      row.sofaType as SofaType,
      Boolean(row.hasFreeWifi),
      new Date(row.createdAt),
      new Date(row.updatedAt),
    ));
  }
}
