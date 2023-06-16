#include "Phasefield_eta_gb.h"
#include "RotationTensor.h"

registerMooseObject("MooseApp", Phasefield_eta_gb);

InputParameters
Phasefield_eta_gb::validParams()
{
  InputParameters params = Kernel::validParams();
  params.addClassDescription("Compute the interface phase field parameter: "
                             "$\\eta - \\lc_eta^2 \\nabla eta = 0$");
  params.addRequiredParam<Real>("lc_eta_gb", "Length scale for diffused interface model");
  return params;
}

Phasefield_eta_gb::Phasefield_eta_gb(const InputParameters & parameters)
  : Kernel(parameters),
  _lc_eta_gb(getParam<Real>("lc_eta_gb"))
{
}

Real
Phasefield_eta_gb::computeQpResidual()
{
  return _u[_qp] * _test[_i][_qp] + _lc_eta_gb * _lc_eta_gb * _grad_test[_i][_qp] * _grad_u[_qp];
}

Real
Phasefield_eta_gb::computeQpJacobian()
{
  return _phi[_j][_qp] * _test[_i][_qp] + _lc_eta_gb * _lc_eta_gb * _grad_test[_i][_qp] * _grad_phi[_j][_qp] ;
}
