#include "CustomDamageMazars.h"

#include "ElasticityTensorTools.h"
#include "MooseUtils.h"

#include "libmesh/utility.h"

registerMooseObject("TensorMechanicsApp", CustomDamageMazars);

InputParameters
CustomDamageMazars::validParams()
{
  InputParameters params = ScalarDamageBase::validParams();
  params.addClassDescription("Stress based damage model");

  params.addRequiredParam<Real>("sig_th","Damage threshold stress");
  
  return params;
}

CustomDamageMazars::CustomDamageMazars(const InputParameters & parameters)
  : ScalarDamageBase(parameters),

  // Damage law parameters
  _sig_th(getParam<Real>("sig_th")),

  // stress for damage quantification
  _von_mises(getMaterialProperty<double>("von_mises"))
    
{
}


void
CustomDamageMazars::updateQpDamageIndex()
{
  
  // access damage at previous timestep
  Real damage_old = _damage_index_old[_qp];
  
  // stress measure
  Real Xi = _von_mises[_qp];

  // compute damage
  Real damage_new = 0.0;

  if (Xi>_sig_th) {
  	  damage_new = 1.0;
  		   } else {
	  damage_new = 1.0;
  	}
  // update damage  
   _damage_index[_qp] = Xi;
  
}
