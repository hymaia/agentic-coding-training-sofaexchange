import { useTranslation } from 'react-i18next';

const LANGUAGES = [
  { code: 'en', label: 'EN' },
  { code: 'fr', label: 'FR' },
  { code: 'it', label: 'IT' },
];

export function LanguageSwitcher() {
  const { i18n, t } = useTranslation();
  return (
    <div className="lang-switcher" aria-label={t('language_label')}>
      {LANGUAGES.map(({ code, label }) => (
        <button
          className="lang-button"
          key={code}
          onClick={() => i18n.changeLanguage(code)}
          disabled={i18n.language === code}
          aria-pressed={i18n.language === code}
        >
          {label}
        </button>
      ))}
    </div>
  );
}
