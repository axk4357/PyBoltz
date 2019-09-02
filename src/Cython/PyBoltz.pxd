cimport numpy as np
import math
from libc.stdlib cimport malloc, free
from libc.string cimport memset

cdef double drand48(double dummy)

cdef class PyBoltz:
    cdef public:
        double EFieldOverBField
        '''This is a constant that is equal to the electric field / magentic field * 1e-9.'''
        double AngularSpeedOfRotation
        '''This is the angular speed of rotation see cycltron frequency.'''
        double BFieldAngle
        '''This is the angle between the magnetic field and the electric field.'''
        double BFieldMag
        '''This is the magnitude of the magentic field.'''
        double FinalElectronEnergy
        '''This is the upper limit for the electron energy integration.'''
        double ElectronEnergyStep
        '''PyBoltz does the electron energy integration in 4000 steps this variable has the difference in energy between each step.'''
        double ThermalEnergy
        '''This indicates the amount of energy in the gas (it is equal to the Boltzman constant * absolute tempreture).'''
        double RhydbergConst
        '''This is Rydberg constant times hc in eV.'''
        double TemperatureCentigrade
        '''This is the tempreture in degrees Centigrade.'''
        double PressureTorr
        '''This is the pressure in Torr.'''
        double MaxCollisionTime
        '''Maximum collision time. Default is set to 100.'''
        double SmallNumber
        '''This constant is equal to 1e-20. Used to be a small constant.'''
        double InitialElectronEnergy
        '''The lower limit of the electron energy integration.'''
        double AngleFromZ
        '''Collision scattering angle from the Z plane.'''
        double AngleFromX
        '''Angle used to calculate initial direction cosines in the XY plane. Angle from the X axis.'''
        double EField
        '''Electric field [V/cm].'''
        double MaxNumberOfCollisions
        '''Number of the simulated collisions * N.'''
        double IonisationRate
        '''Ionisation rate.'''
        double VelocityX
        '''Drift velocity on the x axis.'''
        double VelocityY
        '''Drift velocity on the y axis.'''
        double VelocityZ
        '''Drift velocity on the z axis.'''
        double VelocityErrorX
        '''Percentage error on the x drift velocity.'''
        double VelocityErrorY
        '''Percentage error on the y drift velocity.'''
        double VelocityErrorZ
        '''Percentage error on the z drift velocity.'''
        double AttachmentRate
        '''Attachment Rate.'''
        double IonisationRateError
        '''Percentage Error for IonisationRate'''
        double AttachmentRateError
        '''Percentage Error for AttachmentRate'''
        double LongitudinalDiffusion
        '''Longitudinal diffusion.'''
        double TransverseDiffusion
        '''Transverse diffusion.'''
        double DiffusionX
        '''Diffusion on the x plane.'''
        double DiffusionY
        '''Diffusion on the y plane.'''
        double DiffusionZ
        '''Diffusion on the z plane.'''
        double DiffusionYZ
        '''Diffusion on the yz plane.'''
        double DiffusionXY
        '''Diffusion on the xy plane.'''
        double DiffusionXZ
        '''Diffusion on the xz plane.'''
        double ErrorDiffusionX
        '''Percentage error for DIFXX.'''
        double ErrorDiffusionY
        '''Percentage error for DIFYY.'''
        double ErrorDiffusionZ
        '''Percentage error for DIFZZ.'''
        double ErrorDiffusionYZ
        '''Percentage error for DIFYZ.'''
        double ErrorDiffusionXY
        '''Percentage error for DIFXY.'''
        double ErrorDiffusionXZ
        '''Percentage error for DIFXZ.'''
        double MaximumCollisionTime
        '''This variable is used to store the maximum collision time in the simulation.'''
        double MeanElectronEnergyError
        '''Percentage error for AVE.'''
        double MeanElectronEnergy
        '''Mean electron energy.'''
        double X
        '''Variable used to represent the x position in the simulation.'''
        double Y
        '''Variable used to represent the y position in the simulation.'''
        double Z
        '''Variable used to represent the z position in the simulation.'''
        double LongitudinalDiffusionError
        '''Percentage for DIFLN.'''
        double TransverseDiffusionError
        '''Percentage for DIFTR.'''
        double TemperatureKelvin
        '''Absolute tempreture in Kelvin.'''
        double ALPP
        '''Variable used to represent the ionisation rate.'''
        double ATTP
        '''Variable used to represent the attachement rate.'''
        double CONST1
        '''Constant that is equal to AWB / 2 * 1e-9.'''
        double CONST2
        '''Constant that is equal to CONST1 * 1e-2.'''
        double CONST3
        '''Constant that is equal to sqrt(0.2 * AWB) * 1e-9.'''
        #TODO:find ALOSCH
        double CONST4
        '''Constant that is equal to CONST3 * ALOSCH * 1e-15.'''
        double CONST5
        '''Constant that is equal to CONST3 / 2.'''
        double TCFMX
        '''Sum of the maximum collision frequency of each gas.'''
        double EnableThermalMotion
        '''Variable used to indicate wethier to include thermal motion or not.'''
        double PresTempCor
        '''Variable used to calculate the correlation constant between the pressure and tempreture. PresTempCor=ABZERO*TORR/(ATMOS*(ABZERO+TEMPC)*100.0D0).'''
        double FAKEI
        double AN
        '''Variable that is equal to 100 * PresTempCor * ALOSCH. Which is the number of molecules/cm^3.'''
        double VAN
        '''Variable that is equal to 100 * PresTempCor * CONST4 * 1e15'''
        double TimeSum
        '''Variable used to calculate the sum of the collision times in the simulation.'''
        double RSTART
        '''Random number generator seed. Not used at the moment.'''
        long long NumberOfGases
        '''Number of gases in the mixture.'''
        long long NSTEP
        '''Steps for the electron energy integration.'''
        long long WhichAngularModel
        '''Variable used to indicate the type of the elastic angular distribtions.'''
        long long EnablePenning
        '''Variable used to indicate the inclusion of penning effects. '''
        long long AnisotropicDetected
        '''Anisotropic flag used if anisotropic scattering data is detected.'''
        long long IELOW
        '''Flag used to indicate if the energy limit has been crossed.'''
        long long Decor_NCOLM
        long long Decor_NCORLN
        '''Long decorrelation length'''
        long long Decor_NCORST
        '''Long decorrelation step.'''
        long long NNULL
        '''Number of null collisions.'''
        long long IFAKE
        '''Fake ionisation counter.'''
        long long ITMAX
        '''Number of samples to be taken in the Monte functions.'''
        long long NSCALE
        '''Constant equal to 40000000.'''
        double NESST[9]
        double DENSY[4000]
        double SPEC[4000]
        '''Number of collisions in the Ith energy step.'''
        double TIME[300]
        '''Number of collisions in the Ith time step.'''
        double ICOLL[6][5]
        '''Number of collisions for Ith gas at the Jth type.'''
        double ICOLNN[6][10]
        '''Null scatter sum for the Ith gas and the Jth location.'''
        double ICOLN[6][290]
        double AMGAS[6]
        double VTMB[6]
        '''Maxwell Boltzman velocity factor for each gas component.'''
        double TCFMXG[6]
        '''Fraction of the maximum collision frequency of each gas over the sum of the maximum collision frequencies of all the gases.'''
        double GasIDs[6]
        '''Array used to store the number of the 6 gases in the mixture.'''
        double GasFractions[6]
        '''Array used to store the percentage of each gas in the mixture.'''
        double ANN[6]
        '''Array used to calculate the number of molecules/cm^3 for each gas.'''
        double VANN[6]
        '''Array used to calculate the VAN for each gas.'''
        double QSUM[4000], QEL[4000], QSATT[4000], ES[4000]
        double E[4000]
        '''Energy ar each energy step.'''
        double EROOT[4000]
        '''The square root of each energy step.'''
        double QTOT[4000], QREL[4000], QINEL[4000], FCION[4000], FCATT[4000], IFAKET[8], IFAKED[9], RNMX[9], LAST[6]
        double NIN[6]
        '''Number of momentum cross section data points for types other than attachment and ionisation.'''
        double IPLAST[6]
        '''Number of momentum cross section data points for each gas.'''
        double ISIZE[6]
        double TCFMAX[6]
        '''Maximum value of collision frequency for each gas.'''
        double NPLAST[6]
        '''Number of momentum cross section data points for null collisions.'''
        double INDEX[6][290], NC0[6][290], EC0[6][290], NG1[6][290], EG1[6][290], NG2[6][290], EG2[6][290], WKLM[6][290], EFL[6][290], EIN[6][290], IARRY[6][290], RGAS[6][290], IPN[6][290], WPL[6][290], QION[6][4000], QIN[6][250][4000], LIN[6][250], ALIN[6][250]
        double CF[6][4000][290]
        '''Collision frequency for each gas at every energy step for every data point.'''
        double TCF[6][4000]
        '''Total collision frequency for each gas at every energy step.'''
        double PENFRA[6][3][290]
        double CFN[6][4000][10]
        '''Null collision frequency for each gas at every energy step for every data point.'''
        double TCFN[6][4000]
        '''Total null collision frequency for each gas at every energy step.'''
        double SCLENUL[6][10], PSCT[6][4000][290], ANGCT[6][4000][290]
        double TransverseDiffusion1
        '''Transverse diffusion in microns/cm^0.5.'''
        double TransverseDiffusion1Error
        '''Percentage error for DT1'''
        double LongitudinalDiffusion1
        '''Longitudinal diffusion in microns/cm^0.5'''
        double LongitudinalDiffusion1Error
        '''Percentage error for DL1'''
        double IPLASTNT,ISIZENT
        double PIR2
        int ConsoleOutputFlag
        '''Flag used to stop console printouts'''
        double MeanCollisionTime
        '''Mean collision time. Calculated using a moving average filter where it is equal to 0.9 * MeanCollisionTime + 0.1 * NewTime'''
        # Variables and arrays used when the thermal motion is not included.
        double CFNT[4000][960],EINNT[960],TCFNT[4000],IARRYNT[960],RGASNT[960],IPNNT[960],WPLNT[960],PENFRANT[3][960],TCFMAXNT[8]
        double CFNNT[4000][60],TCFNNT[4000],SCLENULNT[60],PSCTNT[4000][960],ANGCTNT[4000][960],INDEXNT[960],NC0NT[960],EC0NT[960]
        double NG1NT[960],EG1NT[960],NG2NT[960],EG2NT[960],WKLMNT[960],EFLNT[960]
        double ICOLLNT[30],ICOLNNT[960],ICOLNNNT[60]
        double NPLASTNT
