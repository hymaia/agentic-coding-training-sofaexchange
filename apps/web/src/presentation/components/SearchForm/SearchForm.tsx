import { useTranslation } from 'react-i18next';
import { ListingFilters } from '../../../domain/entities/Listing';
import { CityMultiSelect } from './CityMultiSelect';
import { PriceRangeInputs } from './PriceRangeInputs';
import { SofaTypeSelect } from './SofaTypeSelect';
import { WifiToggle } from './WifiToggle';

interface Props {
  filters: ListingFilters;
  onChange: (filters: ListingFilters) => void;
  onSearch: () => void;
}

export function SearchForm({ filters, onChange, onSearch }: Props) {
  const { t } = useTranslation();
  return (
    <form className="search-form" onSubmit={(e) => { e.preventDefault(); onSearch(); }}>
      <CityMultiSelect filters={filters} onChange={onChange} />
      <PriceRangeInputs filters={filters} onChange={onChange} />
      <SofaTypeSelect filters={filters} onChange={onChange} />
      <WifiToggle filters={filters} onChange={onChange} />
      <button type="submit" className="search-button">{t('search_button')}</button>
    </form>
  );
}
