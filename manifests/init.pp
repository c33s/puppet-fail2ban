# modules/fail2ban/manifests/init.pp - manage fail2ban stuff
# Copyright (C) 2007 admin@immerda.ch
# Copyright (C) 2014-2016 gabster@lelutin.ca
#

class fail2ban (
  $ignoreip           = '127.0.0.1',
  $bantime            = '600',
  $findtime           = '600',
  $maxretry           = '3',
  $backend            = 'auto',
  $destemail          = 'root@localhost',
  $banaction          = 'iptables-multiport',
  $mta                = 'sendmail',
  $protocol           = 'tcp',
  $action             = '%(action_)s',
  $purge_jail_dot_d   = true,
  $use_jail_d         = false,
  $default_jail_order = false,
  $defailt_jails      = {},
) {
  anchor { 'fail2ban::begin': } ->
  class { 'fail2ban::install': } ->
  # class { 'fail2ban::default_jails': } ->
  class { 'fail2ban::config': } ~>
  class { 'fail2ban::service': } ->
  anchor { 'fail2ban::end': }

  $defailt_jails.each |String $name, Hash $parameters | {
    # notice("${name} = ${parameters}")
    class { "::fail2ban::jail::${name}":
      * => $parameters
    }
  }
}