import { Listing } from '../entities/listing.entity';
import { SearchListingsQuery } from '../../application/use-cases/search-listings/search-listings.query';

export const LISTING_REPOSITORY = Symbol('IListingRepository');

export interface IListingRepository {
  findAll(query: SearchListingsQuery): Promise<Listing[]>;
}
