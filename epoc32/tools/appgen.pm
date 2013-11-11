#
# Copyright (c) 2005-2009 Nokia Corporation and/or its subsidiary(-ies).
# All rights reserved.
# This component and the accompanying materials are made available
# under the terms of the License "Eclipse Public License v1.0"
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

package AppGen;
use strict;

my $BuildSystemVersion = $ENV{'SBS_VERSION'};

##############################################
## the object constructor                   ##
##############################################
sub new
{
    my $self = {};
    
    shift @_;
    
    my $actual_num = scalar(@_);
    $self->error("Expected 9 args, got $actual_num") if ($actual_num != 9);
    
    $self->{PLATFORM} = shift @_;
    $self->{VARIANT} = shift @_;
    $self->{TARGET_NAME} = shift @_;
    $self->{OUTPUT_DIR} = shift @_;

    $self->{UTIL} = shift @_;
    die "util not defined\n" if not $self->{UTIL};

    $self->{INPUT_FILE} = shift @_;
    $self->{UID} = shift @_;
    $self->{VID} = shift @_;
    $self->{INSTALL_DRIVE} = shift @_;
    
    $self->{GENERATE_PKGFILE} = 0;
    $self->{GENERATE_SISFILE} = 0;
    
    $self->{PKGFILE} = ($self->{OUTPUT_DIR} . "/" . $self->{TARGET_NAME} 
			. ".pkg");

    my $input_file = $self->{INPUT_FILE};
    
    if ($input_file)
    {
	-e $input_file or 
	    $self->{UTIL}->error("Input file '$input_file' does not exist\n");
    }

    $self->{UTIL}->detailed("variant: ", $self->{VARIANT}, "\n");
    $self->{UTIL}->detailed("target_name: ", $self->{TARGET_NAME}, "\n");
    $self->{UTIL}->detailed("output_dir: ", $self->{OUTPUT_DIR}, "\n");
    $self->{UTIL}->detailed("platform: ", $self->{PLATFORM}, "\n");
    $self->{UTIL}->detailed("variant: ", $self->{VARIANT}, "\n");
    
    $self->{OUTPUT_DIR} =~ m|(.*)[/\\]+.*$|;
    $self->{ROOT} = "$1\\..";

    bless($self);
    return $self;
}

##############################################
## Class methods to access per-object data  ##
##                                          ##
##############################################

#
# Perform environment checking
#
sub generate_prerequisites()
{
    my $self = shift;
    die "self not defined\n" if (not defined($self));
 
    my $util = $self->{UTIL};
    $util->detailed("Checking environment for source generation\n");

    my $output_dir = $self->{OUTPUT_DIR};

    $util->error("$output_dir already exists") if -e $output_dir;
    mkpath($output_dir, 1, 0777);
    $util->error("Could not create $output_dir") if not -d $output_dir;
    
    my $input_file = $self->{INPUT_FILE};
    $util->error("'$input_file' does not exist") if not -e $input_file;
    
    $util->error("A UID is mandatory for generating sources") 
	if (not $self->{UID});
    
    my $uid = $self->{UID};
    my $vid = '';
    if (defined($self->{VID}))
    {
	my $vid = $self->{VID};
    }
    
    $util->detailed("Using UID and VID {$uid,$vid} respectively\n");
}

#
# Perform environment checking
#
sub pkg_prerequisites()
{
    my $self = shift;
    die "self not defined\n" if (not defined($self));

    my $util = $self->{UTIL};

    my $localised_vendor = shift;
    my $non_localised_vendor = shift;
    my $suid = shift;

    if ($localised_vendor or $non_localised_vendor or $suid)
    {
	$util->detailed("Checking environment for pkg file generation\n");

	if (not ($localised_vendor and $non_localised_vendor and $suid))
	{

	    if (not $localised_vendor)
	    {
		$util->error("localised_vendor must be specified");
	    }

	    if (not $non_localised_vendor)
	    {
		$util->error("non_localised_vendor must be specified");
	    }
	    
	    if (not $suid)
	    {
		$util->error("SIS UID must be specified");
	    }

	    # This is a weak check since source generation and
	    # compilation (including SIS file creation) may occur at
	    # different times.  Thus the uid may be NULL
	    
	    my $uid = $self->{UID};
	    
	    if ($uid eq $suid)
	    {
		$util->error("SIS file UID and Application UID ", 
			     "should not be the same");
	    }
	} 

	$self->{GENERATE_PKGFILE} = 1;
    } 
}

