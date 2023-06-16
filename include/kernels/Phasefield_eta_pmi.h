#pragma once

// Including the "Kernel" Kernel here so we can extend it
#include "Kernel.h"

/**
 * Computes the residual contribution: K / mu * grad_u * grad_phi.
 */
class Phasefield_eta_pmi : public Kernel
{
public:
  static InputParameters validParams();

  Phasefield_eta_pmi(const InputParameters & parameters);

  virtual Real computeQpResidual() override;
  virtual Real computeQpJacobian() override;

 const Real & _lc_eta_pmi; 
};
