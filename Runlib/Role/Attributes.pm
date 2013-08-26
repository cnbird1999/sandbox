#!/usr/bin/perl

package Runlib::Role::Attributes;

use Moose::Role;

# elements of class Runlib, which associated with virtual environment

has image_name => (
	is			=> 'ro',
	default 	=> 'default_image_name',
	required 	=> 1
);

has log_folder => (
	is			=> 'rw',
	default		=> "path_where_sandbox_will_put_logs",
	required	=> 1
);

has log_storage => (
	is			=> 'rw',
	default		=> 'path_where_logs_will_be_saved',
	required	=> 1
);

has task_folder => (
	is			=> 'rw',
	default		=> "path_with_malware",
	required	=> 1
);

has snapshot_name => (
	is 			=> 'rw',
	default 	=> "default_snapshot_name",
	required	=> 1
);

# variables for work with db mysql

has export_db => (
	is			=> 'rw',
	default		=> "db_name"
);

has db_user	=> (
	is 			=> 'rw',
	default 	=> "db_user_name"
);

has db_pass => (
	is 			=> 'rw',
	default		=> "db_user_pass"
);

1;
