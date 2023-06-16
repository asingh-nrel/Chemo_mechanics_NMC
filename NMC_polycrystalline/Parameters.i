
#=====================
# Meshing parameters
#=====================
Scale_x = 1.1e-05  # m
Scale_y = 1.1e-05  # m


#=====================
# Diffusion parameters
#=====================
cmax = 31370.0  # mol/m^3
cmin = 8567.1 # mol/m^3
ki = 1.0
Dx = 1e-13
Dy = 1e-15


#======================
# Fracture parameters
#======================
Gc_grains = 2.5   # J/m^2
Gc_gb = 1       # J/m^2
Gc_pmi = 1      # J/m^2
lc_grains = 2.75e-07  # m

Gc_matrix = 2.7842 # J/m^2
lc_matrix = 2.75e-07  # m

visco_param = 1.0e-06


#======================
# Elasticity parameters
#======================
lame_lambda_particle = 79.6154e9
lame_mu_particle = 53.0769e9

lame_lambda_matrix = 10962000000
lame_mu_matrix = 7307700000

omega_x_particle = -1.499e-6
omega_y_particle = 1.446e-6

omega_x_matrix = 0
omega_y_matrix = 0


#=======================
# Material constants
#=======================
Density = 4210000 # g/m^3
Faraday_const = 96485.3415
Th_capacity = 202   # mAh/cm^2


Particle_diameter = 10e-6 # m
C_rate = 1
output_frequency = 50
total_time = 4000

delta_t_1 = 1
delta_t_2 = 0.5
