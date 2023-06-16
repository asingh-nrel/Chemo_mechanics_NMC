[GlobalParams]
displacements = 'disp_x disp_y'
[]

[Variables]
 [./diffused]
  order = FIRST
  family = LAGRANGE
  block='0   1   2   3   4   5   6   7   8   9  10  11  12  13  14  15  16  17  18  19  20  21  22  23  24  25  26  27  28  29  30  31  32  33  34  35  36  37  38  39  40  41  42  43  44  45  46  47  48  49  50  51  52  53  54  55  56  57  58  59  60  61  62  63  64  65  66  67  68  69  70  71  72  73  74  75  76  77  78  79  80  81  82'
 [../]

 [./damage]
  order = FIRST
  family = LAGRANGE
 [../]

 [./disp_x]
  order = FIRST
  family = LAGRANGE
 [../]

 [./disp_y]
  order = FIRST
  family = LAGRANGE
 [../]
[]

[ICs]
 [./ic_particle]
  type = ConstantIC
  variable = diffused
  value=${cmax}
  block='0   1   2   3   4   5   6   7   8   9  10  11  12  13  14  15  16  17  18  19  20  21  22  23  24  25  26  27  28  29  30  31  32  33  34  35  36  37  38  39  40  41  42  43  44  45  46  47  48  49  50  51  52  53  54  55  56  57  58  59  60  61  62  63  64  65  66  67  68  69  70  71  72  73  74  75  76  77  78  79  80  81  82'
 [../]
[]

[AuxVariables]
 [./eta_gb]
  order = FIRST
  family = LAGRANGE
 [../]

 [./eta_pmi]
  order = FIRST
  family = LAGRANGE
 [../]

 [./bounds_dummy_d]
  order = FIRST
  family = LAGRANGE
 [../]

 [./sigma_h]
  family = MONOMIAL
  order = CONSTANT
 [../]

 [./von_mises]
  family = MONOMIAL
  order = CONSTANT
 [../]

 [./stress_xx]
     order = FIRST 
    family = MONOMIAL   
 [../]

 [./stress_yy]
     order = FIRST 
    family = MONOMIAL   
 [../]

 [./stress_zz]
     order = FIRST 
    family = MONOMIAL   
  [../]
[]


[Kernels]
 [./diffusion_particle]
  type = Concentration
  variable = diffused
  cmax=${cmax}
  ki=${ki}
  block='0   1   2   3   4   5   6   7   8   9  10  11  12  13  14  15  16  17  18  19  20  21  22  23  24  25  26  27  28  29  30  31  32  33  34  35  36  37  38  39  40  41  42  43  44  45  46  47  48  49  50  51  52  53  54  55  56  57  58  59  60  61  62  63  64  65  66  67  68  69  70  71  72  73  74  75  76  77  78  79  80  81  82'
 [../]

 [./euler_particle]
  type = TimeDerivative
  variable = diffused
  block='0   1   2   3   4   5   6   7   8   9  10  11  12  13  14  15  16  17  18  19  20  21  22  23  24  25  26  27  28  29  30  31  32  33  34  35  36  37  38  39  40  41  42  43  44  45  46  47  48  49  50  51  52  53  54  55  56  57  58  59  60  61  62  63  64  65  66  67  68  69  70  71  72  73  74  75  76  77  78  79  80  81  82'
 [../]

 [./ACbulk]
  type = AllenCahn
  variable = damage
  f_name = F
 [../]

 [./ACInterfaceCleavageFracture]
  type = ACInterface # Anisotropic_PF_Fracture
  variable = damage
  kappa_name = kappa_op
 [../]

 [./dcdt]
  type = TimeDerivative
  variable = damage
 [../]

 [./solid_x]
  type = PhaseFieldFractureMechanicsOffDiag
  variable = disp_x
  component = 0
  c = damage
 [../]

 [./solid_y]
  type = PhaseFieldFractureMechanicsOffDiag
  variable = disp_y
  component = 1
  c = damage
 [../]

 [./off_disp]
  type = AllenCahnElasticEnergyOffDiag
  variable = damage
  displacements = 'disp_x disp_y'
  mob_name = L
 [../]
[]

[Modules/TensorMechanics/Master]
 [all]
  add_variables = true
  strain = SMALL
  generate_output = 'strain_xx strain_yy'
  eigenstrain_names = eigenstrain
  planar_formulation = PLANE_STRAIN
 []
