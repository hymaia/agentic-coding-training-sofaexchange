import { useTranslation } from 'react-i18next';
import { Listing } from '../../../domain/entities/Listing';

interface Props {
  listing: Listing;
}

function formatCents(cents: number): string {
  return `€${(cents / 100).toFixed(2)}`;
}

export function ListingCard({ listing }: Props) {
  const { t } = useTranslation();
  return (
    <article className="listing-card">
      <h2 className="listing-title">{listing.title}</h2>
      <p className="listing-meta">{t('city_' + listing.city)}</p>
      <p className="listing-price">{formatCents(listing.pricePerNightCents)} {t('per_night')}</p>
      <p className="listing-meta">
        {listing.sofaType === 'SOFA_BED' ? t('sofa_type_sofa_bed') : t('sofa_type_simple_sofa')}
      </p>
      {listing.hasFreeWifi && <span className="listing-chip">{t('wifi_included')}</span>}
    </article>
  );
}
