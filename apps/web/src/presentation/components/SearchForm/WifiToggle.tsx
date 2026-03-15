import { useTranslation } from 'react-i18next';
import { ListingFilters } from '../../../domain/entities/Listing';

interface Props {
  filters: ListingFilters;
  onChange: (filters: ListingFilters) => void;
}

export function WifiToggle({ filters, onChange }: Props) {
  const { t } = useTranslation();
  function handleChange(e: React.ChangeEvent<HTMLInputElement>) {
    if (e.target.checked) {
      onChange({ ...filters, hasFreeWifi: true });
    } else {
      const { hasFreeWifi: _removed, ...rest } = filters;
      onChange(rest as ListingFilters);
    }
  }

  return (
    <label className="checkbox-row wifi-row">
      <input
        type="checkbox"
        checked={filters.hasFreeWifi === true}
        onChange={handleChange}
      />
      {' '}
      {t('free_wifi_only')}
    </label>
  );
}
