#pragma once

#include "Material.h"
#include "ElementPropertyReadFile.h"
#include "RankTwoTensor.h"
#include "RotationTensor.h"

class AnisoDiffusivity_GB : public Material
{
public:
  static InputParameters validParams();
  
  AnisoDiffusivity_GB(const InputParameters & parameters);

protected:
    virtual void computeQpProperties() override;

    virtual void assignEulerAngles();

    RealVectorValue _Euler_angles;

    const ElementPropertyReadFile * const _read_prop_user_object;

    MaterialProperty<RealVectorValue> & _Euler_angles_mat_prop;

    MaterialProperty<RankTwoTensor> & _crysrot;

    MaterialProperty<RankTwoTensor> & _Diff_Matrix;

    const VariableValue & _d;

    const VariableValue & _eta_gb;

    RotationTensor _R;

    RankTwoTensor _diffusivity_g;
    
    RankTwoTensor _diffusivity_gb;
};
