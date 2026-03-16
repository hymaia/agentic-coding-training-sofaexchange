import { Injectable } from '@nestjs/common';
import { IListingRepository } from '../../domain/repositories/listing.repository.interface';
import { Listing }    from '../../domain/entities/listing.entity';
import { City }       from '../../domain/enums/city.enum';
import { SofaType }   from '../../domain/enums/sofa-type.enum';
import { SearchListingsQuery } from '../../application/use-cases/search-listings/search-listings.query';
import { DatabaseService }    from './database.service';

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
export class ListingSqliteRepository implements IListingRepository {
  constructor(private readonly db: DatabaseService) {}

  async findAll(query: SearchListingsQuery): Promise<Listing[]> {
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
    const sql   = `SELECT * FROM listings ${where} ORDER BY createdAt ASC`;

    const rows = this.db.database.prepare(sql).all(...params) as unknown as ListingRow[];

    return rows.map(r => new Listing(
      r.id,
      r.title,
      r.city as City,
      r.pricePerNightCents,
      r.sofaType as SofaType,
      Boolean(r.hasFreeWifi),
      new Date(r.createdAt),
      new Date(r.updatedAt),
    ));
  }
}
