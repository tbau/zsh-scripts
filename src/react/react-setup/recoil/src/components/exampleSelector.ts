import { selector } from 'recoil';
import { exampleAtom } from './exampleAtom';

export const exampleSelector = selector({
  key: 'exampleSelector',
  get: ({ get }) => {
    const exampleValue = get(exampleAtom);
    return exampleValue.toUpperCase();
  },
});
