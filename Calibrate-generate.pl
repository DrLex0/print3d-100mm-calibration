#!/usr/bin/perl
# Generates all variations on the 100mm Calibration files.
# Options:
#   -k to keep the generated .gcode files.
#   -f RATE to set a custom feed rate.
use strict;
use warnings;


my $keep = 0;
my $customFeed = 0;

while(@ARGV) {
	my $arg = shift;
	if($arg eq '-k') {
		$keep = 1;
	}
	elsif($arg eq '-f') {
		$customFeed = shift;
		if(! $customFeed || $customFeed !~ /^\d*\.?\d+$/) {
			print STDERR "Error: -f option must be followed by a number\n";
			exit(2);
		}
	}
	else {
		print STDERR "Warning: ignoring unknown argument '${arg}'\n";
	}
}

# Extrusion temperatures
for my $temp (180, 200, 220, 240, 260, 280) {
	for my $template ('Calib100mm-left', 'Calib100mm-right') {
		my $filth = 0;
		my $in_file = "${template}.gcode";
		my $out_file = $in_file;
		$out_file =~ s/^([^-]+)-(.*)$/$1-${temp}C-$2/;
		die "Epic failure" if($out_file eq $in_file);

		my $fHandle;
		open($fHandle, '<', $in_file) or die "Cannot read from ${in_file}: $!";
		my @slurp = (<$fHandle>);
		close($fHandle);
		chomp(@slurp);

		open($fHandle, '>', $out_file) or die "Cannot write to ${out_file}: $!";
		foreach my $line (@slurp) {
			if($line =~ /\r$/) {
				$filth = 1;
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
		system("make_fcp_x3g -P \"${out_file}\"");

		# WHEN WILL THE WORLD DROP SUPPORT FOR TELETYPE MACHINES?
		print "Warning: file '${in_file}' contains carriage returns!\n" if($filth);
		unlink($out_file) unless($keep);
		print "Generated and processed '${out_file}'\n";
	}
}
