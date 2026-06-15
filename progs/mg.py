#!/usr/bin/env python
"""
    MakeAllGraphs (mg.py)

    this program generates all Graphics for the Temperature sensors

    !!! for history see end of file !!!
"""    

import logging
import os
import sys
import subprocess
import time

import CL_ServESP
import CL_MakeGraphic

PROGNAME = "Makegraphics"
PROGVERS = "1.1a"
    
# --------------------------------------------------------------------------------------------------
   
se = CL_ServESP.ServESP(PROGNAME, PROGVERS)

ng = CL_MakeGraphic.MakeGraphic()  
ng.MakeAllGraphs()

se.Close()

exit()

"""
------------------------------------------------------------------------------------------------------------

    history:
    --------------------- V1.0a
    22.02.21    ServESP class is external

------------------------------------------------------------------------------------------------------------
"""