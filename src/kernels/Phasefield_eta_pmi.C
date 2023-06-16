#include "Phasefield_eta_pmi.h"
#include "RotationTensor.h"

registerMooseObject("MooseApp", Phasefield_eta_pmi);

InputParameters
Phasefield_eta_pmi::validParams()
{
  InputParameters params = Kernel::validParams();
  params.addClassDescription("Compute the interface phase field parameter: "
                             "$\\eta - \\lc_eta^2 \\nabla eta = 0$");
  params.addRequiredParam<Real>("lc_eta_pmi", "Length scale for diffused interface model");
  return params;
}

Phasefield_eta_pmi::Phasefield_eta_pmi(const InputParameters & parameters)
  : Kernel(parameters),
  _lc_eta_pmi(getParam<Real>("lc_eta_pmi"))
{
}

Real
Phasefield_eta_pmi::computeQpResidual()
{
  return _u[_qp] * _test[_i][_qp] + _lc_eta_pmi * _lc_eta_pmi * _grad_test[_i][_qp] * _grad_u[_qp];
}

Real
Phasefield_eta_pmi::computeQpJacobian()
{
  return _phi[_j][_qp] * _test[_i][_qp] + _lc_eta_pmi * _lc_eta_pmi * _grad_test[_i][_qp] * _grad_phi[_j][_qp] ;
}
