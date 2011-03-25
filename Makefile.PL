use inc::Module::Install;
name 'Upas-Client';
all_from 'lib/Upas/Client.pm';

requires 'parent';
requires 'Cache::Memcached::Fast';
requires 'Storable';
requires 'Acme::Damn';
requires 'Hash::AsObject';

tests 't/*.t';
author_tests 'xt';

test_requires 'Test::More';
test_requires 'Test::TCP';
test_requires 'Upas';

auto_set_repository;
auto_include;
WriteAll;
