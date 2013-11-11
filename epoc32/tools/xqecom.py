#!/usr/bin/env python
"""
This is part of qtextensions/qtecomplugins extension. It pregenerates few files needed during compilation of ecom plugins.
Those includes:
  * registration resource file
  * stubs
  * pkg file
  * iby file
"""

import logging
import datetime
import sys
from optparse import OptionParser

class Generator(object):
	def __init__(self, args):
		if len(args)==5:
			if args[2]=="":
				interfaceValue = args[0]+".dll"
			else:
				interfaceValue = args[2]
			self.args = {
			'target': args[0],
			'uid3': args[1],
			'interface': interfaceValue,
			'configuration': args[3],
			'configurationFile': args[4],
			'timestamp': datetime.datetime.now()
			}
		else:
			logging.fatal("illegal number of arguments: %d" % len(args))
			sys.exit(1)
	def generate(self):
		logging.warning("%s is not generating anything useful" % self.__class__.__name__)
	def strip(self, s):
		l = len(s) - len(s.lstrip())
		def stripOrNot(x):
			x = x + '\n'
			if l>=len(x):
				return x
			else:
				return x[l:]
		return ''.join(map(stripOrNot, s.splitlines(False)))
		
class RssGenerator(Generator):
	"""
	RSS generator.
	"""
	def __init__(self, args):
		super(self.__class__, self).__init__(args)
	def generate(self):
		fileName = self.args['target'] + ".rss"
		dllName = self.args['target'] + ".dll"
		
		if self.args['interface'] == "":
			self.args['interface'] = dllName

		if self.args['configurationFile'] != "":
			opaqueDataFile = file(self.args['configurationFile'])
			self.args['opaqueData'] = ((''.join(opaqueDataFile.readlines())).replace('\n', '').replace('"', '\\"'))[:255];
		else:
			self.args['opaqueData'] = self.args['configuration']

		output = file(fileName, "w")
		header = """\
		// ==============================================================================
		// Generated by xqecom on %(timestamp)s
		// This file is generated by xqecom and should not be modified by the user.
		// Name        : %(target)s.rss
		// Part of     : 
		// Description : Fixes common plugin symbols to known ordinals
		// Version     : 
		// ==============================================================================
		
		
		#include <registryinfov2.rh>
		
		#include <xqtecom.hrh>
		
		#include <ecomstub_%(uid3)s.hrh>
		
		RESOURCE REGISTRY_INFO theInfo
		{
		resource_format_version = RESOURCE_FORMAT_VERSION_2;
		dll_uid = %(uid3)s;
		interfaces =
			{
			INTERFACE_INFO
				{
				interface_uid = KQtEcomPluginInterfaceUID;
				implementations =
					{
					IMPLEMENTATION_INFO
						{
						implementation_uid = KQtEcomPluginImplementationUid;
						version_no = 1;
						display_name = "%(target)s.dll";
						// SERVICE.INTERFACE_NAME
						default_data = "%(interface)s";
						// SERVICE.CONFIGURATION
						opaque_data = "%(opaqueData)s";
						}
					};
				}
			};
		}"""
		
		output.write(self.strip(header) % self.args )
		

class PkgGenerator(Generator):
	"""
	PKG generator.
	"""
	def __init__(self, args):
		super(self.__class__, self).__init__(args)
	def generate(self):
		content='''\
		// ============================================================================
		// Generated by xqecom on %(timestamp)s
		// This file is generated by xqecom and should not be modified by the user.
		// ============================================================================

		; Language
		&EN

		; SIS header: name, uid, version
		#{%(target)s},(%(uid3)s),1,0,0

		; Localised Vendor name
		%%{"Nokia, Qt Software"}

		; Unique Vendor name
		:"Nokia, Qt Software"

		; Dependencies
		[0x101F7961],0,0,0,{"S60ProductID"}
		[0x102032BE],0,0,0,{"S60ProductID"}
		[0x102752AE],0,0,0,{"S60ProductID"}
		[0x1028315F],0,0,0,{"S60ProductID"}
		(0x2001E61C), 4, 5, 0, {"QtLibs pre-release"}

		;files
		"\\epoc32\\release\\armv5\\urel\\%(target)s.dll"    - "!:\\sys\\bin\\%(target)s.dll"
		"\\epoc32\\data\\Z\\resource\\plugins\\%(target)s.rsc" - "!:\\resource\\plugins\\%(target)s.rsc"'''
		
		fileName = self.args['target'] + ".pkg"
		output = file(fileName, "w")
		output.write(self.strip(content) % self.args)
	

