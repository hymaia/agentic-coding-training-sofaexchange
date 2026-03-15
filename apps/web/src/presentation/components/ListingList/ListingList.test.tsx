import { render, screen } from '@testing-library/react';
import { describe, it, expect } from 'vitest';
import { ListingList } from './ListingList';
import { Listing } from '../../../domain/entities/Listing';

const mockListings: Listing[] = [
  {
    id: '1',
    title: 'Cozy sofa in London',
    city: 'LONDON',
    pricePerNightCents: 3500,
    sofaType: 'SOFA_BED',
    hasFreeWifi: true,
    createdAt: '2024-01-01T00:00:00.000Z',
    updatedAt: '2024-01-01T00:00:00.000Z',
  },
  {
    id: '2',
    title: 'Simple sofa in Paris',
    city: 'PARIS',
    pricePerNightCents: 2000,
    sofaType: 'SIMPLE_SOFA',
    hasFreeWifi: false,
    createdAt: '2024-01-02T00:00:00.000Z',
    updatedAt: '2024-01-02T00:00:00.000Z',
  },
];

describe('ListingList', () => {
  it('shows loading spinner when isLoading is true and no listings', () => {
    render(<ListingList listings={[]} isLoading={true} error={undefined} />);
    expect(screen.getByRole('status')).toBeInTheDocument();
  });

  it('does not show loading spinner when listings are present even if still loading', () => {
    render(
      <ListingList listings={mockListings} isLoading={true} error={undefined} />,
    );
    expect(screen.queryByRole('status')).not.toBeInTheDocument();
    expect(screen.getByText('Cozy sofa in London')).toBeInTheDocument();
  });

  it('shows error message when error is provided', () => {
    const error = new Error('Something went wrong');
    render(<ListingList listings={[]} isLoading={false} error={error} />);
    expect(screen.getByRole('alert')).toBeInTheDocument();
    expect(screen.getByText('Something went wrong')).toBeInTheDocument();
  });

  it('shows empty state when no listings and not loading', () => {
    render(<ListingList listings={[]} isLoading={false} error={undefined} />);
    expect(screen.getByText('No listings found')).toBeInTheDocument();
  });

  it('renders all listings', () => {
    render(
      <ListingList listings={mockListings} isLoading={false} error={undefined} />,
    );
    expect(screen.getByText('Cozy sofa in London')).toBeInTheDocument();
    expect(screen.getByText('Simple sofa in Paris')).toBeInTheDocument();
  });

  it('renders listing details including price and sofa type', () => {
    render(
      <ListingList listings={[mockListings[0]]} isLoading={false} error={undefined} />,
    );
    expect(screen.getByText('€35.00 / night')).toBeInTheDocument();
    expect(screen.getByText('Sofa Bed')).toBeInTheDocument();
    expect(screen.getByText('Free WiFi')).toBeInTheDocument();
  });
});
