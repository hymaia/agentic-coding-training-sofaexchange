import { Module } from '@nestjs/common';
import { ListingsController }       from './listings.controller';
import { SearchListingsUseCase }    from '../../application/use-cases/search-listings/search-listings.use-case';
import { ListingSqliteRepository }  from '../../infrastructure/database/listing.sqlite.repository';
import { LISTING_REPOSITORY }       from '../../domain/repositories/listing.repository.interface';

@Module({
  controllers: [ListingsController],
  providers: [
    SearchListingsUseCase,
    { provide: LISTING_REPOSITORY, useClass: ListingSqliteRepository },
  ],
})
export class ListingsModule {}
