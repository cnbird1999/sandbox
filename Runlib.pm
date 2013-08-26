#!/usr/bin/perl

=head1

	This is module for virtual malware analyze environment 

=cut

package Runlib;

use Moose;
use namespace::autoclean;

with qw( Runlib::Role::Attributes
		 Runlib::Role::VM_methods
		 Runlib::Role::LOG_methods );

__PACKAGE__->meta->make_immutable;
