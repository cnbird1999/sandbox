#!/usr/bin/perl

use warnings;
use strict;
use Runlib;

my $runvm_h = Runlib->new( 
	image_name 		=> 'your_image_name',
	snapshot_name	=> 'your_snapshot_name',
	log_storage		=> "path_where_log_will_be_saved"
);

$runvm_h->find_machine_image;
$runvm_h->start_and_wait_image;
$runvm_h->get_logs;
$runvm_h->restore_vm_state;
$runvm_h->export_logs;

exit 0;

=head1 NAME

runsandbox.pl

=head1 DESCRIPTION

Script for execution malware in sandbox

=head1 OPTIONS FOR OBJECT CREATION 


=over 4

=item 	image_name

operating system image name with *.bat file, that runs malware
in autorun (see decloration of batfile structure)

=item	snapshot_name

snapshot to restore sandbox after the execution of malware

=item	log_storage

full path to the directory where I<logs to be saved>, analyzer will take logs from this place

=item	log_folder

full path to the directory where I<the sandbox will put logs>

=item	task_folder

full path to the directory sandbox will take a tasks from

=item	export_db

name of the database, logs will be saved in it after parsing

=item	db_user

name of the database user

=item	db_pass

password for the user to access database, B<warn! you must let this user to access to db only from localhost>

=back

=head1	SEE ALSO

for more information, you can see role files, that determinats methods, they are also able to be read by perldoc (i.e contains POD)

=cut


