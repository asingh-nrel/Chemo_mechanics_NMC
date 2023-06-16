#pragma once
  
 #include "ComputeRotatedElasticityTensorBase.h"
 #include "ElementPropertyReadFile.h"
 #include "RankTwoTensor.h"
 #include "RotationTensor.h"

 class Aniso_Elasticity_Tensor : public ComputeRotatedElasticityTensorBase
 {
 public:
   static InputParameters validParams();
  
   Aniso_Elasticity_Tensor(const InputParameters & parameters);
  
 protected:
   virtual void computeQpElasticityTensor();

   virtual void assignEulerAngles();

   RealVectorValue _Euler_angles_diff; 
  
   RankFourTensor _Cijkl0;

   RankFourTensor _Cijkl1;

   const VariableValue & _c;
   
   VariableName _c_name;

   MaterialProperty<RankFourTensor> & _delasticity_tensor_dc;

   const ElementPropertyReadFile * const _read_prop_user_object;  

   MaterialProperty<RealVectorValue> & _Euler_angles_mat_prop;

   MaterialProperty<RankTwoTensor> & _crysrot_diff;

   RotationTensor _R_diff;

   const Real & _cmax;
   };
