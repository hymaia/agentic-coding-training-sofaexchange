import { renderHook, waitFor } from '@testing-library/react';
import { describe, it, expect } from 'vitest';
import { useListings } from './useListings';
import { Listing } from '../../domain/entities/Listing';

const mockListings = [
  {
    id: '1',
    title: 'Cozy sofa in London',
    city: 'LONDON' as const,
    pricePerNightCents: 3500,
    sofaType: 'SOFA_BED' as const,
    hasFreeWifi: true,
    createdAt: '2024-01-01T00:00:00.000Z',
    updatedAt: '2024-01-01T00:00:00.000Z',
  },
 ] as Listing[];

describe('useListings', () => {
  it('passes through listings from input view model', async () => {
    const { result } = renderHook(() =>
      useListings({ listings: mockListings, error: undefined, isLoading: false }),
    );

    await waitFor(() => {
      expect(result.current.listings).toEqual(mockListings);
    });

    expect(result.current.error).toBeUndefined();
    expect(result.current.isLoading).toBe(false);
  });

  it('mirrors loading state from input', async () => {
    const { result } = renderHook(() =>
      useListings({ listings: [], error: undefined, isLoading: true }),
    );
    await waitFor(() => {
      expect(result.current.isLoading).toBe(true);
    });
  });

  it('clears listings when error is present', async () => {
    const { result } = renderHook(() =>
      useListings({
        listings: mockListings,
        error: new Error('Something went wrong'),
        isLoading: false,
      }),
    );

    await waitFor(() => {
      expect(result.current.error).toBeDefined();
    });

    expect(result.current.listings).toEqual([]);
  });
});