[]

[UserObjects]
 [./euler_angle_read]
   type = PropertyReadFile
   prop_file_name = 'Radial_Crystal_Orientation_60.txt'
   nprop = 3
   read_type = block
   nblock=84
 [../]
 [./terminate_condition]
  type = Terminator
  expression = 'avg_surface_concentration < ${cmin}'
  message = "Reached reference surface concentration"
  execute_on = TIMESTEP_END
 [../]
[]

[Materials]
 [./pfbulkmat_particle]
  type = GenericConstantMaterial
  prop_names = 'gc_prop_b gc_prop_gb gc_prop_pmi l visco'
  prop_values='${Gc_grains}           ${Gc_gb}           ${Gc_pmi}       ${lc_grains}       ${visco_param}'
  block='0   1   2   3   4   5   6   7   8   9  10  11  12  13  14  15  16  17  18  19  20  21  22  23  24  25  26  27  28  29  30  31  32  33  34  35  36  37  38  39  40  41  42  43  44  45  46  47  48  49  50  51  52  53  54  55  56  57  58  59  60  61  62  63  64  65  66  67  68  69  70  71  72  73  74  75  76  77  78  79  80  81  82'
 [../]

 [./pfbulkmat_matrix]
  type = GenericConstantMaterial
  prop_names = 'gc_prop l visco'
  prop_values='${Gc_matrix}        ${lc_matrix}       ${visco_param}'
  block='83'
 [../]

 [./define_gc_prop_particle]
  type = ParsedMaterial
  material_property_names = 'gc_prop_b gc_prop_gb gc_prop_pmi'
  f_name = gc_prop
  args = 'eta_gb eta_pmi'
  function = '(1-eta_gb)*(1-eta_gb)*(1-eta_pmi)*(1-eta_pmi)*gc_prop_b + (1-(1-eta_gb)*(1-eta_gb))*gc_prop_gb + (1-(1-eta_pmi)*(1-eta_pmi))*gc_prop_pmi'
  block='0   1   2   3   4   5   6   7   8   9  10  11  12  13  14  15  16  17  18  19  20  21  22  23  24  25  26  27  28  29  30  31  32  33  34  35  36  37  38  39  40  41  42  43  44  45  46  47  48  49  50  51  52  53  54  55  56  57  58  59  60  61  62  63  64  65  66  67  68  69  70  71  72  73  74  75  76  77  78  79  80  81  82'
 [../]

 [./diffusivity_tensor_with_Euler_particle]
  type = AnisoDiffusivity
  read_prop_user_object = euler_angle_read
  diffusivity='${Dx}           0           0           0       ${Dy}           0           0           0           0'
  block='0   1   2   3   4   5   6   7   8   9  10  11  12  13  14  15  16  17  18  19  20  21  22  23  24  25  26  27  28  29  30  31  32  33  34  35  36  37  38  39  40  41  42  43  44  45  46  47  48  49  50  51  52  53  54  55  56  57  58  59  60  61  62  63  64  65  66  67  68  69  70  71  72  73  74  75  76  77  78  79  80  81  82'
  d = damage
 [../]

