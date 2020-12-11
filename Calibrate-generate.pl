#!/usr/bin/perl
# Generates all variations on the 100mm Calibration files.
# Either run inside the directory where the 'Template' files are,
# or provide that directory with the -i argument.
# The gpx binary must be in your PATH to generate x3g files.
use strict;
use warnings;


sub usage
{
	print <<__END__;
Usage: $0 [-k] [-f F] [-i in_dir] [-o out_dir]
Generates all variations on the 100mm Calibration files, from two template
  files that must be in the input directory: 'Template-left.gcode' and
  'Template-right.gcode'. These files must contain specific comment lines,
  see the source code.

  -k: keep generated .gcode files.
  -f F: override feed rate with value F.
  -i in_dir: use templates in in_dir instead of looking in current directory.
  -o out_dir: write output files to out_dir.
__END__
}

# Extrusion temperatures to generate
my @temps = (180, 200, 220, 240, 260, 280);

# GPX machine type. Set to empty to disable X3G conversion.
my $machine = 'fcp';

my $inDir = '';
my $outDir = '';
my $keep = 0;
my $customFeed = 0;

while(defined($ARGV[0]) && $ARGV[0] =~ /^-/) {
	my $arg = shift;
	my @switches = split(//, $arg);
	shift(@switches);
	foreach my $sw (@switches) {
		if($sw eq 'h') {
			usage();
			exit(0);
		}
		elsif($sw eq 'k') {
			$keep = 1;
		}
		elsif($sw eq 'f') {
			$customFeed = shift;
			if(! $customFeed || $customFeed !~ /^\d*\.?\d+$/) {
				print STDERR "Error: -f option must be followed by a number\n";
				exit(2);
			}
		}
		elsif($sw eq 'i') {
			$inDir = shift;
			if(! $inDir || ! -d $inDir) {
				print STDERR "Error: -i option must be followed by a directory path\n";
				exit(2);
			}
		}
		elsif($sw eq 'o') {
			$outDir = shift;
			if(! $outDir || ! -d $outDir) {
				print STDERR "Error: -o option must be followed by an existing directory path\n";
				exit(2);
			}
		}
		else {
			print STDERR "WARNING: ignoring unknown switch '${sw}'\n";
		}
	}
}

$inDir .= '/' if($inDir && $inDir !~ m|/$|);
$outDir .= '/' if($outDir && $outDir !~ m|/$|);
$keep = 1 if(! $machine);

for my $temp (@temps) {
	for my $template ('left', 'right') {
		my $crlf = 0;
		my $in_file = "${inDir}Template-${template}.gcode";
		my $out_file = "${outDir}Calib100mm-${temp}C-${template}.gcode";
		die "Epic failure: refusing to overwrite template file" if($out_file eq $in_file);

		my $fHandle;
		open($fHandle, '<', $in_file) or die "Cannot read from ${in_file}: $!";
		my @slurp = (<$fHandle>);
		close($fHandle);
		chomp(@slurp);

		open($fHandle, '>', $out_file) or die "Cannot write to ${out_file}: $!";
		foreach my $line (@slurp) {
			if($line =~ /\r$/) {
				$crlf = 1;
				$line =~ s/\r$//;
			}
			if($customFeed && $line =~ /^G1 F\d*\.?\d+; Feed rate for the extrusions/) {
				$line =~ s/^G1 F\d*\.?\d+/G1 F${customFeed}/;
			}
			else {
				$line =~ s/^M104 S\d+ T(\d);( *Set extruder temperature here)/M104 S${temp} T$1;$2/i;
			}
			print $fHandle "$line\n";
		}
		close($fHandle);
		system("gpx -m ${machine} \"${out_file}\"") if($machine);

		# WHEN WILL THE WORLD DROP SUPPORT FOR TELETYPE MACHINES?
		print "Warning: file '${in_file}' contains carriage returns!\n" if($crlf);
		unlink($out_file) unless($keep);
		print "Generated and processed '${out_file}'\n";
	}
}
