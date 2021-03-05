import time

import numpy as np
from PyBoltz.PyBoltzRun import *

# Set up helper object
PBRun = PyBoltzRun()

# Show list of available gases
print("")
print("PyBoltz, adapted by B. Al. Atoum, A.D. McDonald, and B.J.P. Jones")
print("  from the original FORTRAN code MagBoltz by S. Biagi")

print("")
print("Available gases:")
print("================")
PBRun.ListGases()

# Configure settings for our simulation
MySettings = {'Gases': ['ARGON', 'C2F6'],
              'Fractions': [80, 20],
              'Max_collisions': 4e8,
              'EField_Vcm': 20,
              'Max_electron_energy': 0.0,
              'Temperature_C': 23,
              'Pressure_Torr': 750,
              'BField_Tesla': 0,
              'BField_angle': 0,
              'Angular_dist_model': 2,
              'Enable_penning': 0,
              'Enable_thermal_motion': 1,
              'ConsoleOutputFlag': 1}

# Create empty lists to store outputs
DriftVels = []
DriftVels_err = []
DTs = []
DLs = []
DT1s = []
DL1s = []
DTs_err = []
DLs_err = []
DT1s_err = []
DL1s_err = []

# Run for each E field
EFields = np.arange(20, 220, 20)

print("Running with E fields of: ")
print(EFields)
print("")

t1 = time.time()
for E in EFields:
    print("Running with E Field " + str(E))

    MySettings['EField_Vcm'] = E

    Output = PBRun.Run(MySettings)

    DriftVels.append(Output['Drift_vel'].val[2])
    DriftVels_err.append(Output['Drift_vel'].err[2])

    DTs.append(Output['DT'].val)
    DTs_err.append(Output['DT'].err)

    DLs.append(Output['DL'].val)
    DLs_err.append(Output['DL'].err)

    DT1s.append(Output['DT'].val)
    DT1s_err.append(Output['DT'].err)

    DL1s.append(Output['DL'].val)
    DL1s_err.append(Output['DL'].err)
t2 = time.time()

print('time taken' + str(t2 - t1))

print('')
for ei in range(len(EFields)):
    print("E = " + str(EFields[ei]) + ", " + " V = " + str(DriftVels[ei]) + ", DT = " + str(DTs[ei]) + ", DL = " + str(
        DLs[ei]))
