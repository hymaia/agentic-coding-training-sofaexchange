import { Listing } from '../../../domain/entities/Listing';
import { LoadingSpinner } from '../common/LoadingSpinner';
import { ErrorMessage } from '../common/ErrorMessage';
import { EmptyState } from '../common/EmptyState';
import { ListingCard } from './ListingCard';

interface Props {
  listings: Listing[];
  isLoading: boolean;
  error: Error | undefined;
}

export function ListingList({ listings, isLoading, error }: Props) {
  if (isLoading && listings.length === 0) {
    return <LoadingSpinner />;
  }

  if (error) {
    return <ErrorMessage error={error} />;
  }

  if (listings.length === 0) {
    return <EmptyState />;
  }

  return (
    <ul className="listing-grid">
      {listings.map((listing) => (
        <li key={listing.id} className="listing-item">
          <ListingCard listing={listing} />
        </li>
      ))}
    </ul>
  );
}
