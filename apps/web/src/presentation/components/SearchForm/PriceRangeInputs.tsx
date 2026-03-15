import { useTranslation } from 'react-i18next';
import { ListingFilters } from '../../../domain/entities/Listing';

interface Props {
  filters: ListingFilters;
  onChange: (filters: ListingFilters) => void;
}

export function PriceRangeInputs({ filters, onChange }: Props) {
  const { t } = useTranslation();
  const minEuros =
    filters.minPriceCents !== undefined ? filters.minPriceCents / 100 : '';
  const maxEuros =
    filters.maxPriceCents !== undefined ? filters.maxPriceCents / 100 : '';

  function handleMinBlur(e: React.FocusEvent<HTMLInputElement>) {
    const raw = e.target.value;
    if (raw === '') {
      const { minPriceCents: _removed, ...rest } = filters;
      onChange(rest as ListingFilters);
    } else {
      onChange({
        ...filters,
        minPriceCents: Math.floor(parseFloat(raw) * 100),
      });
    }
  }

  function handleMaxBlur(e: React.FocusEvent<HTMLInputElement>) {
    const raw = e.target.value;
    if (raw === '') {
      const { maxPriceCents: _removed, ...rest } = filters;
      onChange(rest as ListingFilters);
    } else {
      onChange({
        ...filters,
        maxPriceCents: Math.floor(parseFloat(raw) * 100),
      });
    }
  }

  return (
    <div className="price-grid">
      <label className="field-control">
        {t('min_price')}
        <input
          type="number"
          min={0}
          step={0.01}
          defaultValue={minEuros}
          key={`min-${filters.minPriceCents}`}
          onBlur={handleMinBlur}
        />
      </label>
      <label className="field-control">
        {t('max_price')}
        <input
          type="number"
          min={0}
          step={0.01}
          defaultValue={maxEuros}
          key={`max-${filters.maxPriceCents}`}
          onBlur={handleMaxBlur}
        />
      </label>
    </div>
  );
}
