import 'reflect-metadata';
import { validate } from 'class-validator';
import { plainToInstance } from 'class-transformer';
import { GetListingsQueryDto } from './get-listings-query.dto';
import { City } from '../../../domain/enums/city.enum';
import { SofaType } from '../../../domain/enums/sofa-type.enum';

async function validateDto(plain: object): Promise<string[]> {
  const instance = plainToInstance(GetListingsQueryDto, plain);
  const errors = await validate(instance);
  return errors.map(e => Object.values(e.constraints ?? {}).join(', '));
}

describe('GetListingsQueryDto', () => {
  it('empty query is valid', async () => {
    const errors = await validateDto({});
    expect(errors).toHaveLength(0);
  });

  it('valid city array passes', async () => {
    const errors = await validateDto({ city: [City.LONDON, City.PARIS] });
    expect(errors).toHaveLength(0);
  });

  it('single city string is coerced to array and passes', async () => {
    const errors = await validateDto({ city: 'LONDON' });
    expect(errors).toHaveLength(0);
  });

  it('unknown city fails', async () => {
    const errors = await validateDto({ city: ['FOOBAR'] });
    expect(errors.length).toBeGreaterThan(0);
  });

  it('negative minPriceCents fails', async () => {
    const errors = await validateDto({ minPriceCents: -1 });
    expect(errors.length).toBeGreaterThan(0);
  });

  it('zero minPriceCents is valid', async () => {
    const errors = await validateDto({ minPriceCents: 0 });
    expect(errors).toHaveLength(0);
  });

  it('maxPriceCents < minPriceCents fails', async () => {
    const errors = await validateDto({ minPriceCents: 5000, maxPriceCents: 2000 });
    expect(errors.length).toBeGreaterThan(0);
    expect(errors.some(e => e.includes('maxPriceCents must be >= minPriceCents'))).toBe(true);
  });

  it('maxPriceCents === minPriceCents is valid', async () => {
    const errors = await validateDto({ minPriceCents: 3000, maxPriceCents: 3000 });
    expect(errors).toHaveLength(0);
  });

  it('maxPriceCents > minPriceCents is valid', async () => {
    const errors = await validateDto({ minPriceCents: 1000, maxPriceCents: 5000 });
    expect(errors).toHaveLength(0);
  });

  it('valid sofaType passes', async () => {
    const errors = await validateDto({ sofaType: SofaType.SOFA_BED });
    expect(errors).toHaveLength(0);
  });

  it('invalid sofaType fails', async () => {
    const errors = await validateDto({ sofaType: 'RECLINER' });
    expect(errors.length).toBeGreaterThan(0);
  });

  it('hasFreeWifi string "true" is coerced to boolean true', async () => {
    const instance = plainToInstance(GetListingsQueryDto, { hasFreeWifi: 'true' });
    const errors = await validate(instance);
    expect(errors).toHaveLength(0);
    expect(instance.hasFreeWifi).toBe(true);
  });

  it('hasFreeWifi string "false" is coerced to boolean false', async () => {
    const instance = plainToInstance(GetListingsQueryDto, { hasFreeWifi: 'false' });
    const errors = await validate(instance);
    expect(errors).toHaveLength(0);
    expect(instance.hasFreeWifi).toBe(false);
  });
});
