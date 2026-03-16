import { City }     from '../../../domain/enums/city.enum';
import { SofaType } from '../../../domain/enums/sofa-type.enum';

export interface SearchListingsQuery {
  city?: City[];
  hasFreeWifi?: boolean;
  sofaType?: SofaType;
}
