# checking for small deformation
# A single element is stretched by "ep" in the z and x directions
# This causes the return direction to be along the hypersurface sigma_I = sigma_II
# tensile_strength is set to 1Pa, tip_smoother = 0, edge_smoother = 25degrees
# Then A + B + C = 0.609965
#
# The trial stress is (la, 0, la), with mean stress 2la/3, and bar(sigma)=sqrt(secondInvariant)=la/sqrt(3)
# If this sits on the yield surface then
# 2la/3 + la*K/sqrt(3) - 1 = 0
# So la = 0.9815.  Therefore, with young's modulus = 2MPa, we need "ep" = 0.9815/4.  I set
# "ep" = 0.25 and observe a tiny amount of yielding


[Mesh]
  type = GeneratedMesh
  dim = 3
  nx = 1
  ny = 1
  nz = 1
  xmin = -0.5
  xmax = 0.5
  ymin = -0.5
  ymax = 0.5
  zmin = -0.5
  zmax = 0.5
[]


[Variables]
  [./disp_x]
  [../]
  [./disp_y]
  [../]
  [./disp_z]
  [../]
[]

[Kernels]
  [./TensorMechanics]
    disp_x = disp_x
    disp_y = disp_y
    disp_z = disp_z
  [../]
[]


[BCs]
  [./x]
    type = FunctionPresetBC
    variable = disp_x
    boundary = 'front back'
    function = '0.25E-6*x'
  [../]
  [./y]
    type = FunctionPresetBC
    variable = disp_y
    boundary = 'front back'
    function = '0'
  [../]
  [./z]
    type = FunctionPresetBC
    variable = disp_z
    boundary = 'front back'
    function = '0.25E-6*z'
  [../]
[]

[AuxVariables]
  [./stress_xx]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./stress_xy]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./stress_xz]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./stress_yy]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./stress_yz]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./stress_zz]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./yield_fcn]
    order = CONSTANT
    family = MONOMIAL
  [../]
[]

[AuxKernels]
  [./stress_xx]
    type = RankTwoAux
    rank_two_tensor = stress
    variable = stress_xx
    index_i = 0
    index_j = 0
  [../]
  [./stress_xy]
    type = RankTwoAux
    rank_two_tensor = stress
    variable = stress_xy
    index_i = 0
    index_j = 1
  [../]
  [./stress_xz]
    type = RankTwoAux
    rank_two_tensor = stress
    variable = stress_xz
    index_i = 0
    index_j = 2
  [../]
  [./stress_yy]
    type = RankTwoAux
    rank_two_tensor = stress
    variable = stress_yy
    index_i = 1
    index_j = 1
  [../]
  [./stress_yz]
    type = RankTwoAux
    rank_two_tensor = stress
    variable = stress_yz
    index_i = 1
    index_j = 2
  [../]
  [./stress_zz]
    type = RankTwoAux
    rank_two_tensor = stress
    variable = stress_zz
    index_i = 2
    index_j = 2
  [../]
  [./yield_fcn_auxk]
    type = MaterialStdVectorAux
    property = plastic_yield_function
    index = 0
    variable = yield_fcn
  [../]
[]

[Postprocessors]
  [./s_xx]
    type = PointValue
    point = '0 0 0'
    variable = stress_xx
  [../]
  [./s_xy]
    type = PointValue
    point = '0 0 0'
    variable = stress_xy
  [../]
  [./s_xz]
    type = PointValue
    point = '0 0 0'
    variable = stress_xz
  [../]
  [./s_yy]
    type = PointValue
    point = '0 0 0'
    variable = stress_yy
  [../]
  [./s_yz]
    type = PointValue
    point = '0 0 0'
    variable = stress_yz
  [../]
  [./s_zz]
    type = PointValue
    point = '0 0 0'
    variable = stress_zz
  [../]
  [./f]
    type = PointValue
    point = '0 0 0'
    variable = yield_fcn
  [../]
[]

[UserObjects]
  [./ts]
    type = TensorMechanicsHardeningConstant
    value = 1
  [../]
  [./mc]
    type = TensorMechanicsPlasticTensile
    tensile_strength = ts
    yield_function_tolerance = 1E-6
    tensile_tip_smoother = 0.0
    internal_constraint_tolerance = 1E-5
  [../]
[]

[Materials]
  [./mc]
    type = FiniteStrainMultiPlasticity
    block = 0
    disp_x = disp_x
    disp_y = disp_y
    disp_z = disp_z
    fill_method = symmetric_isotropic
    C_ijkl = '0 2.0E6'
    ep_plastic_tolerance = 1E-5
    plastic_models = mc
    debug_fspb = 1
  [../]
[]


[Executioner]
  end_time = 1
  dt = 1
  type = Transient
[]


[Outputs]
  file_base = small_deform3
  output_initial = true
  exodus = false
  print_linear_residuals = true
  print_perf_log = true
  [./csv]
    type = CSV
    interval = 1
  [../]
[]
