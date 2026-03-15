import useSWR from 'swr';
import { ListingFilters } from '../../domain/entities/Listing';
import { SearchListingsUseCase } from '../../application/use-cases/searchListings';
import { ListingsApiRepository } from '../../infrastructure/api/ListingsApiRepository';

const repository = new ListingsApiRepository();
const useCase = new SearchListingsUseCase(repository);

export function useListings(filters: ListingFilters) {
  const key = JSON.stringify(filters);

  const { data, error, isLoading } = useSWR(
    key,
    () => useCase.execute(filters),
    { revalidateOnFocus: false },
  );

  return {
    listings: data ?? [],
    error: error as Error | undefined,
    isLoading,
  };
}
