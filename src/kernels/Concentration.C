#include "Concentration.h"

registerMooseObject("MooseApp", Concentration);

InputParameters
Concentration::validParams()
{
  InputParameters params = Kernel::validParams();
  params.addClassDescription("Compute the concentration term for Fickian diffusion ($c$) equation: "
                             "$-\\nabla \\cdot \\frac{\\mathbf{K}}{\\mu} \\nabla p = 0$");
  params.addRequiredParam<Real>("ki", "Interaction parameter");
  params.addRequiredParam<Real>("cmax", "Maximum Concentration");
  return params;
}

Concentration::Concentration(const InputParameters & parameters)
  : Kernel(parameters),
  _ki(getParam<Real>("ki")),
  _cmax(getParam<Real>("cmax")),
    // Get the parameters from the input file
    _Diff_Matrix(getMaterialProperty<RankTwoTensor>("Diff_Matrix"))
{
}

Real
Concentration::computeQpResidual()
{
   return  (1.0-2.0*_ki*(_u[_qp]/_cmax)*(1.0-_u[_qp]/_cmax)) *_Diff_Matrix[_qp] * _grad_test[_i][_qp]*_grad_u[_qp];
}

Real
Concentration::computeQpJacobian()
{
  return (1.0-2.0*_ki*(_u[_qp]/_cmax)*(1.0-_u[_qp]/_cmax)) *_Diff_Matrix[_qp] * _grad_phi[_j][_qp] * _grad_test[_i][_qp]  +   (-2.0*_ki/_cmax + (4.0*_ki/_cmax)*(_u[_qp]/_cmax)) * _Diff_Matrix[_qp] *_grad_u[_qp] * _grad_test[_i][_qp];
}
