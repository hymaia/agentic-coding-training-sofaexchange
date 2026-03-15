import { useTranslation } from 'react-i18next';
import { ConnectionError } from '../../../infrastructure/api/ListingsApiRepository';

interface Props {
  error: Error;
}

export function ErrorMessage({ error }: Props) {
  const { t } = useTranslation();
  const message = error instanceof ConnectionError ? t('connection_error') : error.message;
  return (
    <div className="status-box error-box" role="alert" aria-label="Error">
      {message}
    </div>
  );
}
