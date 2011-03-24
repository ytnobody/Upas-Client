use inc::Module::Install;
name 'Upas-Client';
all_from 'lib/Upas/Client.pm';

# requires '';

tests 't/*.t';
author_tests 'xt';

test_requires 'Test::More';
auto_set_repository;
auto_include;
WriteAll;
