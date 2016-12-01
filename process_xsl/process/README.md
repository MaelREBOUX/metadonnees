
Placer les XSL dans ce répertoire :
/var/lib/tomcat8/webapps/geonetwork/WEB-INF/data/config/schema_plugins/iso19139/process

sudo cp /data/catalogue/xsl/*.xsl /var/lib/tomcat8/webapps/geonetwork/WEB-INF/data/config/schema_plugins/iso19139/process/

mettre les droits à tomcat
```chown tomcat7:tomcat7 rm*```

redémarrer le catalogue donc tomcat 
```sudo service tomcat7 restart```

surveiller le log
```
truncate -s 0 /var/lib/tomcat8/logs/geonetwork.log
tail -f /var/lib/tomcat8/logs/geonetwork.log
```

Dans l'interface de GN, sélectionner les MD à corriger.

Pour appliquer / appeler le process xsl : http://mongeonetwork/geonetwork/srv/eng/md.processing.batch?process=[le nom  du fichier - xsl]

Une réponse XML va être produite.
```xml
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<response process="rm_clean_iru_xml" startDate="2016-11-30T09:31:00" reportDate="2016-11-30T09:34:53" running="false" totalRecords="547" processedRecords="547" nullRecords="0">
  <done>474</done>
  <notProcessFound>73</notProcessFound>
  <notOwner>0</notOwner>
  <notFound>0</notFound>
  <metadataErrorReport/>
</response>
```
