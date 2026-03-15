import { City }     from '../enums/city.enum';
import { SofaType } from '../enums/sofa-type.enum';

export class Listing {
  constructor(
    public readonly id: string,
    public readonly title: string,
    public readonly city: City,
    public readonly pricePerNightCents: number,
    public readonly sofaType: SofaType,
    public readonly hasFreeWifi: boolean,
    public readonly createdAt: Date,
    public readonly updatedAt: Date,
  ) {}
}
