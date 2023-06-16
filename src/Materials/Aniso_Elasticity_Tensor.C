#include "Aniso_Elasticity_Tensor.h"
#include "RotationTensor.h"
#include "RankTwoTensor.h"
  
registerMooseObject("TensorMechanicsApp", Aniso_Elasticity_Tensor);
  
InputParameters
 Aniso_Elasticity_Tensor::validParams()
 {
    InputParameters params = ComputeRotatedElasticityTensorBase::validParams();
    params.addClassDescription("Compute concentration dependent elasticity tensor.");
    params.addRequiredParam<std::vector<Real>>("C0_ijkl",
                                               "Stiffness tensor for zero concentration phase");
    params.addRequiredParam<std::vector<Real>>("C1_ijkl",
                                               "Stiffness tensor for phase having concentration 1.0");
    params.addParam<MooseEnum>(
        "fill_method0", RankFourTensor::fillMethodEnum() = "symmetric9", "The fill method");
    params.addParam<MooseEnum>(
        "fill_method1", RankFourTensor::fillMethodEnum() = "symmetric9", "The fill method");
    params.addRequiredCoupledVar("c", "Concentration");
    params.addParam<UserObjectName>("read_prop_user_object",
                                  "The ElementReadPropertyFile"
                                  "GeneralUserObject to read element "
                                  "specific property values from file");
   params.addRequiredParam<Real>("cmax", "Stiffness tensor for material");
    return params;
  }
   
  Aniso_Elasticity_Tensor::Aniso_Elasticity_Tensor(
      const InputParameters & parameters)
    : ComputeRotatedElasticityTensorBase(parameters),
      _Cijkl0(getParam<std::vector<Real>>("C0_ijkl"),
              (RankFourTensor::FillMethod)(int)getParam<MooseEnum>("fill_method0")),
      _Cijkl1(getParam<std::vector<Real>>("C1_ijkl"),
              (RankFourTensor::FillMethod)(int)getParam<MooseEnum>("fill_method1")),
      _c(coupledValue("c")),
      _c_name(getVar("c", 0)->name()),
      _delasticity_tensor_dc(
          declarePropertyDerivative<RankFourTensor>(_elasticity_tensor_name, _c_name)),
      _read_prop_user_object(isParamValid("read_prop_user_object")
                                  ? &getUserObject<ElementPropertyReadFile>("read_prop_user_object")
                                   : nullptr),
    _Euler_angles_mat_prop(declareProperty<RealVectorValue>("Euler_angles_diff")),
    _crysrot_diff(declareProperty<RankTwoTensor>("crysrot_diff")),
    _R_diff(_Euler_angles_diff),
    _cmax(getParam<Real>("cmax"))
  {
 // Define a rotation according to Euler angle parameters
 // Rotate tensors
    _Cijkl0.rotate(_R_diff);
    _Cijkl1.rotate(_R_diff);
  }

 void
    Aniso_Elasticity_Tensor::assignEulerAngles()
    {
      if (_read_prop_user_object)
      {
        _Euler_angles_mat_prop[_qp](0) = _read_prop_user_object->getData(_current_elem, 0);
        _Euler_angles_mat_prop[_qp](1) = _read_prop_user_object->getData(_current_elem, 1);
        _Euler_angles_mat_prop[_qp](2) = _read_prop_user_object->getData(_current_elem, 2);
      }
      else
        _Euler_angles_mat_prop[_qp] = _Euler_angles_diff;
    }
   
  void
  Aniso_Elasticity_Tensor::computeQpElasticityTensor()
  {
     assignEulerAngles();
     
          _R_diff.update(_Euler_angles_mat_prop[_qp]);

	  _crysrot_diff[_qp] = _R_diff.transpose();

//	  _Cijkl0.rotate(_crysrot_diff[_qp]);

//	  _Cijkl1.rotate(_crysrot_diff[_qp]);

    // Assign elasticity tensor at a given quad point
    _elasticity_tensor[_qp] = _Cijkl0 + (_Cijkl1 - _Cijkl0) * _c[_qp]/_cmax;

    _elasticity_tensor[_qp].rotate(_crysrot_diff[_qp]);
    // Define derivative of elasticity tensor with respect to concentration.
    _delasticity_tensor_dc[_qp] = (_Cijkl1 - _Cijkl0);

    _delasticity_tensor_dc[_qp].rotate(_crysrot_diff[_qp]);
     //  std::cout << _elasticity_tensor << std::endl;
  }
