 #include "Aniso_Eigen_Strain.h"
 #include "RotationTensor.h"
 #include "RankTwoTensor.h"
  
 registerMooseObject("TensorMechanicsApp", Aniso_Eigen_Strain);
  
 InputParameters
 Aniso_Eigen_Strain::validParams()
 {
   InputParameters params = ComputeEigenstrainBase::validParams();
   params.addClassDescription("Computes a constant Eigenstrain");
   params.addRequiredParam<std::vector<Real>>(
       "eigen_base", "Vector of values defining the constant base tensor for the Eigenstrain");
   params.addParam<MaterialPropertyName>(
       "prefactor", 1.0, "Name of material defining the variable dependence");
   params.addParam<UserObjectName>("read_prop_user_object",
                                  "The ElementReadPropertyFile"
                                  "GeneralUserObject to read element "
                                  "specific property values from file");
   return params;
 }
  
 Aniso_Eigen_Strain::Aniso_Eigen_Strain(const InputParameters & parameters)
   : ComputeEigenstrainBase(parameters), 
	_prefactor(getMaterialProperty<Real>("prefactor")),
	   _read_prop_user_object(isParamValid("read_prop_user_object")
                                  ? &getUserObject<ElementPropertyReadFile>("read_prop_user_object")
                                   : nullptr),
    _Euler_angles_mat_prop(declareProperty<RealVectorValue>("Euler_angles_eigen")),
    _crysrot_eigen(declareProperty<RankTwoTensor>("crysrot_eigen")),
    _Expansion_Matrix(declareProperty<RankTwoTensor>("Expansion_Matrix")),
    _R_eigen(_Euler_angles_eigen)
 {
   _eigen_base_tensor.fillFromInputVector(getParam<std::vector<Real>>("eigen_base"));
 }
  
 void
    Aniso_Eigen_Strain::assignEulerAngles()
    {
      if (_read_prop_user_object)
      {
        _Euler_angles_mat_prop[_qp](0) = _read_prop_user_object->getData(_current_elem, 0);
        _Euler_angles_mat_prop[_qp](1) = _read_prop_user_object->getData(_current_elem, 1);
        _Euler_angles_mat_prop[_qp](2) = _read_prop_user_object->getData(_current_elem, 2);
      }
      else
        _Euler_angles_mat_prop[_qp] = _Euler_angles_eigen;
    }


 void
 Aniso_Eigen_Strain::computeQpEigenstrain()
 {
      assignEulerAngles();
     
     _R_eigen.update(_Euler_angles_mat_prop[_qp]);
     
     _crysrot_eigen[_qp] = _R_eigen.transpose();

     _Expansion_Matrix[_qp] = _eigen_base_tensor; 
     
     _Expansion_Matrix[_qp].rotate(_crysrot_eigen[_qp]);
    
     _eigenstrain[_qp] = _Expansion_Matrix[_qp] * _prefactor[_qp];
 }
