import { Listing, ListingFilters } from '../../domain/entities/Listing';
import { IListingsRepository } from '../../domain/repositories/IListingsRepository';

const BASE_URL = import.meta.env.VITE_API_BASE_URL ?? 'http://localhost:3000';

export class ConnectionError extends Error {
  constructor() {
    super('connection_error');
    this.name = 'ConnectionError';
  }
}

export class ListingsApiRepository implements IListingsRepository {
  async search(filters: ListingFilters): Promise<Listing[]> {
    const params = new URLSearchParams();

    for (const city of filters.city) {
      params.append('city', city);
    }

    if (filters.hasFreeWifi !== undefined) {
      params.set('hasFreeWifi', String(filters.hasFreeWifi));
    }

    if (filters.sofaType !== undefined) {
      params.set('sofaType', filters.sofaType);
    }

    const query = params.toString();
    const url = `${BASE_URL}/listings${query ? `?${query}` : ''}`;

    let response: Response;
    try {
      response = await fetch(url);
    } catch {
      throw new ConnectionError();
    }

    if (!response.ok) {
      throw new Error(`API error: ${response.status} ${response.statusText}`);
    }

    return response.json() as Promise<Listing[]>;
  }
}
