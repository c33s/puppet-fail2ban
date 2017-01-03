# Setup a fail2ban jail.
define fail2ban::jail (
  $port,
  $filter,
  $logpath,
  $ensure     = present,
  $enabled    = true,
  $protocol   = undef,
  $maxretry   = undef,
  $findtime   = undef,
  Variant[String, Array[String], Undef] $action     = undef,
  $banaction  = undef,
  $bantime    = undef,
  $ignoreip   = undef,
  $order      = $::fail2ban::default_jail_order,
  $backend    = false,
  $use_jail_d = $::fail2ban::use_jail_d,
) {
  include fail2ban::config

  if $use_jail_d {
      file {"/etc/fail2ban/jail.d/${name}.conf":
        ensure => $ensure,
        owner => 'root',
        group   => 0,
        mode => '0664',
        content => template('fail2ban/jail.erb'),
      }
  } else {
    if $ensure != present {
      warning('The $ensure parameter is now deprecated for the use with $use_jail_d=false! to ensure that a fail2ban jail is absent, simply remove the resource.')
    }

    # This has an implicit ordering that ensures proper functioning: the main
    # fragment is defined in the 'fail2ban::config' class and each fragment
    # implicitly requires the main concat target. Consequently, those fragments
    # are sure to be dealt with after package installation.
    concat::fragment { "jail_${name}":
      target  => '/etc/fail2ban/jail.local',
      content => template('fail2ban/jail.erb'),
    }

    Concat::Fragment["jail_${name}"] {
      order => $order,
    }
  }
}