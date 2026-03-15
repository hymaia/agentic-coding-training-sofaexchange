import { Module, ValidationPipe } from '@nestjs/common';
import { APP_PIPE }               from '@nestjs/core';
import { DatabaseModule }         from './infrastructure/database/database.module';
import { ListingsModule }         from './presentation/http/listings.module';

@Module({
  imports: [DatabaseModule, ListingsModule],
  providers: [
    {
      provide: APP_PIPE,
      useValue: new ValidationPipe({ whitelist: true, forbidNonWhitelisted: true, transform: true }),
    },
  ],
})
export class AppModule {}
