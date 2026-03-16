export type City =
  | 'LONDON'
  | 'PARIS'
  | 'MILAN'
  | 'MADRID'
  | 'LISBON'
  | 'BERLIN'
  | 'DUBLIN'
  | 'EDINBURGH'
  | 'VIENNA';

export const ALL_CITIES: City[] = [
  'LONDON',
  'PARIS',
  'MILAN',
  'MADRID',
  'LISBON',
  'BERLIN',
  'DUBLIN',
  'EDINBURGH',
  'VIENNA',
];

export type SofaType = 'SOFA_BED' | 'SIMPLE_SOFA';

export interface Listing {
  id: string;
  title: string;
  city: City;
  pricePerNightCents: number;
  sofaType: SofaType;
  hasFreeWifi: boolean;
  createdAt: string;
  updatedAt: string;
}

export interface ListingFilters {
  city: City[];
  hasFreeWifi?: boolean;
  sofaType?: SofaType;
}
