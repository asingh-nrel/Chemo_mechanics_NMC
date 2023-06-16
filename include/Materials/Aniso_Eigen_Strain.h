 #pragma once
  
 #include "ComputeEigenstrainBase.h"
 #include "RotationTensor.h" 
 #include "RankTwoTensor.h"
  
 class Aniso_Eigen_Strain : public ComputeEigenstrainBase
 {
 public:
   static InputParameters validParams();
  
   Aniso_Eigen_Strain(const InputParameters & parameters);
  
 protected:
   virtual void computeQpEigenstrain();
  
   virtual void assignEulerAngles();

   RealVectorValue _Euler_angles_eigen;

   const MaterialProperty<Real> & _prefactor;
  
   const ElementPropertyReadFile * const _read_prop_user_object;

   MaterialProperty<RealVectorValue> & _Euler_angles_mat_prop;

   MaterialProperty<RankTwoTensor> & _crysrot_eigen;

   MaterialProperty<RankTwoTensor> & _Expansion_Matrix;

   RotationTensor _R_eigen;

   RankTwoTensor _eigen_base_tensor;
 };
