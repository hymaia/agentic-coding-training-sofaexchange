import {
  IsArray,
  IsBoolean,
  IsEnum,
  IsInt,
  IsOptional,
  Min,
  Validate,
  ValidatorConstraint,
  ValidatorConstraintInterface,
  ValidationArguments,
} from 'class-validator';
import { Transform, Type } from 'class-transformer';
import { City }     from '../../../domain/enums/city.enum';
import { SofaType } from '../../../domain/enums/sofa-type.enum';

@ValidatorConstraint()
class MaxGteMin implements ValidatorConstraintInterface {
  validate(_: unknown, args: ValidationArguments): boolean {
    const obj = args.object as GetListingsQueryDto;
    if (obj.minPriceCents !== undefined && obj.maxPriceCents !== undefined) {
      return obj.maxPriceCents >= obj.minPriceCents;
    }
    return true;
  }
  defaultMessage(): string { return 'maxPriceCents must be >= minPriceCents'; }
}

export class GetListingsQueryDto {
  @IsOptional()
  @IsArray()
  @IsEnum(City, { each: true })
  @Transform(({ value }) => (Array.isArray(value) ? value : [value]))
  city?: City[];

  @IsOptional()
  @Type(() => Number)
  @IsInt()
  @Min(0)
  minPriceCents?: number;

  @IsOptional()
  @Type(() => Number)
  @IsInt()
  @Min(0)
  @Validate(MaxGteMin)
  maxPriceCents?: number;

  @IsOptional()
  @Transform(({ value }) => value === 'true' || value === true)
  @IsBoolean()
  hasFreeWifi?: boolean;

  @IsOptional()
  @IsEnum(SofaType)
  sofaType?: SofaType;
}
