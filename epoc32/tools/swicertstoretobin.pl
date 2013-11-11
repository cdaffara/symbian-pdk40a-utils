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
# This script can be used to generate an executable capable of
# delivering a SWI certstore to a device.
# 
#

use FindBin;
use lib $FindBin::Bin; 
use strict;

#
# Print version and copyright Message.
#
sub version()
{
    print STDOUT <<_____VERBATIM_____;
SwiCertStoretobin.pl V1.0.0

Copyright (c) 2005 Symbian Ltd. All rights reserved.
_____VERBATIM_____
    
    exit 0;
}

#
# Print example usage.
#
sub examples()
{
    print <<_____VERBATIM_____;

Example: Remove the generated tree. Generate source, project, and SIS
         .pkg files. Build the executable and signed SIS file.
         The default install location (drive C) is overridden to drive D.

SwiCertStoretobin.pl -cgm --docs -vvv --warnings -u 0x012,0x034 \\
-i swicertstore.dat -o swicertstoreupdater -C cacert.pem -K cakey.pem \\
-l vendor -n vendor -installdrive D

Example: Remove the generated tree and build reallyclean for -o
         target. Generate source and project files.

SwiCertStoretobin.pl -ccg -i swicertstore.dat -o swicertstoreupdater -u 0x012

Example: Remove the generated tree and build reallyclean for -o
         target. Generate source, project and SIS .pkg files.

SwiCertStoretobin.pl -ccg -i swicertstore.dat -o swicertstoreupdater \\
-u 0x012, -l vendor -n vendor

Example: Build the executable.

SwiCertStoretobin.pl -mvvv -o swicertstoreupdater

Example: Build the executable, signed SIS file, and documentation.

SwiCertStoretobin.pl -mvvv -C cacert.pem -K cakey.pem --docs -o swicertstoreupdater
_____VERBATIM_____

}

#
# Print a message about this program and how to use it.
#
sub usage()
{
    print <<_____VERBATIM_____;

This script can be used to generate an executable capable of
delivering a SWI certstore to a device. At least one of --generate,
--make, --clean or --docs must be specified.

-h | --help
   Print this (help) message.

-e | --examples
   Print usage examples.

--version
   Print the version number to stdout and exit.

-v | --verbose
   Set verbosity level.  Repeat up to three times for increased verbosity.

-w | --warnings
   Enable Warnings.

-g | --generate
   Generate the source, make and SIS .pkg files.  The SIS .pkg file
   will be created provided -l, -n, and -u are specified.

   -o TARGET_NAME | --output=TARGET_NAME 
      Specify the (suffix-less) generated output filename. The default
      target is 'SwiCertStoreUpdater'.  Note that this should _not_ be
      a path name.

   -c | --clean
      Set level.  Repeat up to two times for increased cleaning.
      
      -c Remove the generated source tree.

      -cc Remove the generated source tree and build reallyclean based
          on --platform and --variant.  If the project files don\'t
          exist, create them using either the -o target or
          the default target 'SwiCertStoreUpdater'.

   -d | --docs
      Generate html documentation for the generated source
      files. Requires doxygen.

   -b MAJOR,MINOR,SUB | --version=MAJOR,MINOR,SUB
      Specify the comma separated major, minor and build number to be
      added to the SIS .pkg file.  The default is 0,0,0.

   -l | --localised_vendor
      Localised vendor added to .SIS pkg file.

   -n | --non_localised_vendor
      Non localised vendor added to .SIS pkg file.

   -u UID,VID | --uidvid=UID,VID
      Specify the comma separated application UID and vendor
      identifier to be added to the project .mmp file.

      Note that whilst the UID is mandatory the VID may be ommitted
      (e.g. -u0x1234,0x4567 or -u0x1234, or -u0x1234).

   -s UID | --suid=UID 
      Specify the manadory SIS file UID to be added to the SIS .pkg 
      file.

   -i INPUT | --input=INPUT
      Specify the certstore input file.

   -r DRIVE| install_drive=DRIVE
      Specify the drive on which the executable should be installed. 
	  Default = C

-m | --make
   Compile generated sources into an executable.  The signed .SIS file
   will be created if both -c and -k are specified provided the .pkg
   exists.

   -t VARIANT | --type=VARIANT
      Build variant. Defaults to udeb.

   -p PLATFORM | --platform=PLATFORM
      The target platform. Defaults to winscw.

   -K KEYFILE | --key=KEYFILE
      A file containing the key required for signing the SIS file.
      Both key and certificate are mandatory when signing.

   -C CERTFILE | --certificate=CERTFILE
      A file containing the certificate required for signing. Both key
      and certificate are mandatory when signing.

   -P PASSPHRASE | --passphrase=PASSPHRASE
      An optional passphrase string.  This must be supplied if a
      passphrase was used when generating the key.

_____VERBATIM_____

   exit 0;
}

