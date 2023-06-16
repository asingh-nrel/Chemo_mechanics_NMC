#include "CoupledNeumannBC.h"

registerMooseObject("MooseApp", CoupledNeumannBC);

InputParameters
CoupledNeumannBC::validParams()
{
  InputParameters params = IntegratedBC::validParams();

  params.addParam<Real>("Flux_val", 1.0, "Flux value on the boundary");
  return params;
}

CoupledNeumannBC::CoupledNeumannBC(const InputParameters & parameters)
  : IntegratedBC(parameters),
    _Flux_val(getParam<Real>("Flux_val"))        
{
}

Real
CoupledNeumannBC::computeQpResidual()
{
  return _test[_i][_qp] * _Flux_val;
}