#[./elasticity_tensor_with_Euler_particle]
#type = Aniso_Elasticity_Tensor
#c = diffused
#cmax =  31730
#C1_ijkl='235000000000  127000000000   66000000000  235000000000   66000000000  193000000000   39500000000   39500000000   39500000000'
#C0_ijkl='284000000000   70000000000    5800000000  284000000000    5800000000   12500000000    1600000000    1600000000    1600000000'
#fill_method1 = symmetric9
#fill_method0 = symmetric9
#read_prop_user_object = euler_angle_read
#block='0   1   2   3   4   5   6   7   8   9  10  11  12  13  14  15  16  17  18  19  20  21  22  23  24  25  26  27  28  29  30  31  32  33  34  35  36  37  38  39  40  41  42  43  44  45  46  47  48  49  50  51  52  53  54  55  56  57  58  59  60  61  62  63  64  65  66  67  68  69  70  71  72  73  74  75  76  77  78  79  80  81  82'
#[../]

 [./elasticity_tensor_with_Euler_particle]
  type = ComputeElasticityTensor
  C_ijkl='${lame_lambda_particle} ${lame_mu_particle}'
  fill_method = symmetric_isotropic
  block='0   1   2   3   4   5   6   7   8   9  10  11  12  13  14  15  16  17  18  19  20  21  22  23  24  25  26  27  28  29  30  31  32  33  34  35  36  37  38  39  40  41  42  43  44  45  46  47  48  49  50  51  52  53  54  55  56  57  58  59  60  61  62  63  64  65  66  67  68  69  70  71  72  73  74  75  76  77  78  79  80  81  82'
 [../]

 [./elasticity_tensor_with_Euler_matrix]
  type = ComputeElasticityTensor
  C_ijkl='${lame_lambda_matrix} ${lame_mu_matrix}'
  fill_method = symmetric_isotropic
  block='83'
 [../]

 [./eigen_strain_prefactor_particle]
  type = DerivativeParsedMaterial 
  args = diffused
  f_name = eigen_strain_prefactor
  constant_names = 'c_ref'
  constant_expressions ='${cmax}'
  function = (diffused-c_ref)/3
  block='0   1   2   3   4   5   6   7   8   9  10  11  12  13  14  15  16  17  18  19  20  21  22  23  24  25  26  27  28  29  30  31  32  33  34  35  36  37  38  39  40  41  42  43  44  45  46  47  48  49  50  51  52  53  54  55  56  57  58  59  60  61  62  63  64  65  66  67  68  69  70  71  72  73  74  75  76  77  78  79  80  81  82'
 [../]

 [./eigenstrain_particle]
  type = Aniso_Eigen_Strain
  eigen_base ='${omega_x_particle}           0       0           0  ${omega_y_particle}   0   0   0   0'
  prefactor = eigen_strain_prefactor
  eigenstrain_name = eigenstrain
  read_prop_user_object = euler_angle_read
  block='0   1   2   3   4   5   6   7   8   9  10  11  12  13  14  15  16  17  18  19  20  21  22  23  24  25  26  27  28  29  30  31  32  33  34  35  36  37  38  39  40  41  42  43  44  45  46  47  48  49  50  51  52  53  54  55  56  57  58  59  60  61  62  63  64  65  66  67  68  69  70  71  72  73  74  75  76  77  78  79  80  81  82'
 [../]

 [./eigenstrain_matrix]
  type = Aniso_Eigen_Strain
  eigen_base ='${omega_x_matrix}           0       0      0   ${omega_y_matrix}   0   0   0   0'
  prefactor = 1
  eigenstrain_name = eigenstrain
  read_prop_user_object = euler_angle_read
  block='83'
 [../]

 [./define_mobility]
  type = ParsedMaterial
  material_property_names = 'gc_prop visco'
  f_name = L
  function = '1.0/(gc_prop * visco)'
 [../]

 [./define_kappa]
  type = ParsedMaterial
  material_property_names = 'gc_prop l'
  f_name = kappa_op
  function = 'gc_prop * l'
 [../]

 [./damage_stress]
  type = ComputeLinearElasticPFFractureStress
  c = damage
  E_name = 'elastic_energy'
  D_name = 'degradation'
  F_name = 'local_fracture_energy'
  decomposition_type = stress_spectral
  use_snes_vi_solver = true
 [../]

 [./degradation]
  type = DerivativeParsedMaterial
  f_name = degradation
  args = 'damage'
  function = '(1.0-damage)^2*(1.0 - eta) + eta'
  constant_names       = 'eta'
  constant_expressions = '1.0e-5'
  derivative_order = 2
 [../]

 [./local_fracture_energy]
  type = DerivativeParsedMaterial
  f_name = local_fracture_energy
  args = 'damage'
  material_property_names = 'gc_prop l'
  function = 'damage^2 * gc_prop / 2 / l'
  derivative_order = 2
 [../]

 [./fracture_driving_energy]
  type = DerivativeSumMaterial
  args = 'damage'
  sum_materials = 'elastic_energy local_fracture_energy'
  derivative_order = 2
  f_name = F
 [../]

 [./stress_xx]
  type = RankTwoCartesianComponent
  index_i = 0
  index_j = 0
  rank_two_tensor = stress
  property_name = stress_xx
 [../]

 [./stress_yy]
  type = RankTwoCartesianComponent
  index_i = 1
  index_j = 1
  rank_two_tensor = stress
  property_name = stress_yy
 [../]

 [./stress_zz]
  type = RankTwoCartesianComponent
  index_i = 2
  index_j = 2
  rank_two_tensor = stress
  property_name = stress_zz
 [../]
