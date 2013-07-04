class horizon::apache(
    $bind_address = '0.0.0.0',
    $listen_ssl   = false,
) {

    include apache::mod::wsgi
    include apache

    file { $::horizon::params::apache_config_file: }

    file_line { 'horizon_redirect_rule':
        path    => $::horizon::params::apache_config_file,
        line    => "RedirectMatch permanent ^/$ ${::horizon::params::apache_root_url}/",
        require => Package['horizon'],
        notify  => Service[$::horizon::params::apache_service]
    }

    file_line { 'httpd_listen_on_bind_address_80':
        path    => $::horizon::params::apache_listen_config_file,
        match   => '^Listen (.*):?80$',
        line    => "Listen ${bind_address}:80",
        require => Package['horizon'],
        notify  => Service[$::horizon::params::apache_service],
    }

    if $listen_ssl {
        file_line { 'httpd_listen_on_bind_address_443':
            path    => $::horizon::params::apache_listen_config_file,
            match   => '^Listen (.*):?443$',
            line    => "Listen ${bind_address}:443",
            require => Package['horizon'],
            notify  => Service[$::horizon::params::apache_service],
        }
    }

    file_line { 'horizon root':
        path    => $::horizon::params::apache_config_file,
        line    => "WSGIScriptAlias ${::horizon::params::apache_root_url} ${::horizon_params::django_wsgi}",
        match   => 'WSGIScriptAlias ',
        require => Package['horizon'],
    }

}
