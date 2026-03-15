import { Test, TestingModule } from '@nestjs/testing';
import { SearchListingsUseCase } from './search-listings.use-case';
import { LISTING_REPOSITORY, IListingRepository } from '../../../domain/repositories/listing.repository.interface';
import { Listing } from '../../../domain/entities/listing.entity';
import { City } from '../../../domain/enums/city.enum';
import { SofaType } from '../../../domain/enums/sofa-type.enum';
import { SearchListingsQuery } from './search-listings.query';

describe('SearchListingsUseCase', () => {
  let useCase: SearchListingsUseCase;
  let mockRepository: jest.Mocked<IListingRepository>;

  const now = new Date();
  const mockListings: Listing[] = [
    new Listing(
      '550e8400-e29b-41d4-a716-446655440000',
      'Comfy sofa bed near Tower Bridge',
      City.LONDON,
      4500,
      SofaType.SOFA_BED,
      true,
      now,
      now,
    ),
  ];

  beforeEach(async () => {
    mockRepository = {
      findAll: jest.fn(),
    };

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        SearchListingsUseCase,
        { provide: LISTING_REPOSITORY, useValue: mockRepository },
      ],
    }).compile();

    useCase = module.get<SearchListingsUseCase>(SearchListingsUseCase);
  });

  it('should be defined', () => {
    expect(useCase).toBeDefined();
  });

  it('calls repository.findAll with the correct query', async () => {
    const query: SearchListingsQuery = {
      city: [City.LONDON],
      minPriceCents: 1000,
      maxPriceCents: 5000,
      hasFreeWifi: true,
      sofaType: SofaType.SOFA_BED,
    };

    mockRepository.findAll.mockResolvedValue(mockListings);

    await useCase.execute(query);

    expect(mockRepository.findAll).toHaveBeenCalledTimes(1);
    expect(mockRepository.findAll).toHaveBeenCalledWith(query);
  });

  it('returns the result from the repository', async () => {
    const query: SearchListingsQuery = {};
    mockRepository.findAll.mockResolvedValue(mockListings);

    const result = await useCase.execute(query);

    expect(result).toBe(mockListings);
    expect(result).toHaveLength(1);
    expect(result[0].city).toBe(City.LONDON);
  });

  it('returns empty array when repository returns empty', async () => {
    const query: SearchListingsQuery = { city: [City.VIENNA] };
    mockRepository.findAll.mockResolvedValue([]);

    const result = await useCase.execute(query);

    expect(result).toEqual([]);
  });
});
