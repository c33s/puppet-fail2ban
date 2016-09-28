define fail2ban::action (
  Array $actionstart = [],
  Array $actionstop = [],
  Array $actioncheck = [],
  Array $actionban,
  Array $actionunban,
  String $chain_name = 'default',
  String $mail = 'root',
  $ensure    = present,
) {
  include fail2ban::config

  validate_array($ignoreregexes)
  validate_array($includes)
  validate_array($includes_after)
  validate_array($additional_defs)

  file { "/etc/fail2ban/action.d/${name}.conf":
    ensure  => $ensure,
    content => template('fail2ban/action.erb'),
    owner   => 'root',
    group   => 0,
    mode    => '0644',
    require => Class['fail2ban::config'],
    notify  => Class['fail2ban::service'],
  }

}

