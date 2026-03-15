import { City }     from '../../../domain/enums/city.enum';
import { SofaType } from '../../../domain/enums/sofa-type.enum';
import { Listing }  from '../../../domain/entities/listing.entity';

export class ListingResponseDto {
  id: string;
  title: string;
  city: City;
  pricePerNightCents: number;
  sofaType: SofaType;
  hasFreeWifi: boolean;
  createdAt: string;
  updatedAt: string;

  static fromEntity(l: Listing): ListingResponseDto {
    return {
      id:                 l.id,
      title:              l.title,
      city:               l.city,
      pricePerNightCents: l.pricePerNightCents,
      sofaType:           l.sofaType,
      hasFreeWifi:        l.hasFreeWifi,
      createdAt:          l.createdAt.toISOString(),
      updatedAt:          l.updatedAt.toISOString(),
    };
  }
}
