import React from 'react';
import { useRecoilValue } from 'recoil';
import { exampleSelector } from './exampleSelector';

const ExampleComponent: React.FC = () => {
  const exampleValue = useRecoilValue(exampleSelector);

  return (
    <div>
      <h2>Example Component</h2>
      <p>Example Value: {exampleValue}</p>
    </div>
  );
};

export default ExampleComponent;
