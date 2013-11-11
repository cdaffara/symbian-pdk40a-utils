# All paths used in this file end with the path delimiter '/'

include $(EPOCROOT)epoc32/tools/shell/$(notdir $(basename $(SHELL))).mk

COPY := $(call ecopy)

EPOC_ROOT := $(subst \,/,$(EPOCROOT))
QT_ROOT := $(subst src/s60installs/deviceconfiguration,,$(subst \,/,$(EXTENSION_ROOT)))
QMAKEPATH := epoc32/tools/qt/
INSTALLTOOLSPATH := epoc32/tools/
MKSPECPATH := epoc32/tools/qt/

# Determine which platform we are building on
ifeq ($(OSTYPE),unix)
CONF_PLATFORM := linux-g++-32
DOTEXE :=
else
CONF_PLATFORM := win32-g++-symbian
DOTEXE := .exe
endif

# This variable is needed to do the 'cd' on Windows
CONFIGURE_ROOT := $(subst src\s60installs\deviceconfiguration,,$(EXTENSION_ROOT))


TARGETDIR := $(EPOC_ROOT)$(INSTALLPATH)
SOURCEDIR := $(QT_ROOT)bin/
TARGET_TOOLS := $(EPOC_ROOT)$(QMAKEPATH)qmake$(DOTEXE) $(TARGETDIR)moc$(DOTEXE) $(TARGETDIR)rcc$(DOTEXE) $(TARGETDIR)uic$(DOTEXE) $(TARGETDIR)/lrelease$(DOTEXE)
SOURCE_TOOLS := $(SOURCEDIR)qmake$(DOTEXE) $(SOURCEDIR)moc$(DOTEXE) $(SOURCEDIR)rcc$(DOTEXE) $(SOURCEDIR)uic$(DOTEXE)

XPLATFORM:=symbian-abld

$(TARGETDIR):
	$(call makepath,$(TARGETDIR))

$(SOURCEDIR)qmake$(DOTEXE): $(QT_ROOT)configure$(DOTEXE)
	echo Configuring Qt for build on $(CONF_PLATFORM) with $(XPLATFORM) as build setup
	cd $(CONFIGURE_ROOT) && set INCLUDE=  && set LIB=  && $(QT_ROOT)configure$(DOTEXE) -platform $(CONF_PLATFORM) -xplatform $(XPLATFORM) $(OPTIONS)
	perl $(QT_ROOT)/bin/syncqt -base-dir $(QT_ROOT) -copy -oneway -outdir $(EPOC_ROOT)epoc32/include/ -outsubdir mw
	$(COPY) $(EPOC_ROOT)epoc32/gcc_mingw/bin/mingwm10.dll $(EPOC_ROOT)$(INSTALLPATH)mingwm10.dll
	$(COPY) $(EPOC_ROOT)epoc32/gcc_mingw/bin/mingwm10.dll $(QT_ROOT)bin/mingwm10.dll
	perl $(EPOCROOT)epoc32/tools/emkdir.pl $(EPOC_ROOT)epoc32/tools/qt/mkspecs
	xcopy /s $(CONFIGURE_ROOT)\mkspecs $(EPOCROOT)epoc32\tools\qt\mkspecs
	
$(TARGET_TOOLS): $(SOURCE_TOOLS)
	$(COPY) $(SOURCEDIR)$(notdir $@) $@
	
do_nothing:
	
MAKMAKE : do_nothing

BLD : $(TARGETDIR) $(TARGET_TOOLS)

FINAL : do_nothing

CLEAN :
	perl $(EPOCROOT)epoc32/tools/ermdir.pl $(TARGETDIR)
	perl -e "foreach(split(/ /, \"$(SOURCE_TOOLS)\")) {unlink \"$$_\";}"

RELEASABLES :  do_nothing 

SAVESPACE : BLD

FREEZE : do_nothing

LIB : do_nothing

CLEANLIB : do_nothing

RESOURCE : do_nothing



