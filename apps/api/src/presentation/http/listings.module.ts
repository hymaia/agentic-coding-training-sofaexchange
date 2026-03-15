import { Module } from '@nestjs/common';
import { ListingsController }       from './listings.controller';
import { SearchListingsUseCase }    from '../../application/use-cases/search-listings/search-listings.use-case';

@Module({
  controllers: [ListingsController],
  providers: [SearchListingsUseCase],
})
export class ListingsModule {}