#
# Generate sources
#
sub generate(@)
{
    my $self = shift;
    die "self not defined\n" if (not defined($self));
    
    my $output_dir = $self->{OUTPUT_DIR};
    my $util = $self->{UTIL};
    
    my $major = shift;
    my $minor = shift;
    my $buildnum = shift;
    my $suid = shift;
    my $localised_vendor = shift;
    my $non_localised_vendor = shift;

    $self->generate_prerequisites();
    $self->pkg_prerequisites($localised_vendor, $non_localised_vendor, $suid);

    $util->detailed("Output will be generated in $output_dir\n");
    
    
    
    $self->make_source_src();
    $self->make_make_src();
    $self->make_doc_src($major, $minor, $buildnum);
    
    if ($self->{GENERATE_PKGFILE})
    {
	$self->make_pkg_src($major, $minor, $buildnum, $suid, 
			    $localised_vendor,
			    $non_localised_vendor);
    }
}

#
# Perform environment checking
#
sub make_prerequisites(@)
{
    my $self = shift;
    die "self not defined\n" if (not defined($self));

    my $util = $self->{UTIL};

    $util->detailed("Checking environment for building\n");
    
    my $output_dir = $self->{OUTPUT_DIR};
    $util->error("$output_dir does not exist") if (not -d $output_dir);
    
    my $platform = $self->{PLATFORM};
    $util->warning("Platform '$platform' untested.")
	if ($platform =~ /"winscw"/i and $platform =~ /"armv5"/i);
    
    my $variant = $self->{VARIANT};
    $util->error("$variant not supported") 
	if ($variant =~ /"urel"/i and $variant =~ /"udeb"/i);
}

#
# Perform environment checking
#
sub sis_prerequisites()
{
    my $self = shift;
    die "self not defined\n" if (not defined($self));

    my $key = shift;
    my $certificate = shift;
    
    my $util = $self->{UTIL};

    if ($key or $certificate)
    {
    	$util->detailed("Checking environment for SIS file creation\n");

	# Passphrase is optional
	$util->error("Both Key and certificate must be specified") 
	    if (not ($key and $certificate));
	
	-e $key or $util->error("$key does not exist");    
	-e $certificate or $util->error("$certificate does not exist");

	$self->{GENERATE_SISFILE} = 1;
    }
}

#
# Build the generated source file.
#
sub make(@)
{
    my $self = shift;
    die "self not defined\n" if (not defined($self));
    
    my $target_name = $self->{TARGET_NAME};
    my $output_dir = $self->{OUTPUT_DIR};
    my $platform = $self->{PLATFORM};
    my $variant = $self->{VARIANT};
    my $util = $self->{UTIL};

    my $key = shift;
    my $certificate = shift;
    my $passphrase = shift;
    
    $self->make_prerequisites();
    $self->sis_prerequisites($key, $certificate);

    $util->info("Building...\n");
    
    $util->info("Target Executable: ");
    $util->info("\\epoc32\\RELEASE\\$platform\\$variant\\${target_name}.exe\n");
    use Cwd;
    my $whence = Cwd::cwd();
    
    chdir "$output_dir" or$util->error("chdir $output_dir failed");
    
    my $RVCTVersion = $ENV{'ARMV5VER'};
    if((index($RVCTVersion, "RVCT4.0") != -1) && ($platform eq "armv5"))
    {
        my $platformConfig = "arm."."v5."."$variant".".rvct4_0";
        $util->info($platformConfig);
        $util->invoke("sbs -b bld.inf -c $platformConfig");
    }
    else
    {	
        if ($BuildSystemVersion == "2") 
        {
            my $platformConfig = "$platform"."_"."$variant";
            $util->invoke("sbs -c $platformConfig");
        }
        else
        {
            $util->invoke("bldmake bldfiles");
            $util->invoke("abld build $platform $variant");
            $util->invoke("abld -check build $platform $variant");
        }
    }
 	
   
    chdir "$whence" or $util->error("chdir $whence failed");

    if ($self->{GENERATE_SISFILE})
    {
	$self->make_sis($key, $certificate, $passphrase);
    }
}

sub make_doc($)
{
    my $self = shift;
    die "self not defined\n" if (not defined($self));

    use Cwd;
    my $whence = Cwd::cwd();
    
    my $util = $self->{UTIL};
    my $output_dir = $self->{OUTPUT_DIR};
    
    chdir "$output_dir" or $util->error("chdir $output_dir failed");
    
    $util->invoke("doxygen");
    chdir "$whence" or $util->error("chdir $whence failed");
}

