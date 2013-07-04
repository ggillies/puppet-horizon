# these parameters need to be accessed from several locations and
# should be considered to be constant
class horizon::params {

  $logdir = '/var/log/horizon'

  case $::osfamily {
    'RedHat': {
      $package_name                = 'openstack-dashboard'
      $config_file                 = '/etc/openstack-dashboard/local_settings'
      $django_wsgi                 = '/usr/share/openstack-dashboard/openstack_dashboard/wsgi/django.wsgi'
      # Apache Specific Settings
      $apache_service              = 'httpd'
      $apache_config_file          = '/etc/httpd/conf.d/openstack-dashboard.conf'
      $apache_listen_config_file   = '/etc/httpd/conf/httpd.conf'
      $apache_root_url             = '/dashboard'
      $apache_user                 = 'apache'
      $apache_group                = 'apache'
    }
    'Debian': {
      $config_file                 = '/etc/openstack-dashboard/local_settings.py'
      $django_wsgi                 = '/usr/share/openstack-dashboard/openstack_dashboard/wsgi/django.wsgi'
      case $::operatingsystem {
        'Debian': {
            $package_name          = 'openstack-dashboard-apache'
        }
        default: {
            $package_name          = 'openstack-dashboard'
        }
      }
      # Apache Specific Settings
      $apache_service               = 'apache2'
      $apache_config_file           = '/etc/apache2/conf.d/openstack-dashboard.conf'
      $apache_listen_config_file    = '/etc/apache2/ports.conf'
      $apache_root_url              = '/horizon'
      $apache_user                  = 'www-data'
      $apache_group                 = 'www-data'
    }
    default: {
      fail("Unsupported osfamily: ${::osfamily} operatingsystem: ${::operatingsystem}, module ${module_name} only support osfamily RedHat and Debian")
    }
  }
}
