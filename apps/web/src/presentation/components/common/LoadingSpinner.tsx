import { useTranslation } from 'react-i18next';

export function LoadingSpinner() {
  const { t } = useTranslation();
  return (
    <div className="status-box" role="status" aria-label={t('loading')}>
      {t('loading')}
    </div>
  );
}
