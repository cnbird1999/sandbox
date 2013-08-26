#!/usr/bin/perl

package Runlib::Role::LOG_methods;

use Term::ANSIColor qw(:constants); 
use File::Copy;
use Text::CSV;
use DBI;
use Moose::Role;

=head2 get_logs
	
	Save work results from sandbox

=cut

sub get_logs {
	my ( $self ) = shift;

 	print "Getting logs..\n";
	
	opendir my $dir_h, $self->task_folder or die RED, $!, RESET;
	my @files = readdir $dir_h;

	if ( defined $files[2] ) {
		$self->log_storage( $self->log_storage.$files[2]."/" );
	} else {
		$self->log_storage( $self->log_storage.localtime(time)."/" );
	}	

	mkdir $self->log_storage, 0700 or die RED, $!, RESET;
	closedir $dir_h;

	opendir $dir_h, $self->log_folder or die RED, $!, RESET;
	@files = readdir $dir_h;

	foreach ( @files ) {
		next if $_ eq "." or $_ eq "..";
		print "\t".$_."\n";
		move ($self->log_folder.$_, $self->log_storage.$_) or die $!;
	}

	closedir $dir_h;

	if ( @files ) {
		print "  Logs have been saved.. \n"; 
		return 0;
	}

	die RED, "Error in getting logs!", RESET;
}

=head2 export_logs

	Export logs from CSV file into database

=cut

sub export_logs {
	my ( $self ) = shift;

	my $csv_h = Text::CSV->new({ sep_char => ',', binary => 1 });

	opendir my $dir_h, $self->log_storage or die RED, $!, RESET;
	my @dirs = readdir $dir_h or die $!;
	closedir $dir_h;

	if ( @dirs == 2 ) {
		print RED, "There are no logs!\n", RESET;
		return 1;
	}
	
	foreach my $item ( @dirs ) {
		next if -d $item;
		
		open my $file_h, "<", $self->log_storage.$item or die RED, $!, RESET;
		while( <$file_h> ) {
			next if $. == 1;
			$_ =~ s/\r\n/,/g;

			if ( $csv_h->parse($_) ) {
				 print join(" ", $csv_h->fields()), "\n";
			} else {
				warn RED, "Fields not recognized!\n", RESET, $csv_h->error_diag;
			}

		}
		close $file_h;
	}

	my $db_h = DBI->connect( "DBI:mysql:".$self->export_db, $self->db_user, $self->db_pass ) 
						or die RED, "Error connecting database!", RESET;

	$db_h->disconnect;
}

1;