[]

[AuxKernels]
 [./gethystress]
  type = RankTwoScalarAux
  rank_two_tensor = stress
  variable = sigma_h
  scalar_type = Hydrostatic
 [../]

 [./vonstress]
  type = RankTwoScalarAux
  rank_two_tensor = stress
  variable = von_mises
  scalar_type = VonMisesStress
 [../]

 [./stress_xx]
  type = MaterialRealAux
  property = stress_xx
  variable = stress_xx
 [../]

 [./stress_yy]
  type = MaterialRealAux
  property = stress_yy
  variable = stress_yy
 [../]

 [./stress_zz]
  type = MaterialRealAux
  property = stress_zz
  variable = stress_zz
 [../]
[]

[Functions]
 [./Particle_mass_surf_area]
  type = ParsedFunction
  value = (0.25*pi*Particle_diameter*Particle_diameter*1)*Density/(pi*Particle_diameter)  # mass (grams)/fluxarea (m^2)
  vars = 'Density Particle_diameter'
  vals='${Density}    ${Particle_diameter}'
 [../]

 [./FluxVal_temp]
  type = ParsedFunction
  value = In_Out_Switch*(Th_Cap/1000)*C_Rate/Faraday
  vars = 'In_Out_Switch C_Rate          Faraday                Th_Cap'   # theoretical_capacity (Ah/g) *crate (1/h)/F(As/mol)
  vals='-1             ${C_rate}    ${Faraday_const}    ${Th_capacity}'
 [../]

 [./FluxVal]
  type = CompositeFunction
  functions = 'Particle_mass_surf_area FluxVal_temp'
 [../]

 [./dts]
  type = PiecewiseLinear
  x = '0 1000 1001 4000'
  y = '${delta_t_1} ${delta_t_1} ${delta_t_2} ${delta_t_2}'
 [../]
[]

[BCs]
 [./flux_bc]
  type = FunctionNeumannBC
  variable = diffused
  boundary = 'PMI'
  function = FluxVal
 [../]

 [corner_x]
  type = DirichletBC
  variable = disp_x
  boundary = 'left_bottom left_top right_bottom right_top'
  value = 0
 []

 [corner_y]
  type = DirichletBC
  variable = disp_y
  boundary = 'left_bottom left_top right_bottom right_top'
  value = 0
 []

 [./Periodic]
  [./bottom_top_disp_xy_periodic]
   variable = 'disp_x disp_y'
   primary ='bottom'
   secondary = 'top'
   translation='0     ${Scale_y}           0'
  [../]
  [./left_right_disp_xy_periodic]
   variable = 'disp_x disp_y'
   primary ='left'
   secondary = 'right'
   translation='${Scale_x}           0           0'
  [../]
 [../]
[]

[Bounds]
 [./d_upper_bound]
  type = ConstantBoundsAux
  variable = bounds_dummy_d
  bounded_variable = damage
  bound_type = upper
  bound_value = 1.0
 [../]
 [./d_lower_bound]
  type = VariableOldValueBoundsAux
  variable = bounds_dummy_d
  bounded_variable = damage
  bound_type = lower
 [../]
[]

[Preconditioning]
 [./smp]
  type = SMP
  full = true
 [../]
[]

