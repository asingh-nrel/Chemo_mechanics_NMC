#pragma once

// Including the "Kernel" Kernel here so we can extend it
#include "Kernel.h"

/**
 * Computes the residual contribution: K / mu * grad_u * grad_phi.
 */
class Concentration : public Kernel
{
public:
  static InputParameters validParams();

  Concentration(const InputParameters & parameters);

  virtual Real computeQpResidual() override;
  virtual Real computeQpJacobian() override;

  const Real & _ki; 
  const Real & _cmax; 

  const MaterialProperty<RankTwoTensor> & _Diff_Matrix;
 
};
