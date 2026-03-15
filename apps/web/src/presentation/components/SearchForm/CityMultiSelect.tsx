import { useTranslation } from 'react-i18next';
import { ALL_CITIES, City, ListingFilters } from '../../../domain/entities/Listing';

interface Props {
  filters: ListingFilters;
  onChange: (filters: ListingFilters) => void;
}

export function CityMultiSelect({ filters, onChange }: Props) {
  const { t } = useTranslation();

  function handleCityChange(e: React.ChangeEvent<HTMLSelectElement>) {
    const value = e.target.value;
    onChange({
      ...filters,
      city: value === '' ? [] : [value as City],
    });
  }

  return (
    <label className="field-control">
      {t('cities_label')}
      <select
        value={filters.city[0] ?? ''}
        onChange={handleCityChange}
      >
        <option value="">{t('sofa_type_any')}</option>
        {ALL_CITIES.map((city) => (
          <option key={city} value={city}>
            {t('city_' + city)}
          </option>
        ))}
      </select>
    </label>
  );
}
