import {
  IsArray,
  IsBoolean,
  IsEnum,
  IsOptional,
} from 'class-validator';
import { Transform } from 'class-transformer';
import { City }     from '../../../domain/enums/city.enum';
import { SofaType } from '../../../domain/enums/sofa-type.enum';

export class GetListingsQueryDto {
  @IsOptional()
  @IsArray()
  @IsEnum(City, { each: true })
  @Transform(({ value }) => (Array.isArray(value) ? value : [value]))
  city?: City[];

  @IsOptional()
  @Transform(({ value }) => value === 'true' || value === true)
  @IsBoolean()
  hasFreeWifi?: boolean;

  @IsOptional()
  @IsEnum(SofaType)
  sofaType?: SofaType;
}
