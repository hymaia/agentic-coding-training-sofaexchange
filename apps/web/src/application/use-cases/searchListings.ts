import { Listing, ListingFilters } from '../../domain/entities/Listing';
import { IListingsRepository } from '../../domain/repositories/IListingsRepository';

export class SearchListingsUseCase {
  constructor(private readonly repository: IListingsRepository) {}

  execute(filters: ListingFilters): Promise<Listing[]> {
    return this.repository.search(filters);
  }
}