#
# Generate the Doxygen configuration file.
#
sub make_doc_src()
{
    my $self = shift;
    die "self not defined\n" if (not defined($self));
    
    my $major = shift;
    my $minor = shift;
    my $buildnum = shift;

    my $target_name = $self->{TARGET_NAME};
    my $output_dir = $self->{OUTPUT_DIR};
    
    my $util = $self->{UTIL};
    
    $util->info("Generating Doxygen configuration files\n");
    
    open(DOXYFILE, "> ${output_dir}/Doxyfile") or 
	$util->error("Could not open Doxyfile!");
    
    print DOXYFILE <<_____VERBATIM_____;
#---------------------------------------------------------------------------
# Project related configuration options
#---------------------------------------------------------------------------
PROJECT_NAME		   = $target_name
PROJECT_NUMBER		   = "V${major}.${minor}.${buildnum}"
OUTPUT_DIRECTORY	   = ./
DETAILS_AT_TOP		   = YES
TAB_SIZE		   = 8
#---------------------------------------------------------------------------
# Build related configuration options
#---------------------------------------------------------------------------
EXTRACT_ALL		   = YES
EXTRACT_STATIC		   = YES
CASE_SENSE_NAMES	   = YES
#---------------------------------------------------------------------------
# configuration options related to the input files
#---------------------------------------------------------------------------
INPUT			   = ${target_name}.cpp
#---------------------------------------------------------------------------
# configuration options related to the HTML output
#---------------------------------------------------------------------------
GENERATE_HTML		   = YES
GENERATE_TREEVIEW	   = YES
TREEVIEW_WIDTH		   = 250
#---------------------------------------------------------------------------
# configuration options related to the LATEX output
#---------------------------------------------------------------------------
GENERATE_LATEX		   = NO
_____VERBATIM_____

	close DOXYFILE;
}

#
# Generate .pkg file.
#
sub make_pkg_src()
{
    my $self = shift;
    die "self not defined\n" if (not defined($self));

    my $util = $self->{UTIL};
    my $pkgfile = $self->{PKGFILE};
    my $platform = $self->{PLATFORM};
    my $variant = $self->{VARIANT};
    
    my $major = shift;
    my $minor = shift;
    my $buildnum = shift;
    my $suid = shift;
    my $localised_vendor = shift;
    my $non_localised_vendor = shift;
    
    $util->detailed("Generating SIS .pkg file\n");
    
    my $output_dir = $self->{OUTPUT_DIR};
    my $target_name = $self->{TARGET_NAME};
    my $install_drive = $self->{INSTALL_DRIVE};

    $pkgfile = "$output_dir/${target_name}.pkg";

    if (not $major and $minor and $buildnum)
    {
	$util->warning("Major Minor and build number not specifed.");
    }
    
    $util->detailed("Using Major Minor and build number ",
		    "{$major, $minor, $buildnum} respectively\n");
    
    open(PKGFILEWRITE, "> $pkgfile") or $util->error("Could not open $pkgfile!");
    
    print PKGFILEWRITE <<_____VERBATIM_____;
;Languages
&EN

; Header

; The application\'s major and minor version numbers are required for
; version control (e.g., AppName 3.1 specifies a major build 3, and
; minor build 1.)

; The build-number replaces the variant value which was unimplemented
; in previous versions of makesis.

; All SIS files require a UID, even if the installed components do not
; strictly require one.

; The UID value should be unique for SISAPP (SA) types of SIS file

#{"${target_name}-EN"}, ($suid), $major, $minor, $buildnum, TYPE=SA

;FILERUN, RUNINSTALL
"\\epoc32\\RELEASE\\$platform\\$variant\\${target_name}.exe" - 
"$install_drive:\\sys\\bin\\${target_name}.exe", FR, RI

; Localised vendor
%{"$localised_vendor"}

; Non-localised vendor
:"$non_localised_vendor"
_____VERBATIM_____

	close PKGFILEWRITE;
}

