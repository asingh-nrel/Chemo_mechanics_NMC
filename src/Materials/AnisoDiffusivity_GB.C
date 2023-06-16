#include "AnisoDiffusivity_GB.h"
#include "RotationTensor.h"
#include "RankTwoTensor.h"

registerMooseObject("BabblerApp", AnisoDiffusivity_GB);

InputParameters
AnisoDiffusivity_GB::validParams()
{
  InputParameters params = Material::validParams();
  params.addClassDescription("Compute an diffusion tensor for anisotropic transport.");
  params.addParam<UserObjectName>("read_prop_user_object",
                                  "The ElementReadPropertyFile"
                                  "GeneralUserObject to read element "
                                  "specific property values from file");
  params.addRequiredParam<std::vector<Real>>("diffusivity_g", "Diffusion tensor for grains");
  params.addRequiredParam<std::vector<Real>>("diffusivity_gb", "Diffusion tensor for grain boundaries");
  params.addRequiredCoupledVar("d", "Damage");
  params.addRequiredCoupledVar("eta_gb", "grain_boundary");
  return params;
}

AnisoDiffusivity_GB::AnisoDiffusivity_GB(const InputParameters & parameters)
  : Material(parameters),
   _read_prop_user_object(isParamValid("read_prop_user_object")
                                  ? &getUserObject<ElementPropertyReadFile>("read_prop_user_object")
                                   : nullptr),
    _Euler_angles_mat_prop(declareProperty<RealVectorValue>("Euler_angles")),
    _crysrot(declareProperty<RankTwoTensor>("crysrot")),
    _Diff_Matrix(declareProperty<RankTwoTensor>("Diff_Matrix")),
    _d(coupledValue("d")),
    _eta_gb(coupledValue("eta_gb")),
    _R(_Euler_angles)
{
    _diffusivity_g.fillFromInputVector(getParam<std::vector<Real>>("diffusivity_g"));
    _diffusivity_gb.fillFromInputVector(getParam<std::vector<Real>>("diffusivity_gb"));
}

 void
    AnisoDiffusivity_GB::assignEulerAngles()
    {
      if (_read_prop_user_object)
      {
        _Euler_angles_mat_prop[_qp](0) = _read_prop_user_object->getData(_current_elem, 0);
        _Euler_angles_mat_prop[_qp](1) = _read_prop_user_object->getData(_current_elem, 1);
        _Euler_angles_mat_prop[_qp](2) = _read_prop_user_object->getData(_current_elem, 2);
      }
      else
        _Euler_angles_mat_prop[_qp] = _Euler_angles;
    }

 void
    AnisoDiffusivity_GB::computeQpProperties()
    {
     assignEulerAngles();
     
     _R.update(_Euler_angles_mat_prop[_qp]);
     
     _crysrot[_qp] = _R.transpose();

      RankTwoTensor _diffusivity = (1.0-_eta_gb[_qp])*(1.0-_eta_gb[_qp])*_diffusivity_g + (1.0-(1.0-_eta_gb[_qp])*(1.0-_eta_gb[_qp]))*_diffusivity_gb;

     _Diff_Matrix[_qp] = ((1.0-_d[_qp])*(1.0-_d[_qp]))*_diffusivity;
     
     _Diff_Matrix[_qp].rotate(_crysrot[_qp]);
    
   // std::cout << _crysrot[_qp] << std::endl;
    }

