import { useTranslation } from 'react-i18next';
import { ListingFilters, SofaType } from '../../../domain/entities/Listing';

interface Props {
  filters: ListingFilters;
  onChange: (filters: ListingFilters) => void;
}

export function SofaTypeSelect({ filters, onChange }: Props) {
  const { t } = useTranslation();
  function handleChange(e: React.ChangeEvent<HTMLSelectElement>) {
    const value = e.target.value;
    if (value === '') {
      const { sofaType: _removed, ...rest } = filters;
      onChange(rest as ListingFilters);
    } else {
      onChange({ ...filters, sofaType: value as SofaType });
    }
  }

  return (
    <label className="field-control">
      {t('sofa_type_label')}
      <select value={filters.sofaType ?? ''} onChange={handleChange}>
        <option value="">{t('sofa_type_any')}</option>
        <option value="SOFA_BED">{t('sofa_type_sofa_bed')}</option>
        <option value="SIMPLE_SOFA">{t('sofa_type_simple_sofa')}</option>
      </select>
    </label>
  );
}