#
# Clean up generated files.
#
sub clean($)
{
    my $self = shift;
    die "self not defined\n" if (not defined($self));

    my $reallyclean = (shift @_ > 1);
    
    my $platform = $self->{PLATFORM};
    my $variant  = $self->{VARIANT};
    my $target_name = $self->{TARGET_NAME};
    my $output_dir = $self->{OUTPUT_DIR};
    my $util = $self->{UTIL};

    $util->error("Unknown target") if not $target_name;

    $util->info("Attempting to clean for '$target_name'\n");
    
    use Cwd;
    my $whence = Cwd::cwd();

    if ($reallyclean)
    {
		if ($BuildSystemVersion == "2") 
		{
			if (not -e "$output_dir/bld.inf")
			{
				if (not -d $output_dir)
				{
					mkpath($output_dir, 1, 0777);
					-d $output_dir or $self->error("Could not create $output_dir");
				}
				
				## Generate the project files so we can clean for the
				## specifed platform and variant							
				$self->make_make_src();				
			}
			
			$util->info("Cleaning for platform: $platform, variant: $variant\n");
			
			Cwd::cwd() eq "$output_dir" or 
				chdir "$output_dir" or $util->error("chdir $output_dir failed");
			
			my $platformConfig = "$platform"."_"."$variant";
			$util->invoke("sbs -c $platformConfig reallyclean");			
			
			$util->info("System cleaned for platform: $platform, ",
					"variant: $variant\n");
		}
		else
		{
			if (not -e "$output_dir/abld.bat")
			{
				if (not -d $output_dir)
				{
					mkpath($output_dir, 1, 0777);
					-d $output_dir or $self->error("Could not create $output_dir");
				}
						
				## Generate the project files so we can clean for the
				## specifed platform and variant			
				
				$self->make_make_src();
			
				chdir "$output_dir" or $util->error("chdir $output_dir failed");
				$util->invoke("bldmake bldfiles");
			}
			
			$util->info("Cleaning for platform: $platform, variant: $variant\n");
			
			Cwd::cwd() eq "$output_dir" or 
				chdir "$output_dir" or $util->error("chdir $output_dir failed");

			$util->invoke("abld reallyclean $platform $variant");
			$util->invoke("bldmake clean");
			
			$util->info("System cleaned for platform: $platform, ",
					"variant: $variant\n");
		}
   	}
    
    if (-d $output_dir)
    {
	$util->info("Removing $output_dir\n");
	
	my $root = $self->{ROOT};
	chdir $root or $util->error("chdir $root failed");
	
	use File::Path;
	
	my $deleted_count = rmtree($output_dir, $util->diagnostic(), 1);
	
	$util->detailed("Deleted $deleted_count files\n");
	
	$util->error("Couldn't remove $output_dir") if -d $output_dir;
    }

    chdir "$whence" or $util->error("chdir $whence failed");
}

#
# Generate .SIS file.
#
sub make_sis()
{
    my $self = shift;
    die "self not defined\n" if (not defined($self));
    
    my $util = $self->{UTIL};
    my $output_dir = $self->{OUTPUT_DIR};
    my $target_name = $self->{TARGET_NAME};

    $util->info("Generating sis file\n");
    
    my $args = "";
    
    $args = "-v" if ($util->diagnostic());
    
    use Cwd;
    my $whence = Cwd::cwd();
    
    my $root = $self->{ROOT};
    chdir $root or $util->error("chdir $root failed");

    my $sis_file = "${output_dir}/${target_name}";

    my $pkg_file = $self->{PKGFILE};
    $util->invoke("makesis $args $pkg_file ${sis_file}.unsigned.SIS");
    
    my $key = shift;
    my $certificate = shift;
    my $passphrase = shift;
    
    $util->invoke("signsis", "-s $args", "${sis_file}.unsigned.SIS",	 
		  "${sis_file}.SIS", "$certificate", "$key", "$passphrase");
    
    $util->invoke("signsis", "-o", "${sis_file}.SIS")
	if ($util->level() >= $util->info());

    chdir "$whence" or $util->error("chdir $whence failed");
}

