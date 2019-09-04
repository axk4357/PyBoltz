from PyBoltz cimport PyBoltz
from libc.math cimport sin, cos, acos, asin, log, sqrt,pow
from libc.string cimport memset
from PyBoltz cimport drand48
from MBSorts cimport MBSortT
import numpy as np
cimport numpy as np
from libc.stdlib cimport malloc, free
import cython


@cython.cdivision(True)
@cython.boundscheck(False)
@cython.wraparound(False)
cdef double random_uniform(double dummy):
    cdef double r = drand48(dummy)
    return r

@cython.cdivision(True)
@cython.boundscheck(False)
@cython.wraparound(False)
cdef void GERJAN(double RandomSeed, double *RNMX):
    cdef double RAN1, RAN2, TWOPI
    cdef int J
    for J in range(0, 5, 2):
        RAN1 = random_uniform(RandomSeed)
        RAN2 = random_uniform(RandomSeed)
        TWOPI = 2.0 * np.pi
        RNMX[J] = sqrt(-1*log(RAN1)) * cos(RAN2 * TWOPI)
        RNMX[J + 1] = sqrt(-1*log(RAN1)) * sin(RAN2 * TWOPI)


@cython.cdivision(True)
@cython.boundscheck(False)
@cython.wraparound(False)
cpdef run(PyBoltz Object):
    """
    This function is used to calculates collision events and updates diffusion and velocity.Background gas motion included at temp =  TemperatureCentigrade.

    This function is used when the magnetic field is perpendicular to the electric field in the z direction.    
    
    The object parameter is the PyBoltz object to have the output results and to be used in the simulation.
    """
    Object.VelocityX = 0.0
    Object.VelocityErrorX = 0.0
    Object.X = 0.0
    Object.Y = 0.0
    Object.Z = 0.0
    Object.DiffusionXZ = 0.0
    Object.DiffusionXY = 0.0
    cdef long long I, ID,  NCOL, IEXTRA, IMBPT, K, J, J2M, J1, J2, GasIndex, IE, IT, KDUM, IPT, JDUM,NCOLDM
    cdef double ST1, RandomSeed,ST2, SUME2, SUMXX, SUMYY, SUMZZ, SUMVX, SUMVY, ZOLD, STOLD, ST1OLD, ST2OLD, SZZOLD, SXXOLD, SYYOLD, SVXOLD, SVYOLD, SME2OLD, TDASH
    cdef double ABSFAKEI, DCZ1, DCX1, DCY1, CX1, CY1, CZ1, BP, F1, F2, F4, DCX2, DCY2, DCZ2, CX2, CY2, CZ2, DZCOM, DYCOM, DXCOM, THETA0,
    cdef double  E1, CONST9, CONST10, AP, CONST6, R2, R1, VGX, VGY, VGZ, VEX, VEY, VEZ, EOK, R5, TEST1, TEST2, TEST3, CONST11
    cdef double T2, A, B, CONST7, R3, S1, EI, R9, EXTRA, RAN, R31, F3, EPSI, R4, PHI0, F8, F9, ARG1, D, Q, F6, U, CSQD, F5, VXLAB, VYLAB, VZLAB
    cdef double TWZST, TAVE, T2WZST, T2AVE, TXXST, TYYST, T2XXST, T2YYST, TZZST, T2ZZST, ANCATT, ANCION, E,SUMYZ,SUMLS,SUMTS
    cdef double SYZOLD,SLNOLD,STROLD,EBAROLD,EF100, EBAR
    cdef double NumSamples
    cdef double *STO, *XST, *YST, *ZST, *WZST, *AVEST, *DFZZST, *DFYYST, *DFXXST,*DFYZST,*DFLNST,*DFTRNST,*WYZST, *DFTRST
    STO = <double *> malloc(2000000 * sizeof(double))
    memset(STO, 0, 2000000 * sizeof(double))
    XST = <double *> malloc(2000000 * sizeof(double))
    memset(XST, 0, 2000000 * sizeof(double))

    YST = <double *> malloc(2000000 * sizeof(double))
    memset(YST, 0, 2000000 * sizeof(double))

    ZST = <double *> malloc(2000000 * sizeof(double))
    memset(ZST, 0, 2000000 * sizeof(double))

    WZST = <double *> malloc(10 * sizeof(double))
    memset(WZST, 0, 10 * sizeof(double))

    WYST = <double *> malloc(10 * sizeof(double))
    memset(WYST, 0, 10 * sizeof(double))

    AVEST = <double *> malloc(10 * sizeof(double))
    memset(AVEST, 0, 10 * sizeof(double))

    DFZZST = <double *> malloc(10 * sizeof(double))
    memset(DFZZST, 0, 10 * sizeof(double))

    DFYYST = <double *> malloc(10 * sizeof(double))
    memset(DFYYST, 0, 10 * sizeof(double))

    DFXXST = <double *> malloc(10 * sizeof(double))
    memset(DFXXST, 0, 10 * sizeof(double))

    DFYZST = <double *> malloc(10 * sizeof(double))
    memset(DFYZST, 0, 10 * sizeof(double))

    DFLNST = <double *> malloc(10 * sizeof(double))
    memset(DFLNST, 0, 10 * sizeof(double))

    DFTRNST = <double *> malloc(10 * sizeof(double))
    memset(DFTRNST, 0, 10 * sizeof(double))

    DFTRST  = <double *> malloc(10 * sizeof(double))
    memset(DFTRST, 0, 10 * sizeof(double))

    Object.ErrorDiffusionXZ = 0.0
    Object.ErrorDiffusionXY = 0.0
    Object.TimeSum = 0.0
    ST1 = 0.0
    ST2 = 0.0
    SUMXX = 0.0
    SUMYY = 0.0
    SUMZZ = 0.0
    SUMYZ = 0.0
    I=0
    SUMLS = 0.0
    SUMTS = 0.0
    SUMVX = 0.0
    ZOLD = 0.0
    YOLD = 0.0
    STOLD = 0.0
    ST1OLD = 0.0
    ST2OLD = 0.0
    SZZOLD = 0.0
    SXXOLD = 0.0
    SYYOLD = 0.0
    SYZOLD = 0.0
    SVXOLD = 0.0
    SLNOLD = 0.0
    STROLD = 0.0
    EBAROLD = 0.0
    EF100 = Object.EField * 100
    E1 = Object.InitialElectronEnergy
    CONST9 = Object.CONST3 * 0.01
    CONST10 = CONST9 ** 2
    NumSamples = 10
    ID = 0

    NCOL = 0
    IEXTRA = 0
    cdef double ** TEMP = <double **> malloc(6 * sizeof(double *))
    for i in range(6):
        TEMP[i] = <double *> malloc(4000 * sizeof(double))
    for K in range(6):
        for J in range(4000):
            TEMP[K][J] = Object.TCF[K][J] + Object.TCFN[K][J]
    ABSFAKEI = Object.FAKEI
    Object.IFAKE = 0

    GERJAN(Object.RandomSeed,  Object.RNMX)
    IMBPT = 0
    TDASH = 0.0
    F4 = 2 * acos(-1)
    # INITIAL DIRECTION COSINES
    DCZ1 = cos(Object.AngleFromZ)
    DCX1 = sin(Object.AngleFromZ) * cos(Object.AngleFromX)
    DCY1 = sin(Object.AngleFromZ) * sin(Object.AngleFromX)
    # INITIAL VELOCITY
    VTOT = CONST9 * sqrt(E1)
    CX1 = DCX1 * VTOT
    CY1 = DCY1 * VTOT
    CZ1 = DCZ1 * VTOT
    RandomSeed = Object.RandomSeed
    J2M = <long long>(Object.MaxNumberOfCollisions / NumSamples)
    if Object.ConsoleOutputFlag:
        print('{:^12s}{:^12s}{:^10s}{:^10s}{:^10s}{:^10s}{:^10s}{:^10s}{:^10s}'.format("Velocity Z", "Velocity Y", "Energy",
                                                                       "DIFXX", "DIFYY", "DIFZZ", "DIFYZ","DIFLNG","DIFTRN"))
    for J1 in range(int(NumSamples)):
        for J2 in range(int(J2M)):
            while True:
                R1 = random_uniform(RandomSeed)
                T = -1 * log(R1) / Object.MaxCollisionFreqTotal + TDASH
                TDASH = T
                Object.MeanCollisionTime = 0.9 * Object.MeanCollisionTime + 0.1 * T
                WBT = Object.AngularSpeedOfRotation * T
                COSWT = cos(WBT)
                SINWT = sin(WBT)
                DZ = (CZ1 * SINWT + (Object.EFieldOverBField - CY1) * (1 - COSWT)) / Object.AngularSpeedOfRotation

                E = E1 + DZ * EF100
                # CALCULATE ELECTRON VELOCITY IN LAB FRAME
                CX2 = CX1
                CY2 = (CY1 - Object.EFieldOverBField) * COSWT + CZ1 * SINWT + Object.EFieldOverBField
                CZ2 = CZ1 * COSWT - (CY1 - Object.EFieldOverBField) * SINWT

                # FIND IDENTITY OF GAS FOR COLLISION
                GasIndex = 0
                R2 = random_uniform(RandomSeed)
                if Object.NumberOfGases == 1:
                    GasIndex = 0
                else:
                    while (Object.MaxCollisionFreqTotalG[GasIndex] < R2):
                        GasIndex = GasIndex + 1

                # CALCULATE GAS VELOCITY VECTORS VGX,VGY,VGZ
                IMBPT += 1
                if (IMBPT > 6):
                    GERJAN(Object.RandomSeed,  Object.RNMX)
                    IMBPT = 1
                VGX = Object.VTMB[GasIndex] * Object.RNMX[(IMBPT - 1) % 6]
                IMBPT += 1
                VGY = Object.VTMB[GasIndex] * Object.RNMX[(IMBPT - 1) % 6]
                IMBPT += 1
                VGZ = Object.VTMB[GasIndex] * Object.RNMX[(IMBPT - 1) % 6]

                # CALCULATE ENERGY WITH STATIONRhydbergConst GAS TARGET
                EOK = ((CX2 - VGX) ** 2 + (CY2 - VGY) ** 2 + (CZ2 - VGZ) ** 2) / CONST10
                IE = int(EOK / Object.ElectronEnergyStep)
                IE = min(IE, 3999)

                # TEST FOR REAL OR NULL COLLISION
                R5 = random_uniform(RandomSeed)
                TEST1 = Object.TCF[GasIndex][IE] / Object.MaxCollisionFreq[GasIndex]
                # TEST FOR REAL OR NULL COLLISION
                if R5 > TEST1:
                    TEST2 = TEMP[GasIndex][IE] / Object.MaxCollisionFreq[GasIndex]
                    if R5 < TEST2:
                        # TEST FOR NULL LEVELS
                        if Object.NPLAST[GasIndex] == 0:
                            continue
                        R2 = random_uniform(RandomSeed)
                        I = 0
                        while Object.CFN[GasIndex][IE][I] < R2:
                            # INCREMENT NULL SCATTER SUM
                            I += 1

                        Object.ICOLNN[GasIndex][I] += 1
                        continue
                    else:
                        TEST3 = (TEMP[GasIndex][IE] + ABSFAKEI) / Object.MaxCollisionFreq[GasIndex]
                        if R5 < TEST3:
                            # FAKE IONISATION INCREMENT COUNTER
                            Object.IFAKE += 1
                            continue
                        continue
                else:
                    break
            NCOL += 1
            #CALCULATE DIRECTION COSINES OF ELECTRON IN 0 KELVIN FRAME
            CONST11 = 1 / (CONST9 * sqrt(EOK))
            DXCOM = (CX2 - VGX) * CONST11
            DYCOM = (CY2 - VGY) * CONST11
            DZCOM = (CZ2 - VGZ) * CONST11

            #  CALCULATE POSITIONS AT INSTANT BEFORE COLLISION
            #    ALSO UPDATE DIFFUSION  AND ENERGY CALCULATIONS.
            T2 = T ** 2
            TDASH = 0.0

            #CALC NEW POSITION
            Object.X += CX1 * T
            Object.Y += Object.EFieldOverBField * T + ((CY1 - Object.EFieldOverBField) * SINWT + CZ1 * (1 - COSWT)) / Object.AngularSpeedOfRotation
            Object.Z += DZ
            Object.TimeSum += T
            IT = int(T)
            IT = min(IT, 299)
            Object.TIME[IT] += 1

            #ENERGY SPECTRUM FOR O KELVIN FRAME
            Object.SPEC[IE] += 1
            Object.VelocityZ = Object.Z / Object.TimeSum
            Object.VelocityY = Object.Y / Object.TimeSum
            SUMVX += (CX1 ** 2) * T2
            if ID != 0:
                KDUM = 0
                for J in range(int(Object.Decor_NCORST)):
                    ST2 = ST2 + T
                    NCOLDM = NCOL + KDUM
                    if NCOLDM > Object.Decor_NCOLM:
                        NCOLDM = NCOLDM - Object.Decor_NCOLM
                    SDIF = Object.TimeSum - STO[NCOLDM-1]
                    SUMXX += ((Object.X - XST[NCOLDM-1]) ** 2) * T / SDIF
                    KDUM += Object.Decor_NCORLN
                    if J1 >= 2:
                        ST1 += T
                        SUMZZ += ((Object.Z - ZST[NCOLDM-1] - Object.VelocityZ * SDIF) ** 2) * T / SDIF
                        SUMYY += ((Object.Y - YST[NCOLDM-1] - Object.VelocityY * SDIF) ** 2) * T / SDIF
                        SUMYZ += (Object.Z - ZST[NCOLDM-1] - Object.VelocityZ * SDIF) * (
                                Object.Y - YST[NCOLDM-1] - Object.VelocityY * SDIF) * T / SDIF
                        A2 = (Object.VelocityZ * SDIF) ** 2 + (Object.VelocityY * SDIF) ** 2
                        B2 = (Object.Z - Object.VelocityZ * SDIF - ZST[NCOLDM-1]) ** 2 + (
                                Object.Y - Object.VelocityY * SDIF - YST[NCOLDM-1]) ** 2
                        C2 = (Object.Z - ZST[NCOLDM-1]) ** 2 + (Object.Y - YST[NCOLDM-1]) ** 2
                        DL2 = (A2 + B2 - C2) ** 2 / (4 * A2)
                        DT2 = B2 - DL2
                        SUMLS += DL2 * T / SDIF
                        SUMTS += DT2 * T / SDIF
            XST[NCOL-1] = Object.X
            YST[NCOL-1] = Object.Y
            ZST[NCOL-1] = Object.Z
            STO[NCOL-1] = Object.TimeSum
            if NCOL >= Object.Decor_NCOLM:
                ID += 1
                NCOL = 0
            # ---------------------------------------------------------------------
            #     DETERMINATION OF REAL COLLISION TYPE
            # ---------------------------------------------------------------------
            R2 = random_uniform(RandomSeed)


            # FIND LOCATION WITHIN 4 UNITS IN COLLISION ARRAY
            I = MBSortT(GasIndex, I, R3, IE, Object)
            while Object.CF[GasIndex][IE][I] < R3:
                I += 1
            S1 = Object.RGAS[GasIndex][I]
            EI = Object.EIN[GasIndex][I]

            if Object.IPN[GasIndex][I] > 0:
                #  USE FLAT DISTRIBUTION OF  ELECTRON ENERGY BETWEEN E-EION AND 0.0 EV
                #  SAME AS IN BOLTZMANN
                R9 = random_uniform(RandomSeed)
                EXTRA = R9 * (EOK - EI)
                EI = EXTRA + EI
                # IF FLOUORESCENCE OR AUGER ADD EXTRA ELECTRONS
                IEXTRA += <long long>Object.NC0[GasIndex][I]
            #  GENERATE SCATTERING ANGLES AND UPDATE  LABORATORY COSINES AFTER
            #   COLLISION ALSO UPDATE ENERGY OF ELECTRON.
            IPT = <long long>Object.IARRY[GasIndex][I]
            Object.ICOLL[GasIndex][int(IPT)] += 1
            Object.ICOLN[GasIndex][I] += 1
            if EOK < EI:
                #FIX ENERGY LOSS SMALLER THAN INCIDENT ENERGY IF ERROR OCCURS
                EI = EOK - 0.0001

            #IF EXCITATION THEN ADD PROBABILITY,PENFRAC(1,I), OF TRANSFER TO GIVE
            # IONISATION OF THE OTHER GASES IN THE MIXTURE
            if Object.IPEN != 0:
                if Object.PENFRA[GasIndex][0][I] != 0:
                    RAN = random_uniform(RandomSeed)
                    if RAN <= Object.PENFRA[GasIndex][0][I]:
                        #ADD EXTRA IONISATION COLLISION
                        IEXTRA += 1
            S2 = (S1 ** 2) / (S1 - 1.0)

            # AAnisotropicDetectedTROPIC SCATTERING
            R3 = random_uniform(RandomSeed)
            if Object.INDEX[GasIndex][I] == 1:
                R31 = random_uniform(RandomSeed)
                F3 = 1.0 - R3 * Object.ANGCT[GasIndex][IE][I]
                if R31 > Object.PSCT[GasIndex][IE][I]:
                    F3 = -1 * F3
            elif Object.INDEX[GasIndex][I] == 2:
                EPSI = Object.PSCT[GasIndex][IE][I]
                F3 = 1 - (2 * R3 * (1 - EPSI) / (1 + EPSI * (1 - 2 * R3)))
            else:
                # ISOTROPIC SCATTERING
                F3 = 1 - 2 * R3
            THETA0 = acos(F3)
            R4 = random_uniform(RandomSeed)
            PHI0 = F4 * R4
            F8 = sin(PHI0)
            F9 = cos(PHI0)
            ARG1 = 1 - S1 * EI / EOK
            ARG1 = max(ARG1, Object.SmallNumber)
            D = 1 - F3 * sqrt(ARG1)
            E1 = EOK * (1 - EI / (S1 * EOK) - 2 * D / S2)
            E1 = max(E1, Object.SmallNumber)
            Q = sqrt((EOK / E1) * ARG1) / S1
            Q = min(Q, 1)
            Object.AngleFromZ = asin(Q * sin(THETA0))
            F6 = cos(Object.AngleFromZ)
            U = (S1 - 1) * (S1 - 1) / ARG1

            CSQD = F3 * F3
            if F3 < 0 and CSQD > U:
                F6 = -1 * F6
            F5 = sin(Object.AngleFromZ)
            DZCOM = min(DZCOM, 1)
            ARGZ = sqrt(DXCOM * DXCOM + DYCOM * DYCOM)
            if ARGZ == 0:
                DCZ1 = F6
                DCX1 = F9 * F5
                DCY1 = F8 * F5
            else:
                DCZ1 = DZCOM * F6 + ARGZ * F5 * F8
                DCY1 = DYCOM * F6 + (F5 / ARGZ) * (DXCOM * F9 - DYCOM * DZCOM * F8)
                DCX1 = DXCOM * F6 - (F5 / ARGZ) * (DYCOM * F9 + DXCOM * DZCOM * F8)
            # TRANSFORM VELOCITY VECTORS TO LAB FRAME
            VTOT = CONST9 * sqrt(E1)
            CX1 = DCX1 * VTOT + VGX
            CY1 = DCY1 * VTOT + VGY
            CZ1 = DCZ1 * VTOT + VGZ
            # CALCULATE ENERGY AND DIRECTION COSINES IN LAB FRAME
            E1 = (CX1 * CX1 + CY1 * CY1 + CZ1 * CZ1) / CONST10
            CONST11 = 1 / (CONST9 * sqrt(E1))
            DCX1 = CX1 * CONST11
            DCY1 = CY1 * CONST11
            DCZ1 = CZ1 * CONST11

        Object.VelocityZ *= 1e9
        Object.VelocityY *= 1e9
        if ST2 != 0.0:
            Object.DiffusionX = 5e15 * SUMXX / ST2
        if ST1 != 0.0:
            Object.DiffusionZ = 5e15 * SUMZZ / ST1
            Object.DiffusionY = 5e15 * SUMYY / ST1
            Object.DiffusionYZ = -5e15 * SUMYZ / ST1
            Object.LongitudinalDiffusion = 5e15 * SUMLS / ST1
            Object.TransverseDiffusion = 5e15 * SUMTS / ST1
        if Object.AnisotropicDetected == 0:
            Object.DiffusionX = 5e15 * SUMVX / Object.TimeSum
        EBAR = 0.0
        for IK in range(4000):
            TCFSUM = 0.0
            for KI in range(Object.NumberOfGases):
                TCFSUM += Object.TCF[KI][IK]
            EBAR += Object.E[IK] * Object.SPEC[IK] / TCFSUM
        Object.MeanElectronEnergy = EBAR / Object.TimeSum
        WZST[J1] = (Object.Z - ZOLD) / (Object.TimeSum - STOLD) * 1e9
        WYST[J1] = (Object.Y - YOLD) / (Object.TimeSum - STOLD) * 1e9
        AVEST[J1] = (EBAR - EBAROLD) / (Object.TimeSum - STOLD)
        EBAROLD = EBAR
        DFZZST[J1] = 0.0
        DFYYST[J1] = 0.0
        DFYZST[J1] = 0.0
        DFLNST[J1] = 0.0
        DFTRST[J1] = 0.0
        if J1 > 1:
            DFZZST[J1] = 5e15 * (SUMZZ - SZZOLD) / (ST1 - ST1OLD)
            DFYYST[J1] = 5e15 * (SUMYY - SYYOLD) / (ST1 - ST1OLD)
            DFYZST[J1] = 5e15 * (SUMYZ - SYZOLD) / (ST1 - ST1OLD)
            DFLNST[J1] = 5e15 * (SUMLS - SLNOLD) / (ST1 - ST1OLD)
            DFTRST[J1] = 5e15 * (SUMTS - STROLD) / (ST1 - ST1OLD)
        DFXXST[J1] = 5e15 * (SUMXX - SXXOLD) / (ST2 - ST2OLD)
        if Object.AnisotropicDetected == 0:
            DFXXST[J1] = 5e15 * (SUMVX - SVXOLD) / (Object.TimeSum - STOLD)
        ZOLD = Object.Z
        YOLD = Object.Y
        STOLD = Object.TimeSum
        ST1OLD = ST1
        ST2OLD = ST2
        SVXOLD = SUMVX
        SZZOLD = SUMZZ
        SXXOLD = SUMXX
        SYYOLD = SUMYY
        SYZOLD = SUMYZ
        SLNOLD = SUMLS
        STROLD = SUMTS
        if Object.ConsoleOutputFlag:
            print('{:^12.1f}{:^12.1f}{:^10.1f}{:^10.1f}{:^10.1f}{:^10.1f}{:^10.1f}{:^10.1f}{:^10.1f}'.format(Object.VelocityZ,Object.VelocityY,
                                                                                    Object.MeanElectronEnergy, Object.DiffusionX, Object.DiffusionY,
                                                                                    Object.DiffusionZ,Object.DiffusionYZ,Object.LongitudinalDiffusion,Object.TransverseDiffusion))

    # Calculate errors and check averages
    TWZST = 0.0
    TWYST = 0.0
    TAVE = 0.0
    T2WZST = 0.0
    T2WYST = 0.0
    T2AVE = 0.0
    TZZST = 0.0
    TYYST = 0.0
    TXXST = 0.0
    TYZST = 0.0
    TLNST = 0.0
    TTRST = 0.0
    T2ZZST = 0.0
    T2YYST = 0.0
    T2XXST = 0.0
    T2YZST = 0.0
    T2LNST = 0.0
    T2TRST = 0.0

    for K in range(10):
        TWZST = TWZST + WZST[K]
        TWYST = TWYST + WYST[K]
        TAVE = TAVE + AVEST[K]
        T2WZST = T2WZST + WZST[K] * WZST[K]
        T2WYST = T2WYST + WYST[K] * WYST[K]
        T2AVE = T2AVE + AVEST[K] * AVEST[K]
        TXXST += DFXXST[K]
        T2XXST += DFXXST[K] ** 2
        if K >= 2:
            TZZST = TZZST + DFZZST[K]
            TYYST = TYYST + DFYYST[K]
            TYZST = TYZST + DFYZST[K]
            TLNST = TLNST + DFLNST[K]
            TTRST = TTRST + DFTRST[K]
            T2ZZST += DFZZST[K] ** 2
            T2YYST += DFYYST[K] ** 2
            T2YZST += DFYZST[K] ** 2
            T2LNST += DFLNST[K] ** 2
            T2TRST += DFTRST[K] ** 2
    Object.VelocityErrorZ = 100 * sqrt((T2WZST - TWZST * TWZST / 10.0) / 9.0) / Object.VelocityZ
    Object.VelocityErrorY = 100 * sqrt((T2WYST - TWYST * TWYST / 10.0) / 9.0) / abs(Object.VelocityY)
    Object.MeanElectronEnergyError = 100 * sqrt((T2AVE - TAVE * TAVE / 10.0) / 9.0) / Object.MeanElectronEnergy
    Object.ErrorDiffusionX = 100 * sqrt((T2XXST - TXXST * TXXST / 10.0) / 9.0) / Object.DiffusionX
    Object.ErrorDiffusionY = 100 * sqrt((T2YYST - TYYST * TYYST / 8.0) / 7.0) / Object.DiffusionY
    Object.ErrorDiffusionZ = 100 * sqrt((T2ZZST - TZZST * TZZST / 8.0) / 7.0) / Object.DiffusionZ
    Object.ErrorDiffusionYZ = 100 * sqrt((T2YZST - TYZST * TYZST / 8.0) / 7.0) / abs(Object.DiffusionYZ)
    Object.LongitudinalDiffusionError = 100 * sqrt((T2LNST - TLNST * TLNST / 8.0) / 7.0) / Object.LongitudinalDiffusion
    Object.TransverseDiffusionError = 100 * sqrt((T2TRST - TTRST * TTRST / 8.0) / 7.0) / Object.TransverseDiffusion
    Object.VelocityErrorZ = Object.VelocityErrorZ / sqrt(10)
    Object.VelocityErrorY = Object.VelocityErrorY / sqrt(10)
    Object.MeanElectronEnergyError = Object.MeanElectronEnergyError / sqrt(10)
    Object.ErrorDiffusionX = Object.ErrorDiffusionX / sqrt(10)
    Object.ErrorDiffusionY = Object.ErrorDiffusionY / sqrt(8)
    Object.ErrorDiffusionZ = Object.ErrorDiffusionZ / sqrt(8)
    Object.ErrorDiffusionYZ = Object.ErrorDiffusionYZ / sqrt(8)
    Object.LongitudinalDiffusionError = Object.LongitudinalDiffusionError / sqrt(8)
    Object.TransverseDiffusionError = Object.TransverseDiffusionError / sqrt(8)

    # CONVERT CM/SEC

    Object.VelocityZ *= 1e5
    Object.VelocityY *= 1e5

    ANCATT = 0.0
    ANCION = 0.0
    for I in range(Object.NumberOfGases):
        ANCATT += Object.ICOLL[I][2]
        ANCION += Object.ICOLL[I][1]
    ANCION += IEXTRA
    Object.AttachmentRateError = 0.0

    if ANCATT != 0:
        Object.AttachmentRateError = 100 * sqrt(ANCATT) / ANCATT
    Object.AttachmentRate = ANCATT / (Object.TimeSum * Object.VelocityZ) * 1e12
    Object.IonisationRateError = 0.0
    if ANCION != 0:
        Object.IonisationRateError = 100 * sqrt(ANCION) / ANCION
    Object.IonisationRate = ANCION / (Object.ST * Object.VelocityZ) * 1e12

