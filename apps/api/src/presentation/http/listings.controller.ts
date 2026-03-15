import { Controller, Get, Query, ValidationPipe } from '@nestjs/common';
import { GetListingsQueryDto }  from './dto/get-listings-query.dto';
import { ListingResponseDto }   from './dto/listing-response.dto';
import { SearchListingsUseCase } from '../../application/use-cases/search-listings/search-listings.use-case';

@Controller('listings')
export class ListingsController {
  constructor(private readonly searchListings: SearchListingsUseCase) {}

  @Get()
  async findAll(
    @Query(new ValidationPipe({ transform: true, whitelist: true }))
    query: GetListingsQueryDto,
  ): Promise<ListingResponseDto[]> {
    const listings = await this.searchListings.execute(query);
    return listings.map(ListingResponseDto.fromEntity);
  }
}
