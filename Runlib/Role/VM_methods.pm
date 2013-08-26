#!/usr/bin/perl

package Runlib::Role::VM_methods;

use Moose::Role;
use Term::ANSIColor qw(:constants);

=head2 find_machine_image

	This function trying to locate requested image
	check if all disk's where mounted, this may rise an error

=cut

sub find_machine_image {
	my ( $self ) = shift;

	print GREEN, "Starting vm ", $self->image_name, " ..\n", RESET, " Trying to access requested image.. \n";
	
	my $start_log = `vboxmanage list vms`;
	$start_log =~ s/"//g;
	my %images = split /\s/,$start_log;
	
	die RED, "Specified image was not found! Check your settings!", RESET if not defined $images{$self->image_name}; 

	print "  Found a disk image..\n   ";
	return 0;
}

=head2 start_and_wait_image

	Start virtualbox image and wait for it completion
	machine is run in headless mode
	Virtual machine must not work more then 15 minutes

=cut

sub start_and_wait_image {
	my ( $self ) = shift;

	my $pid = fork();

	die RED, $!, RESET if not defined $pid;

	if ( $pid == 0 ) {
		open STDOUT, ">", "/dev/null" or exit 1;
		open STDERR, ">&", \*STDOUT or exit 1;
		exec '/usr/bin/vboxheadless', '--startvm', $self->image_name or die RED, $!, RESET;
	} 
	
	print "Virtual machine was started, it will run for 15 minutes..\n";
	waitpid $pid, 0 or die RED, $!, RESET;

	die RED, "Error in starting virtual machine!\n", RESET if $?; 

	print GREEN, "Virtual machine stoped.\n ", RESET;
	return 0;
}

=head2 restore_vm_state

	Restore is required, due to the fact of infection by malware.

=cut

sub restore_vm_state {
	my ( $self ) = shift;

	my $pid = fork(); 
	die RED, "Error in fork!", RESET if ( $pid == -1 );

	if ( $pid == 0 ) {
		open STDOUT, ">", "/dev/null" or exit 1;
		open STDERR, ">&", \*STDOUT or exit 1;
		exec '/usr/bin/vboxmanage', 'snapshot', $self->image_name, 'restore', $self->snapshot_name or die RED, $!, RESET;
	}

	print GREEN, "Restoring virtual machine state ..\n", RESET;
	waitpid $pid, 0 or die RED, $!, RESET;

	die RED, "Error in restoring vm state!", RESET if $?;

	print " Virtual machin's state was restored to snapshot named \"", $self->snapshot_name, "\" !\n";
	return 0;
}

1;
