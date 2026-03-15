import { City }     from '../../../domain/enums/city.enum';
import { SofaType } from '../../../domain/enums/sofa-type.enum';

export interface SearchListingsQuery {
  city?: City[];
  minPriceCents?: number;
  maxPriceCents?: number;
  hasFreeWifi?: boolean;
  sofaType?: SofaType;
}
