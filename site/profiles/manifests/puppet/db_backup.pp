# Install a cron job to backup PE postgres server

class profiles::puppet::db_backup(
    $db_backup_ensure   = $profiles::puppet::master::db_backup_ensure,
    $db_backup_dir      = $profiles::puppet::master::db_backup_dir,
    $db_backup_hour     = $profiles::puppet::master::db_backup_hour,
    $db_backup_minute   = $profiles::puppet::master::db_backup_minute,
    $db_backup_month    = $profiles::puppet::master::db_backup_month,
    $db_backup_monthday = $profiles::puppet::master::db_backup_monthday,
    $db_backup_weekday  = $profiles::puppet::master::db_backup_weekday,
) {

  cron { "pe_database_backups":
    ensure      => $db_backup_ensure,
    command     => "pg_dumpall -c -f ${db_backup_dir}/pe_postgres_$(date --iso-8601).bin",
    user        => "pe-postgres",
    hour        => $db_backup_hour,
    minute      => $db_backup_minute,
    month       => $db_backup_month,
    monthday    => $db_backup_monthday,
    weekday     => $db_backup_weekday,
    environment => "PATH=/opt/puppetlabs/server/bin:/opt/puppetlabs/bin:/opt/puppet/bin/:/usr/local/bin:/usr/bin:/bin",
  }
}