#
# Process command line arguments
#
sub main()
{
    use Cwd;
    my $root = Cwd::cwd();

    my $output_dir = "${root}/gen";
    my $target_name = "SwiCertStoreUpdater";
    
    my @uidvid = ();
    my $suid = '';

    my $sis = 0;
    my @mmb = (0,0,0);

    my $key = "";
    my $certificate = "";
    my $passphrase = "";
    my $localised_vendor = "";
    my $non_localised_vendor = "";

    my $verbose = 0; # Used to set the logging level
    my $warnings = 0; # toggle warnings
    my $input_file = '';

    my $generate = 0;
    my $make = 0;
    my $docs = 0;
    my $clean = 0;

    my $install_drive = "C";
    
    my $variant = "udeb"; 
    my $platform = "winscw";

    use Getopt::Long;

    Getopt::Long::Configure(("bundling", "pass_through"));  
    
    my @options = ('h|help' => sub { usage; },
		   'e|examples' => sub { examples; },
		   'v|verbose+' => \$verbose,
		   'w|warnings' => \$warnings,
		   'version' => sub { version; },
		   'd|docs' => \$docs,
		   'g|generate' => \$generate,
		   'i|input=s' => \$input_file,
		   'o|target_name=s' => \$target_name,
		   'm|make' => \$make,
		   't|type=s' => \$variant,
		   'p|platform=s' => \$platform,
		   'c|clean+' => \$clean,
		   'b|build_version=s'=> \@mmb,
		   'u|uidvid=s' => \@uidvid,
		   's|suid=s' => \$suid,
		   'K|key=s' => \$key,
		   'C|certificate=s' => \$certificate,
		   'P|passphrase=s' => \$passphrase,
		   'l|localised_vendor=s' => \$localised_vendor,
		   'n|non_localised_vendor=s' => \$non_localised_vendor,
           'r|install_drive=s' => \$install_drive);
    
    use Util;

    usage() if not GetOptions(@options);
    
    my $util = Util->new($verbose, $warnings, "swicertstoretobin.pl ");

    $util->warning("Ignoring unknown argument(s): @ARGV") if ($#ARGV + 1 != 0);

    if (not ($generate or $make or $docs or $clean))
    {
	$util->error("At least one of --generate, --make, --docs or --clean",
		     " must be specified");
    }

    if (not $target_name)
    {
	$util->error("Target must be specified, please use the -o option.");
    }
	
	if (! $install_drive =~ /[A-Z!]/i)
	{
	$util->error("Install drive not recognised.");
	}
    
    $output_dir = $output_dir . "/$target_name";

    (my $uid, my $vid) = split(/,/, join(',', @uidvid));

    use AppGen;
    my $appgen = AppGen->new($platform, $variant, $target_name, $output_dir, 
			     $util, $input_file, $uid, $vid, $install_drive);
    
    if ($clean)
    {
	$appgen->clean($clean);
    }

    my ($major, $minor, $buildnum) = split(/,/, join(',', @mmb));

    if ($generate)
    {
	$appgen->generate($major, $minor, $buildnum, $suid, $localised_vendor,
			  $non_localised_vendor);
    }
    
    if ($make)
    {
	$appgen->make($key, $certificate. $passphrase);
    }
    
    if ($docs)
    {
	$appgen->make_doc();
    }
}

main();
