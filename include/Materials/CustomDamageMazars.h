#pragma once

#include "ScalarDamageBase.h"

/**
 * Scalar damage model that defines the damage parameter using a material property
 */
class CustomDamageMazars : public ScalarDamageBase
{
public:
  static InputParameters validParams();
  CustomDamageMazars(const InputParameters & parameters);

  // virtual void initQpStatefulProperties() override;
  
protected:

  virtual void updateQpDamageIndex() override;
  
  // Damage law parameters
  const Real & _sig_th;

  /// Current stress
  const MaterialProperty<double> & _von_mises;
};
