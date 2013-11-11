#
# Copyright (c) 2002-2008 Nokia Corporation and/or its subsidiary(-ies).
# All rights reserved.
# This component and the accompanying materials are made available
# under the terms of "Eclipse Public License v1.0"
# which accompanies this distribution, and is available
# at the URL "http://www.eclipse.org/legal/epl-v10.html".
#
# Initial Contributors:
# Nokia Corporation - initial contribution.
#
# Contributors:
#
# Description: 
#

LIB_TO_REPLACE=cdlengine.lib
LIB_TARGET=aknlayout.lib
DSO_TO_REPLACE=cdlEngine.dso
DSO_TARGET=aknlayout.dso

CLEAN :
	@-del /s/q $(EPOCROOT)\epoc32\release\$(PLATFORM)\$(LIB_TARGET)
	@-del /s/q $(EPOCROOT)\epoc32\release\$(PLATFORM)\$(DSO_TARGET)

ifeq ($(PLATFORM),ARMV5)
LIB : \epoc32\release\$(PLATFORM)\LIB\$(LIB_TO_REPLACE)
	@perl ..\group\replace_lib.pl \epoc32\release\$(PLATFORM)\LIB $(LIB_TO_REPLACE) $(LIB_TARGET)
	@perl ..\group\replace_lib.pl \epoc32\release\$(PLATFORM)\LIB $(DSO_TO_REPLACE) $(DSO_TARGET)

else
LIB : \epoc32\release\$(PLATFORM)\udeb\$(LIB_TO_REPLACE)
	@perl ..\group\replace_lib.pl \epoc32\release\$(PLATFORM)\udeb $(LIB_TO_REPLACE) $(LIB_TARGET)
endif

MAKMAKE BLD CLEANLIB RESOURCE FREEZE SAVESPACE RELEASABLES FINAL :
