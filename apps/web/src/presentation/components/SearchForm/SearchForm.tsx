import { ListingFilters } from '../../../domain/entities/Listing';
import { CityMultiSelect } from './CityMultiSelect';
import { PriceRangeInputs } from './PriceRangeInputs';
import { SofaTypeSelect } from './SofaTypeSelect';
import { WifiToggle } from './WifiToggle';

interface Props {
  filters: ListingFilters;
  onChange: (filters: ListingFilters) => void;
}

export function SearchForm({ filters, onChange }: Props) {
  return (
    <form className="search-form" onSubmit={(e) => e.preventDefault()}>
      <CityMultiSelect filters={filters} onChange={onChange} />
      <PriceRangeInputs filters={filters} onChange={onChange} />
      <SofaTypeSelect filters={filters} onChange={onChange} />
      <WifiToggle filters={filters} onChange={onChange} />
    </form>
  );
}
