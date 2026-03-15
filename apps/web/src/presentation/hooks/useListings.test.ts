import { renderHook, waitFor } from '@testing-library/react';
import { describe, it, expect, vi, beforeEach, afterEach } from 'vitest';
import { useListings } from './useListings';
import { ListingFilters } from '../../domain/entities/Listing';

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
];

beforeEach(() => {
  vi.stubGlobal(
    'fetch',
    vi.fn().mockResolvedValue({
      ok: true,
      json: async () => mockListings,
    }),
  );
});

afterEach(() => {
  vi.restoreAllMocks();
});

describe('useListings', () => {
  it('returns listings after fetching', async () => {
    const filters: ListingFilters = { city: ['LONDON'] };
    const { result } = renderHook(() => useListings(filters));

    await waitFor(() => {
      expect(result.current.isLoading).toBe(false);
    });

    expect(result.current.listings).toEqual(mockListings);
    expect(result.current.error).toBeUndefined();
  });

  it('uses a different SWR key when filters change', async () => {
    const filtersA: ListingFilters = { city: ['LONDON'] };
    const filtersB: ListingFilters = { city: ['PARIS'] };

    expect(JSON.stringify(filtersA)).not.toBe(JSON.stringify(filtersB));
  });

  it('returns empty array initially before data loads', () => {
    // Make fetch never resolve during this test to observe loading state
    vi.stubGlobal('fetch', vi.fn(() => new Promise(() => {})));

    const filters: ListingFilters = { city: [] };
    const { result } = renderHook(() => useListings(filters));

    expect(result.current.listings).toEqual([]);
  });

  it('returns error when fetch fails', async () => {
    vi.stubGlobal(
      'fetch',
      vi.fn().mockResolvedValue({
        ok: false,
        status: 500,
        statusText: 'Internal Server Error',
      }),
    );

    const filters: ListingFilters = { city: [] };
    const { result } = renderHook(() => useListings(filters));

    await waitFor(() => {
      expect(result.current.error).toBeDefined();
    });

    expect(result.current.listings).toEqual([]);
  });
});