#
# Generate the make and project files.
#
sub make_make_src
{
    my $self = shift;
    die "self not defined\n" if (not defined($self));

    my $util = $self->{UTIL};
    my $output_dir = $self->{OUTPUT_DIR};
    my $target_name = $self->{TARGET_NAME};

    $util->info("Generating project files\n");

    open(BLDFILEWRITE, "> ${output_dir}/bld.inf") or 
	$util->error("Could not open bld.inf!");
    
    print BLDFILEWRITE <<_____VERBATIM_____;
// Project files
prj_mmpfiles
${target_name}.mmp
_____VERBATIM_____

	close BLDFILEWRITE;

    open(MMPFILEWRITE, "> ${output_dir}/${target_name}.mmp") or 
	$util->error("Could not open ${output_dir}/${target_name}.mmp!");
    
    print MMPFILEWRITE <<_____VERBATIM_____;
CAPABILITY	  TCB
TARGET		  ${target_name}.exe
TARGETTYPE	  exe
UID		  0x1000007A $self->{UID}
_____VERBATIM_____

if (defined($self->{VID}))
{
    print MMPFILEWRITE <<_____VERBATIM_____;
VENDORID	  $self->{VID}
_____VERBATIM_____
}

    print MMPFILEWRITE <<_____VERBATIM_____;
SOURCEPATH	  .
SOURCE		  ${target_name}.cpp
MW_LAYER_SYSTEMINCLUDE_SYMBIAN
OS_LAYER_SYSTEMINCLUDE_SYMBIAN
LIBRARY		  euser.lib
LIBRARY		  EFSRV.lib
LIBRARY		  hash.lib 
LIBRARY		  hal.lib
_____VERBATIM_____

    close MMPFILEWRITE;
}

