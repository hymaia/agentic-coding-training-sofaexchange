import { useTranslation } from 'react-i18next';

export function EmptyState() {
  const { t } = useTranslation();
  return <div className="status-box">{t('no_listings')}</div>;
}
