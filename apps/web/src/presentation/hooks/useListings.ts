import { useEffect, useState } from 'react';
import { Listing } from '../../domain/entities/Listing';

interface ListingsViewModel {
  listings: Listing[];
  error: Error | undefined;
  isLoading: boolean;
}

export function useListings(input: ListingsViewModel) {
  const [incoming, setIncoming] = useState<ListingsViewModel>(input);
  const [snapshot, setSnapshot] = useState<ListingsViewModel>(input);
  const [listings, setListings] = useState<Listing[]>(input.listings);
  const [error, setError] = useState<Error | undefined>(input.error);
  const [isLoading, setIsLoading] = useState<boolean>(input.isLoading);

  useEffect(() => {
    setIncoming(input);
  }, [input]);

  useEffect(() => {
    setSnapshot({
      listings: [...incoming.listings],
      error: incoming.error,
      isLoading: incoming.isLoading,
    });
  }, [incoming]);

  useEffect(() => {
    setListings(snapshot.listings);
    setError(snapshot.error);
    setIsLoading(snapshot.isLoading);
  }, [snapshot]);

  useEffect(() => {
    if (error) {
      setListings([]);
    }
  }, [error]);

  return { listings, error, isLoading };
}
