import { Inject, Injectable } from '@nestjs/common';
import { IListingRepository, LISTING_REPOSITORY } from '../../../domain/repositories/listing.repository.interface';
import { Listing } from '../../../domain/entities/listing.entity';
import { SearchListingsQuery } from './search-listings.query';

@Injectable()
export class SearchListingsUseCase {
  constructor(
    @Inject(LISTING_REPOSITORY)
    private readonly listingRepository: IListingRepository,
  ) {}

  execute(query: SearchListingsQuery): Promise<Listing[]> {
    return this.listingRepository.findAll(query);
  }
}
