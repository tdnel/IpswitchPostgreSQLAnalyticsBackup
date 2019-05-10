
# Common Variables
$myBaseDestinationLocation = "<Backup Location - UNC Path Okay (and probably best so backup is off server>";
# The Date format below is appended to the Backup Name.  This way there is one file per month that gets overwritten daily.  Adjust the format as desired if keeping daily backups is desired.
$myDate = Get-Date -Format "yyyyMM";

# Variables for Web File Backups.  Affects file naming, location of source, etc.
# This is what the base name of the web file zip backup will be.
$myApplicationName = "IpswitchAnalyticsApacheWeb";
# The default is "c:\Program Files\Ipswitch\Analytics Server\".  If Ipswitch Analytics was installed to a different path this has to be updated.
$myApplicationSourceDirectory = "c:\Program Files\Ipswitch\Analytics Server\apache-tomcat\";
# The Array below contains the files that Ipswitch recommends backing up.  If additional files in the \apache-tomcat\ folder are desired - add them to the array.
$myApplicationFiles = @('webapps\ura\WEB-INF\classes\spring\properties\*.properties','conf\server.xml','conf\.init','certs\*');
# The next two should not need to be modified.
$myApplicationArchiveName = $myApplicationName + "_" + $myDate + ".zip";
$myApplicationBackupLocation = $myBaseDestinationLocation + $myApplicationArchiveName;

# Variables for Postgres DB Backups. Affects file naming, database connection, etc.
# This is what the base name of the PostgreSQL Database backup will be.
$myDatabaseName = "IpswitchAnalyticsPostgres_URA";
# A valid PostgreSQL user name and password are needed in order to connect to the database. Exact permissions needed can be investigated at https://www.postgresql.org/.
$myDBUserName = "<DatabaseUserName>";
# I am sure there is a better / more secure way thean having the password in the script.  When I figure that out I may come back and update the script...
$myDBPassword = "<DatabaseUserPassword>";
# The default is "c:\Program Files\Ipswitch\Analytics Server\".  If Ipswitch Analytics was installed to a different path this has to be updated.
$myPGDumpDir = "c:\Program Files\Ipswitch\Analytics Server\pgsql\bin";
# The next three should not need to be modified.
$myDBBackupName = $myDatabaseName + "_" + $myDate + ".bak";
$myDBBackupLocation = $myBaseDestinationLocation + $myDBBackupName;
$myDBName = "URA";

Write-Host "Zipping Current Apache Config Files to $myApplicationBackupLocation";
foreach ($file in $myApplicationFiles) { 
    $myNewFile = $myApplicationSourceDirectory + $file;
    Compress-Archive -Path $myNewFile -DestinationPath $myApplicationBackupLocation -Update;
    }
Write-Host "Done Zipping Current Apache Config Files to $myApplicationBackupLocation";

Write-Host "Backing Up PostgreSQL Database to $myDBBackupLocation";
$Env:PGPASSWORD=$myDBPassword;
cd $myPGDumpDir;
.\pg_dump.exe -Fc -d $myDBName -U $myDBUserName -f $myDBBackupLocation;
Remove-Item Env:\PGPASSWORD;
Write-Host "Done Backing Up PostgreSQL Database to $myDBBackupLocation";