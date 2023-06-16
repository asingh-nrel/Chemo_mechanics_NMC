#pragma once

#include "IntegratedBC.h"

/**
 * Implements a simple constant Neumann BC where grad(u)=alpha * v on the boundary.
 * Uses the term produced from integrating the diffusion operator by parts.
 */
class CoupledNeumannBC : public IntegratedBC
{
public:
  CoupledNeumannBC(const InputParameters & parameters);

  static InputParameters validParams();

protected:
  virtual Real computeQpResidual() override;

private:
  /// Multiplier on the boundary.
  Real _Flux_val;
  /// reference to a user-specifiable coupled (independent) variable
};
