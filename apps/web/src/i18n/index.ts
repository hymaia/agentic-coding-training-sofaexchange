import i18n from 'i18next';
import { initReactI18next } from 'react-i18next';
import en from './locales/en.json';
import fr from './locales/fr.json';
import it from './locales/it.json';

i18n.use(initReactI18next).init({
  resources: { en: { translation: en }, fr: { translation: fr }, it: { translation: it } },
  lng: navigator.language.split('-')[0],   // detect browser language
  fallbackLng: 'en',
  supportedLngs: ['en', 'fr', 'it'],
  interpolation: { escapeValue: false },
});

export default i18n;
