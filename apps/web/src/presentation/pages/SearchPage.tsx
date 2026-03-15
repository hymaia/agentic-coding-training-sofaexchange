import { useState } from 'react';
import { useTranslation } from 'react-i18next';
import { ListingFilters } from '../../domain/entities/Listing';
import { useListings } from '../hooks/useListings';
import { SearchForm } from '../components/SearchForm/SearchForm';
import { ListingList } from '../components/ListingList/ListingList';
import { LanguageSwitcher } from '../components/LanguageSwitcher/LanguageSwitcher';
import logo from '../../assets/logos/sofa-exchange-logo.svg';

export function SearchPage() {
  const { t } = useTranslation();
  const [filters, setFilters] = useState<ListingFilters>({ city: [] });
  const { listings, error, isLoading } = useListings(filters);

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
