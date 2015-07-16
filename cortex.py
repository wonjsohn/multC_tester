# -*- coding: utf-8 -*-

"""
Module implementing Control.
"""

from PyQt4.QtGui import QDialog
from PyQt4.QtCore import pyqtSignature, pyqtSlot
from PyQt4.QtCore import QTimer,  SIGNAL, SLOT, Qt,  QRect
from PyQt4 import QtCore, QtGui

from Utilities import *
from generate_sin import gen as gen_sin
from generate_tri import gen as gen_tri
from generate_spikes import spike_train
from generate_sequence import gen as gen_ramp
from math import floor,  pi
import types
from functools import partial
#from par_search import muscle_properties
from Utilities import convertType
#from M_Fpga import SendPara

from Ui_cortex import Ui_Dialog


class cortexView(QDialog, Ui_Dialog):
    """
    GUI class for feeding waveforms or user inputs to OpalKelly boards
    """
    def __init__(self, xemList, parent = None):
        """
        Constructor
        """
        QDialog.__init__(self, parent)
        self.setupUi(self)
        self.move(300, 300)   # windows position
        self.xemList = xemList
     
       
