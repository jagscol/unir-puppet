#!/bin/bash
puppet apply --modulepath=/vagrant/modules:/opt/puppetlabs/puppet/modules:/etc/puppetlabs/code/environments/production/modules ./manifests/default.pp
