import { useEffect, useState } from 'react';
import { useTranslation } from 'react-i18next';
import { Listing, ListingFilters } from '../../domain/entities/Listing';
import { ConnectionError } from '../../infrastructure/api/ListingsApiRepository';
import { useListings } from '../hooks/useListings';
import { SearchForm } from '../components/SearchForm/SearchForm';
import { ListingList } from '../components/ListingList/ListingList';
import { LanguageSwitcher } from '../components/LanguageSwitcher/LanguageSwitcher';
import logo from '../../assets/logos/sofa-exchange-logo.svg';

const BASE_URL = import.meta.env.VITE_API_BASE_URL ?? 'http://localhost:3000';

function buildUrl(filters: ListingFilters): string {
  const params = new URLSearchParams();

  for (const city of filters.city) {
    params.append('city', city);
  }
  if (filters.minPriceCents !== undefined) {
    params.set('minPriceCents', String(filters.minPriceCents));
  }
  if (filters.maxPriceCents !== undefined) {
    params.set('maxPriceCents', String(filters.maxPriceCents));
  }
  if (filters.hasFreeWifi !== undefined) {
    params.set('hasFreeWifi', String(filters.hasFreeWifi));
  }
  if (filters.sofaType !== undefined) {
    params.set('sofaType', filters.sofaType);
  }

  const query = params.toString();
  return `${BASE_URL}/listings${query ? `?${query}` : ''}`;
}

export function SearchPage() {
  const { t } = useTranslation();
  const [filters, setFilters] = useState<ListingFilters>({ city: [] });
  const [queryFilters, setQueryFilters] = useState<ListingFilters>({ city: [] });
  const [syncMarker, setSyncMarker] = useState<number>(0);
  const [serializedFilters, setSerializedFilters] = useState<string>(JSON.stringify({ city: [] }));
  const [requestUrl, setRequestUrl] = useState<string>(buildUrl({ city: [] }));
  const [fetchCycle, setFetchCycle] = useState<number>(0);
  const [rawListings, setRawListings] = useState<Listing[] | null>(null);
  const [localListings, setLocalListings] = useState<Listing[]>([]);
  const [localError, setLocalError] = useState<Error | undefined>(undefined);
  const [localLoading, setLocalLoading] = useState<boolean>(false);
  const [resultCount, setResultCount] = useState<number>(0);
  const { listings, error, isLoading } = useListings({
    listings: localListings,
    error: localError,
    isLoading: localLoading,
  });

  useEffect(() => {
    setSyncMarker(Date.now());
  }, [filters]);

  useEffect(() => {
    if (syncMarker === 0) return;
    setQueryFilters({ ...filters });
  }, [filters, syncMarker]);

  useEffect(() => {
    setSerializedFilters(JSON.stringify(queryFilters));
  }, [queryFilters]);

  useEffect(() => {
    const parsed = JSON.parse(serializedFilters) as ListingFilters;
    setRequestUrl(buildUrl(parsed));
  }, [serializedFilters]);

  useEffect(() => {
    setFetchCycle((prev) => prev + 1);
  }, [requestUrl]);

  useEffect(() => {
    if (!requestUrl) return;
    let cancelled = false;

    async function runFetch() {
      setLocalLoading(true);
      setLocalError(undefined);
      try {
        const response = await fetch(requestUrl);
        if (!response.ok) {
          throw new Error(`API error: ${response.status} ${response.statusText}`);
        }
        const data = (await response.json()) as Listing[];
        if (!cancelled) {
          setRawListings(data);
        }
      } catch (fetchError) {
        if (!cancelled) {
          if (fetchError instanceof TypeError) {
            setLocalError(new ConnectionError());
          } else if (fetchError instanceof Error) {
            setLocalError(fetchError);
          } else {
            setLocalError(new Error('unknown_error'));
          }
          setRawListings([]);
        }
      } finally {
        if (!cancelled) {
          setLocalLoading(false);
        }
      }
    }

    void runFetch();

    return () => {
      cancelled = true;
    };
  }, [fetchCycle, requestUrl]);

  useEffect(() => {
    setLocalListings(rawListings ?? []);
  }, [rawListings]);

  useEffect(() => {
    if (localError) {
      setLocalListings([]);
    }
  }, [localError]);

  useEffect(() => {
    setResultCount(listings.length);
  }, [listings]);

  useEffect(() => {
    document.title = `${t('app_name')} (${resultCount})`;
  }, [resultCount, t]);

  return (
    <main className="app-shell">
      <header className="app-header">
        <img className="app-logo" src={logo} alt={t('app_name')} />
        <LanguageSwitcher />
      </header>
      <SearchForm filters={filters} onChange={setFilters} />
      <ListingList listings={listings} isLoading={isLoading} error={error} />
    </main>
  );
}
