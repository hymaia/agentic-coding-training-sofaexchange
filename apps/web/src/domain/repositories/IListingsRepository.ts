import { Listing, ListingFilters } from '../entities/Listing';

export interface IListingsRepository {
  search(filters: ListingFilters): Promise<Listing[]>;
}