class IbyGenerator(Generator):
	"""
	IBY generator.
	"""
	def __init__(self, args):
		super(self.__class__, self).__init__(args)
	def generate(self):
		self.args['TARGET']=self.args['target'].upper()
		content="""\
		// ============================================================================
		// Generated by xqecom on %(timestamp)s
		// This file is generated by xqecom and should not be modified by the user.
		// ============================================================================

		#ifndef %(TARGET)s_IBY
		#define %(TARGET)s_IBY

		#include <bldvariant.hrh>

		ECOM_PLUGIN( %(target)s.dll, %(target)s.rsc )

		#endif //%(TARGET)s_IBY"""
		
		fileName = self.args['target'] + ".iby"
		output = file(fileName, "w")
		output.write(self.strip(content) % self.args)
	
class StubsGenerator(Generator):
	"""
	Stubs generator.
	"""
	def __init__(self, args):
		super(self.__class__, self).__init__(args)
	def generate(self):
		contentHrh="""\
		// ============================================================================
		// Generated by xqecom on %(timestamp)s
		// This file is generated by xqecom and should not be modified by the user.
		// ============================================================================

		#ifndef ECOMSTUB_%(uid3)s_HRH
		#define ECOMSTUB_%(uid3)s_HRH
		#define KQtEcomPluginImplementationUid %(uid3)s
		#endif //ECOMSTUB_%(uid3)s_HRH"""

		fileName = "ecomstub_" + self.args['uid3'] + ".hrh"
		output = file(fileName, "w")
		output.write(self.strip(contentHrh) % self.args)

		contentCpp="""\
		// ============================================================================
		// Generated by xqecom on %(timestamp)s
		// This file is generated by xqecom and should not be modified by the user.
		// ============================================================================

		#include <xqplugin.h>
		#include <ecomstub_%(uid3)s.hrh>
		#include <ecom/implementationproxy.h>
		XQ_PLUGIN_ECOM_HEADER(%(target)s)
		const TImplementationProxy implementationTable[] = 
			{
			IMPLEMENTATION_PROXY_ENTRY(%(uid3)s, C%(target)sFactory::NewL)
			};

		EXPORT_C const TImplementationProxy* ImplementationGroupProxy(TInt& aTableCount)
			{
			aTableCount = sizeof( implementationTable ) / sizeof( TImplementationProxy );
			return implementationTable;
			}"""

		fileName = "ecomstub_" + self.args['uid3'] + ".cpp"
		output = file(fileName, "w")
		output.write(self.strip(contentCpp) % self.args)
	

def runGenerators(generators, args):
	for g in generators:
		logging.debug("about to run generator: %s" % g.__name__)
		try:
			instance = g(args)
			instance.generate()
		except Exception, ex:
			logging.error("Exception in %s: '%s'" % (g.__name__, ex))
			logging.error("Exception in %s: '%s'" % (g.__name__, ex))
			raise

if (__name__=="__main__"):
	arguments = sys.argv[1:]

	op = OptionParser()
	op.usage="%prog [options] [<target> <uid3> <interface> <configuration> <configurationFile>]"
	
#	op.add_option("-t", "--target", help="plugin target name")
#	op.add_option("-u", "--uid3", help="plugin uid3")
#	op.add_option("-i", "--interface", help="interface name")
#	op.add_option("-c", "--configuration", help="configuration")
#	op.add_option("-f", "--configuration-file", help="configuration file")
	
	(options, args) = op.parse_args(arguments)
	
	generators = [RssGenerator, PkgGenerator, IbyGenerator, StubsGenerator]
	runGenerators(generators, args)