#
# Generate the application code.
#
sub make_source_src()
{
    my $self = shift;
    die "self not defined" if (not defined($self));

    my $platform = $self->{PLATFORM};
    my $variant  = $self->{VARIANT};
    my $target_name = $self->{TARGET_NAME};
    my $util = $self->{UTIL};
    my $output_dir = $self->{OUTPUT_DIR};

    $util->info("Generating source code\n");

    open(FILEWRITE, "> ${output_dir}/${target_name}.cpp") or 
	log->error("Could not open $target_name!");
    
    my $datentime = $util->timestamp();
    my $storesize = 0;

    print FILEWRITE <<_____VERBATIM_____;
// ${target_name}.cpp
//
// Copyright (c) 2005 Symbian Ltd. All rights reserved.
//

/** \@file ${target_name}.cpp
* Deliver an update to the writable SwiCertstore on a device.
*
* The certificate store is embedded in the executable.
*
* This source code was generated on $datentime
* by SwiCertStoretobin.pl
*/

/** \@mainpage
*
* The Writable SWI certstore forms part of the security subsystem. The
* certificates in the SWI certstore are used by SWIS to perform checks
* when installing software on the device and indirectly by clients of
* the unified certstore.
*
* Updates to the certstore are atomic.	No partial updates to the
* writable certstore are permitted.
*
* The writable SWI certstore will be written to a TCB only writable
* area on the system drive, "\\\\Resource\\\\SwiCertstore\\\\dat\\\\", 
* and will complement the SWI certstore, 
* "Z:\\\\resource\\\\swicertstore.dat", in ROM.
*
* Once the certstore update is installed in the handset, dependent
* processes (processes that have loaded Swicertstore.dll) will each
* synchronise their internal state at the earliest opportunity.
*
* The generated source code varies with the certstore and therefore
* the generated executable cannot be used to deliver other updates to
* the device.  
* 
* $target_name.exe takes no command line options and is not run-time
* configurable in any way.
*/

#include <e32def.h>
#include <e32err.h>
#include <f32file.h>
#include <e32debug.h>
#include <e32property.h>
#include <hash.h>
#include <unifiedcertstore.h>
#include <f32file.h>
#include <hal.h>

namespace 
{
    const TInt KTimeOut(2000000);

_____VERBATIM_____

my $input_file = $self->{INPUT_FILE};
if (-z $input_file)
{
    print FILEWRITE <<_____VERBATIM_____;
    TUint8 *rawdata(0);
_____VERBATIM_____
}
else
{
print FILEWRITE <<_____VERBATIM_____;
    TUint8 rawdata[] = 
    {
_____VERBATIM_____
	    
        open(FILEREAD, "< $input_file") or $util->error("Could not open $input_file!");
	
	binmode FILEREAD;
	
        $storesize = (stat FILEREAD)[7];

	my $byte;
	my $rv;

        $util->detailed("Embedding data.\n");

        my $prefix = $util->prefix();
        $util->prefix('');

	print FILEWRITE "\t";
	for (my $count = 1;; ++$count)
	{
	    $util->detailed(".");
	    
	    # Restrict width of dot pattern
	    $util->detailed("\n") if ($count != 0 and ($count % 70) == 0);
	    
	    read(FILEREAD, $byte, 1) or last;
	    my $v = unpack "C", $byte;
	    
	    if ($v < 0x10)
	    {
		# Aesthetics
		printf FILEWRITE "0x0%x", $v;
	    }
	    else
	    {
		printf FILEWRITE "0x%x", $v;
	    }

	    print FILEWRITE ","	 if ($count != $storesize);
	    print FILEWRITE "\n\t" if (($count % 15) == 0);
	}
	print "\n";
        
        $util->prefix($prefix);

    print FILEWRITE <<_____VERBATIM_____;
    };
_____VERBATIM_____
}

my $digest = $self->{UTIL}->certstore_digest($self->{INPUT_FILE});
my $tmp_name = $self->{UTIL}->tmp_name($target_name, $self->{UID}, $digest);

print FILEWRITE <<_____VERBATIM_____;
	const TInt KRawDataLength($storesize);

	_LIT(KDriveSpec, "!:\\\\");
	_LIT(KSwiCertstoreDatDir, "\\\\Resource\\\\SwiCertstore\\\\dat\\\\");
	_LIT(KSwiCertstoreTmpDir, "\\\\Resource\\\\SwiCertstore\\\\tmp\\\\");
	_LIT(KSwiCertstoreTmpFile, 
	 "\\\\Resource\\\\SwiCertstore\\\\tmp\\\\$tmp_name");
	_LIT8(KSwiCertstoreDigest, "$digest");
	_LIT(KUpdate, "Swicertstore Update error");
}

EXPORT_C TDriveNumber GetSystemDrive()
	{
	TDriveNumber driveNo = RFs::GetSystemDrive();
	return driveNo;
	}

EXPORT_C TChar GetSystemDriveChar(TDriveNumber aDriveNumber)
	{
	TChar driveChar;	
	RFs::DriveToChar(aDriveNumber, driveChar);
	return driveChar;
	}

/**\@brief Ensure that the temporary file is cleaned up if a leave
 *	occurs.
 */ 
void CleanUpTmpFile(TAny *)
	{
	RFs rfssession;

	if (KErrNone != rfssession.Connect())
		{
		return;
		}
    
	TBuf<3> driveSpec(KDriveSpec);
	driveSpec[0] = GetSystemDriveChar(GetSystemDrive());
	rfssession.SetSessionPath(driveSpec);
	
	// Ignore errors
	rfssession.Delete(KSwiCertstoreTmpFile);
	rfssession.Close();
	}

/**\@brief Create the writable SwiCertStore\'s temp and data
 * directories.
 * 
 * \@param aFs A file server session.
 */
void CreateDirsL(RFs &aFs)
	{
	// Create the temp directory where writers ($target_name.exe)
	// will write their temporary files prior to renaming
	
	TInt result(aFs.MkDirAll(KSwiCertstoreTmpDir));
	
	if (KErrAlreadyExists != result and KErrNone != result)
		{
		User::Leave(result);
		}
	
	// Writers ($target_name.exe) will atomically rename (move) their
	// temporary files into KSwiCertstoreDatDir
	
	result = aFs.MkDirAll(KSwiCertstoreDatDir);
	
	if (KErrAlreadyExists != result and KErrNone != result)
		{
		User::Leave(result);
		}
	}

/**\@brief List the contents of the specified directory.
 *
 * \@note The caller is responsible for deleting the memory pointed to
 * by the returned pointer.
 *
 * \@param aFs A file server session.
 * \@param aFn The directory to list.
 *
 * \@return A list of directory entries.
 */
CDir *LsLC(RFs &aFs, const TDesC &aFn)
	{
	CDir *entry_list(0);
	
	User::LeaveIfError(aFs.GetDir(aFn, KEntryAttNormal,
								  ESortByName | EDescending, entry_list));
	
	// The caller is responsible for cleaning up the entry_list
	CleanupStack::PushL(entry_list);
	
	return entry_list;
	}

/**\@brief Get the target filename for the update.
 *
 * The returned filename is generated by incrementing the highest
 * numbered filename in directory
 * "\\\\Resource\\\\SwiCertstore\\\\dat".
 *
 * \@note The caller is responsible for deleting the memory pointed to
 * by the returned pointer.
 *
 * \@param aFs A file server session.
 * \@param aFn A preallocated buffer to hold the filename.
 *
 * \@return A list of directory entries. 
 */
CDir *GetNextFileNameLC(RFs &aFs, TFileName &aFn)
	{
	CDir *entry_list(LsLC(aFs, KSwiCertstoreDatDir));
	
	aFn = KSwiCertstoreDatDir;
	
	TInt number(1);
	
	if (entry_list->Count() > 0)
		{
		const TEntry &item((*entry_list)[0]);
		
		__ASSERT_ALWAYS(EFalse == item.IsDir(), User::Panic(KUpdate,
															KErrCorrupt));
		
		TLex lexer(item.iName);
		const TInt result(lexer.Val(number));
		
		if (KErrNone != result)
			{
			User::Panic(KUpdate, result);
			}
		
		number += 1;
		}
	
	aFn.AppendNumFixedWidth(number, EDecimal, 8);
	
	return entry_list;
	}

/**Convert a hex char to its decimal representation.
 *
 * \@param aCh The char to convert.
 *
 * \@return The integer representation of the supplied char.
 */
TInt ToIntL(const TChar aCh)
	{
	TInt a(-1);
	
	if ((aCh >= 'A') and (aCh <= 'F'))
		{
		a = aCh - 'A' + 10;
		}
	if ((aCh >= 'a') and (aCh <= 'f'))
		{
		a = aCh - 'a' + 10;
		}
	else if (aCh >= '0' and aCh <= '9')
		{
		a = aCh - '0';
		}
	else
		{
		User::Leave(KErrCorrupt);
		}
	
	__ASSERT_ALWAYS((a >= 0 and a < 16), 
			User::Panic(KUpdate, KErrCorrupt)); // four bits
	
	return a;
	}

/**\@brief Convert two hex characters to a single byte.
 *		
 * \@param aChars A pointer to the char sequence to convert.
 *
 * \@param aBuf A reference to a buffer that will contain the
 * binary representation of the char sequence.	The buffer must be be
 * at least half the length of the char sequence.
 */
template <TInt length>
void Hex2BinL(TBuf8<length> &aBuf, TPtrC8 aChars)
	{
	__ASSERT_ALWAYS((aChars.Length() == 2 * length), User::Panic(KUpdate, 
																 KErrArgument));
	__ASSERT_ALWAYS((length % 2 == 0), User::Panic(KUpdate, KErrArgument));
	
	for (int idx(0), appends(0); appends < length; ++appends, idx += 2)
		{			
		aBuf.Append((ToIntL(aChars[idx]) << 4) | ToIntL(aChars[idx + 1]));
		}
	}

/**\@brief Verify the integrity of the writable cerstore on disk.
 *
 * \@param aFs A file server session.
 * \@param aName The name of the file to verify.
 */
void VerifyL(RFs &aFs, const TDesC &aName)
	{
	RFile file;

	User::LeaveIfError(file.Open(aFs, aName,
								 EFileRead | EFileShareExclusive));
	CleanupClosePushL(file);

	TBuf8<1024> block;
	
	CMD5* md5 = CMD5::NewL();
	CleanupStack::PushL(md5);
	
	for (;;)
		{
		User::LeaveIfError(file.Read(block));
		
		if (block.Size() > 0)
			{
			md5->Update(block);
			continue;
			}
		
		break;
		}
	
	TBuf8<MD5_HASH> hash(md5->Final());
	CleanupStack::PopAndDestroy(md5);
	
	TBuf8<MD5_HASH> referencehash;
	
	TPtrC8 digest(KSwiCertstoreDigest);
	
	// Convert the hex digest to binary.  Convert each hex character
	// to four bits
	Hex2BinL(referencehash, digest);
	
	if (referencehash != hash)
		{
		User::Leave(KErrCorrupt);
		}
	
	CleanupStack::PopAndDestroy(); // file
	}

/**\@brief Start the writable SwiCertstore update.
 * 
 * The update is atomic.
 */
void StartL(void)
	{
	TPtr8 data(rawdata, KRawDataLength, KRawDataLength);
	
	RFs rfssession;
	
	User::LeaveIfError(rfssession.Connect());
	CleanupClosePushL(rfssession);
		
	TBuf<3> driveSpec(KDriveSpec);
	driveSpec[0] = GetSystemDriveChar(GetSystemDrive());
	User::LeaveIfError(rfssession.SetSessionPath(driveSpec));		
	
	CreateDirsL(rfssession);
	
	// Ensure that the tmp file is cleaned up if a leave occurs
	CleanupStack::PushL(TCleanupItem(CleanUpTmpFile, 0));
	
	RFile file;	
	
	// If the temp file already exists we will overwrite it.  UIDs are
	// unique after all.
	User::LeaveIfError(file.Replace(rfssession, KSwiCertstoreTmpFile, 
									EFileWrite | EFileShareExclusive));
	
	CleanupClosePushL(file);

	// write is not atomic
	User::LeaveIfError(file.Write(data, KRawDataLength));
	
	User::LeaveIfError(file.Flush());
	CleanupStack::PopAndDestroy(); // file
	
	VerifyL(rfssession, KSwiCertstoreTmpFile);
	
	TFileName fullpath;
	
	CDir *entry_list(0);
	for (;;)
		{
		entry_list = GetNextFileNameLC(rfssession, fullpath);
		
		CleanupStack::Check(entry_list);
		
		// RFs::Rename is atomic for non-removeable media even in the
		// event of power failure
		TInt result(rfssession.Rename(KSwiCertstoreTmpFile, fullpath));
	
		if (KErrInUse == result or KErrAlreadyExists == result)
			{
			// It might be that another writer wrote fullpath first.
			// We will need to scan the directory again
			CleanupStack::PopAndDestroy(entry_list);
			continue;
			}
		
		if (KErrNone == result)
			{
			// entry_list remains on the cleanup stack and is used
			// later
			CleanupStack::Check(entry_list); 
			break;
			}
		
		User::Leave(result);
		}
	
	// We can now notify all parties that are interested in the
	// update.
	const TInt result(RProperty::Set(KUnifiedCertStorePropertyCat, 
									 EUnifiedCertStoreFlag, 1));

	// If property has not been defined then no one is interested in
	// the update
	
	if (KErrNotFound != result and KErrNone != result)
		{
		User::Leave(result);
		}
	
	// Wait for an arbitrary amount of time, in the hope that readers
	// will have closed any other files in KSwiCertstoreDatDir,
	// before attempting to delete all files in KSwiCertstoreDatDir
	// apart from the update we have just placed there.
	
	User::After(KTimeOut);
	
	for (TInt idx(0), sz(entry_list->Count()); idx < sz; ++idx)
		{
		const TEntry &item((*entry_list)[idx]);
		
		fullpath = KSwiCertstoreDatDir;
		fullpath.Append(item.iName);
	
		// Ignore errors - delete as much as possible.	 It may be
		// that a legacy file is currently being read (KErrInUse)
		rfssession.Delete(fullpath);
		}
	
	CleanupStack::PopAndDestroy(entry_list);
	
	// We pop this here because it is now on the top of the stack.
	// It could in fact has been dealt with following a successful
	// rename except that the cleanupitem was not on the top of the
	// stack at that point.
	CleanupStack::Pop(); // cleanupfile
	
	// Now delete any temporary files in the temp directory. There
	// may be other simultaneous update attempts in which case we may
	// be about to defenestrate these.	 This race condition is
	// considered acceptable since there is no agreed protocol
	// between writers and we must clean up ealier failed updates
	// attempts at some point.
	entry_list = LsLC(rfssession, KSwiCertstoreTmpDir);
	
	for (TInt idx(0), sz(entry_list->Count()); idx < sz; ++idx)
		{
		const TEntry &item((*entry_list)[idx]);
		
		fullpath = KSwiCertstoreTmpDir;
		fullpath.Append(item.iName);
	
		// Ignore errors - delete as much as possible.	 It may be
		// that a legacy file is currently being read (KErrInUse)
		rfssession.Delete(fullpath);
		}
	
	
	CleanupStack::PopAndDestroy(2, &rfssession);
	}

/**\@brief Main.
 *
 * \@return A status code.
 */
TInt E32Main(void)
	// No arguments are permitted
	{
	__UHEAP_MARK;
	
	const CTrapCleanup *const stack(CTrapCleanup::New());
	TInt result(KErrNoMemory);
	
	if (stack)
		{
		TRAP(result, StartL());
		
		if (KErrNone != result)
			{
			// Register with the task scheduler and try again later? 
			}
		
		delete stack;
		}
	
	__UHEAP_MARKEND;

	return result;
	}

_____VERBATIM_____
    
    close FILEWRITE;
}

#
# Set the logging level
#
sub level
{
    my $self = shift;
    die "self not defined\n" if (not defined($self));

    if (@_) { $self->{LEVEL} = shift }
    return $self->{LEVEL};
}

1;  # so the require or use succeeds

