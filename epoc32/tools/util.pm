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

package Util;
use strict;

$Util::info = 1; # constant
$Util::detailed = 2; # constant
$Util::diagnostic = 3; # constant

$Util::warnings = 1; # constant
$Util::nowarnings = 0; # constant

##############################################
## the object constructor                   ##
##############################################
sub new($;$$)
{
    my $self = {};
    
    shift @_;

    bless($self);

    $self->argcount(3, @_);

    $self->{LEVEL} = shift @_; # Used to set the logging level
    $self->{WARNINGS} = shift @_; # log flag
    $self->{PREFIX} = shift @_; # log prefix
    
    return $self;
}

##############################################
## Class methods to access per-object data  ##
##                                          ##
##############################################

#
# Check expected number of args
#
sub argcount(@)
{
    my $self = shift;
    die "self not defined\n" if (not defined($self));

    my ($expected_num, @args) = @_;
    my $actual_num = scalar(@args);
    
    if ($actual_num != $expected_num)
    {
	$self->error("Expected $expected_num args, got $actual_num");
    }
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

#
# 
#
sub diagnostic
{
    my $self = shift;
    die "self not defined\n" if (not defined($self));

    if (@_) { $self->{DIAGNOSTIC} = shift }
    return $self->{LEVEL} == $Util::diagnostic;
}

#
# Set/Get the prefix
#
sub prefix
{
    my $self = shift;
    die "self not defined\n" if (not defined($self));

    if (@_) { $self->{PREFIX} = shift }
    return $self->{PREFIX};
}

#
# Log errors to stderr
#
sub error(@)
{
    my $self = shift;
    die "self not defined\n" if (not defined($self));

    my $prefix = $self->prefix();
    $prefix = "${prefix}Error: ";
    
    if (($? >> 8) != 0) { die "${prefix}@_: $!\n" }

    die "${prefix}@_\n";
}

#
# Log if the warnings flag is set
#
sub warning(@)
{
    my $self = shift;
    die "self not defined\n" if (not defined($self));

    return $self->{WARNINGS} if (not @_); 

    my $prefix = $self->prefix();

    print STDERR "${prefix}Warning: @_\n" if ($self->{WARNINGS});
}

#
# Log info to stdout dependent on log level
#
sub info(@)
{
    my $self = shift;
    die "self not defined\n" if (not defined($self));

    return $Util::info <= $self->{LEVEL} if not @_;
    
    my $prefix = $self->prefix();
    
    print STDOUT "${prefix}@_" if ($Util::info <= $self->{LEVEL});
}

#
# Log info to stdout dependent on log level
#
sub detailed(@)
{
    my $self = shift;
    die "self not defined\n" if (not defined($self));

    return $Util::detailed <= $self->{LEVEL} if not @_;
    
    my $prefix = $self->prefix();
    
    print STDOUT "${prefix}@_" if ($Util::detailed <= $self->{LEVEL});
}

# 
# Generate a unique temporary name 
#
sub tmp_name(@)
{
    my $self = shift;
    die "self not defined\n" if (not defined($self));
 
    $self->detailed("Generate temporary name based on @_\n");
    
    use Digest::MD5;
    my $md5 = Digest::MD5->new;
    
    use Cwd;
    my $path = Cwd::cwd();
    my $template = "${path}/XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX";

    use File::Temp;
    (undef, my $tmpfilename) = File::Temp::tempfile($template, OPEN => 0);
    
    $md5->add($tmpfilename);
    $md5->add(time); # time returns number of non-leap seconds since the epoc
    
    foreach (@_)
    {
	$md5->add($_);
    }
    
    return $md5->hexdigest;
}

#
# Generate a digest of the certstore.  Because the digest is used to
# construct the temporary filename name, the Symbian OS limits the
# size of path and file names, Md5 is used.
#
sub certstore_digest($)
{
    my $self = shift;
    die "self not defined\n" if (not defined($self));

    $self->argcount(1, @_);

    my $input_file = shift @_;
  
    $self->detailed("Generate digest from '$input_file'\n");
    
    open(FILEREAD, "< $input_file") 
	or $self->error("Could not open $input_file!");
    
    binmode FILEREAD;
    
    use Digest::MD5;
    
    my $md5 = Digest::MD5->new;
    
    $md5->addfile(*FILEREAD);
    
    close FILEREAD;
    
    return $md5->hexdigest;
}

#
# Generate a timestamp
#
sub timestamp()
{
    my $self = shift;
    die "self not defined\n" if (not defined($self));

    $self->argcount(0, @_);

    (my $sec, my $min, my $hour, my $mday, my $mon,
     my $year, my $wday, my $yday, my $isdst) = localtime(time);
    
    return sprintf("%4d-%02d-%02d @ %02d:%02d:%02d", $year+1900,
		   $mon+1, $mday, $hour, $min, $sec);
}

# Execute a command.  For tools such as abld, which don't return an
# error status if the build fails, we must grep stdout and stderr for
# errors.
sub invoke(@)
{
    my $self = shift;
    die "self not defined\n" if (not defined($self));

	my $sbsflag = index("@_", "sbs");
	
    $self->info("Invoking: @_\n");

    # Redirect stderr into stdout.
    open(SAVEOUT, "@_ 2>&1 |") or $self->error("couldn't invoke @_");

    my @out = <SAVEOUT>;
    
    close SAVEOUT;
    
  
    # Check for errors in the output
    $self->detailed("Interpreting results of previous invocation\n");

    my @warnstrings = ();

  	if($sbsflag != -1)
 	{
 		foreach (@out)
 		{
 		$self->error(@out) if (/errors:\s[^0]/i);
 		
 		# build list of warnings
 		push (@warnstrings, $_) if ($self->warning and /warnings:\s[^0]/i);
 		}
 	}
 	else 
 	{
 		foreach (@out)
 		{
 		$self->error(@out) if (/Error/i);
 		
 		# build list of warnings
 		push (@warnstrings, $_) if ($self->warning and /Warning/i);
 		}
 	}

    # Issue warnings only if detailed logging has not been enabled
    # since if it has then all warnings will be printed anyway
    if (not $self->detailed()) { $self->warning(@warnstrings) }
    else { $self->detailed(@out) }

#    log->warning(@warnstrings) if (@warnstrings and $verbose < $detailed);
}

1;  # so the require or use succeeds