[Postprocessors]
 [./avg_surface_concentration]
  type = SideAverageValue
  variable = diffused
  boundary = 'PMI'
 [../]

 [./ave_damage_particle]
  type = ElementAverageValue  # Volumetric_average
  variable = damage
  block='0   1   2   3   4   5   6   7   8   9  10  11  12  13  14  15  16  17  18  19  20  21  22  23  24  25  26  27  28  29  30  31  32  33  34  35  36  37  38  39  40  41  42  43  44  45  46  47  48  49  50  51  52  53  54  55  56  57  58  59  60  61  62  63  64  65  66  67  68  69  70  71  72  73  74  75  76  77  78  79  80  81  82'
 [../]

 [./ave_damage_matrix]
  type = ElementAverageValue  # Volumetric_average
  variable = damage
  block='83'
 [../]

 [./ave_damage_all]
  type = ElementAverageValue  # Volumetric_average
  variable = damage
 [../]

 [./ave_conc_particle]
  type = ElementAverageValue  # Volumetric_average
  variable = diffused
  block='0   1   2   3   4   5   6   7   8   9  10  11  12  13  14  15  16  17  18  19  20  21  22  23  24  25  26  27  28  29  30  31  32  33  34  35  36  37  38  39  40  41  42  43  44  45  46  47  48  49  50  51  52  53  54  55  56  57  58  59  60  61  62  63  64  65  66  67  68  69  70  71  72  73  74  75  76  77  78  79  80  81  82'
 [../]

 [./max_damage_value_particle]
  type = NodalExtremeValue
  variable = damage
  block='0   1   2   3   4   5   6   7   8   9  10  11  12  13  14  15  16  17  18  19  20  21  22  23  24  25  26  27  28  29  30  31  32  33  34  35  36  37  38  39  40  41  42  43  44  45  46  47  48  49  50  51  52  53  54  55  56  57  58  59  60  61  62  63  64  65  66  67  68  69  70  71  72  73  74  75  76  77  78  79  80  81  82'
 [../]

 [./max_damage_value_matrix]
  type = NodalExtremeValue
  variable = damage
  block='83'
 [../]

 [./max_damage_value_all]
  type = NodalExtremeValue
  variable = damage
 [../]

 [./avg_pmi_damage]
  type = SideAverageValue
  variable = damage
  boundary = 'PMI'
 [../] 

 [./ave_vonmises_particle]
  type = ElementAverageValue  # Volumetric_average
  variable = von_mises
  block='0   1   2   3   4   5   6   7   8   9  10  11  12  13  14  15  16  17  18  19  20  21  22  23  24  25  26  27  28  29  30  31  32  33  34  35  36  37  38  39  40  41  42  43  44  45  46  47  48  49  50  51  52  53  54  55  56  57  58  59  60  61  62  63  64  65  66  67  68  69  70  71  72  73  74  75  76  77  78  79  80  81  82'
 [../]

 [./ave_von_mises_matrix]
  type = ElementAverageValue  # Volumetric_average
  variable = von_mises
  block='83'
 [../]

 [./ave_von_mises_all]
  type = ElementAverageValue  # Volumetric_average
  variable = von_mises
 [../]
[]

[Executioner]
 type = Transient
 scheme = bdf2

# [./TimeIntegrator]
#    # type = ImplicitEuler
#     type = BDF2
#    # type = CrankNicolson
#    # type = ImplicitMidpoint
#    # type = LStableDirk2
#    # type = LStableDirk3
#    # type = LStableDirk4
#    # type = AStableDirk4
#    #
#    # Explicit methods
#    # type = ExplicitEuler
#    # type = ExplicitMidpoint
#    # type = Heun
#    # type = Ralston
#  [../]

  solve_type = NEWTON
  petsc_options_iname = '-pc_type -pc_factor_mat_solver_package -snes_type'
  petsc_options_value = 'lu       superlu_dist                  vinewtonrsls'
  automatic_scaling = true

  end_time = ${total_time}

  l_max_its = 100
  nl_max_its = 100
  nl_abs_tol = 1e-6
  l_tol = 1e-04

 [./TimeStepper]
  type = FunctionDT
  function = dts
  min_dt = 0.1
 [../]
[]

[Outputs]
 execute_on = 'initial timestep_end'
 interval = ${output_frequency}
 exodus = true
 csv = true
 file_base = /projects/xfcbatt/asingh/NMC_test

 [./my_checkpoint]
  type = Checkpoint
  num_files = 10
  interval = 100
 [../]
[]

[MultiApps]
 [full_solve]
  type = FullSolveMultiApp
  execute_on = initial
  positions = '0 0 0'
  input_files = Diffused_Interface_Sub_APP.i
  clone_master_mesh = true
 []
[]

[Transfers]
 [./from_eta_gb]
  type = MultiAppCopyTransfer
  source_variable = eta_gb
  variable = eta_gb
  from_multi_app = full_solve
 [../]

 [./from_eta_pmi]
  type = MultiAppCopyTransfer
  source_variable = eta_pmi
  variable = eta_pmi
  from_multi_app = full_solve
 [../]
[]