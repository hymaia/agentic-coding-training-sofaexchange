import { useTranslation } from 'react-i18next';
import { ListingFilters } from '../../../domain/entities/Listing';

interface Props {
  filters: ListingFilters;
  onChange: (filters: ListingFilters) => void;
}

export function PriceRangeInputs(_: Props) {
  const { t } = useTranslation();

  return (
    <div className="price-grid">
      <label className="field-control">
        {t('min_price')}
        <input
          type="number"
          min={0}
          step={0.01}
        />
      </label>
      <label className="field-control">
        {t('max_price')}
        <input
          type="number"
          min={0}
          step={0.01}
        />
      </label>
    </div>
  );
}
