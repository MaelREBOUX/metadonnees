# -*- coding: utf-8 -*-
#-------------------------------------------------------------------------------
# Name:        module1
# Purpose:
#
# Author:      m.reboux
#
# Created:     01/2016
# Copyright:   (c) m.reboux 2015
# Licence:     <your licence>
#
#
# Documentation :
#	https://wiki.postgresql.org/wiki/Using_psycopg2_with_PostgreSQL
#	http://initd.org/psycopg/docs/usage.html#query-parameters
#	http://lxml.de/tutorial.html
#	http://apprendre-python.com/page-xml-python-xpath
# http://blog.paumard.org/cours/xml/chap02-premier-exemple-structure.html + http://www.w3schools.com/xml/xml_tree.asp
#
#-------------------------------------------------------------------------------

import psycopg2
import pprint
import encodings
from lxml import etree
import codecs
import traceback
import string
import ConfigParser


# chaînes de connexion aux bases de données
#sConnPostgre = "host='10.7.5.130' dbname='catalogue' user='gnadmin' password='gnadmin'"

# on lit le fichier de configuration
Config = ConfigParser.ConfigParser()
Config.read("config.ini")
# tests
#print Config
#print Config.sections()
#print Config.get('test', 'FavoriteColor')


sConnPostgre = Config.get('database', 'PgDatabaseConnString')


# le fichier en sortie
f_list_keyword = "liste_keywords.txt"



cfg = {
  'ns': {
    'gmd':  u'http://www.isotc211.org/2005/gmd',
    'gco': u'http://www.isotc211.org/2005/gco',
    'gsr': u'http://www.isotc211.org/2005/gsr',
    'gss': u'http://www.isotc211.org/2005/gss'
  }
}

RegUuidStrict = "uuid=[0-9A-F]{8}-[0-9A-F]{4}-4[0-9A-F]{3}-[89AB][0-9A-F]{3}-[0-9A-F]{12}"
RegUuid = "uuid=([0-9A-Z-]*)"



def xmlGetTextNodes(doc, xpath):
    """
    shorthand to retrieve serialized text nodes matching a specific xpath
    """
    return '|'.join(doc.xpath(xpath, namespaces=cfg['ns']))




def testConnPostgre():

  # print the connection string we will use to connect
  print "Connecting to database\n	->%s" % (sConnPostgre)

  # get a connection, if a connect cannot be made an exception will be raised here
  pgDB = psycopg2.connect(sConnPostgre)

  # pgDB.cursor will return a cursor object, you can use this cursor to perform queries
  cursor = pgDB.cursor()
  print "Connected!\n"

  # test
  cursor.execute("SHOW client_encoding;")
  print "SHOW client_encoding =  ", cursor.fetchone()

  passe



def SaveToFile(theString,option):

  # sert à enregister le xml dans un fichier
  #f = u"md_temp" + time.strftime("%H%M") + ".xml"

  if (option == "erase"):
    out = codecs.open(f_list_keyword, "w", "utf-8")

  if (option == 'add'):
    out = codecs.open(f_list_keyword, "a", "utf-8")
    out.write( theString + "\n")

  out.close()

  pass


def ListAllKeywords():

  # sert à dresser une liste de tous les mots-clés utilisés dans les métadonnées
  # upgrade possible : lister / filtrer par thesaurus

  # on se connecte à la base pour récupérer les MD qui sont des MD ISO19139 (dataset, series, services)
  pgDB = psycopg2.connect(sConnPostgre)
  pgCursor = pgDB.cursor()

  # on indique à Postgre qu'il y a un truc avec l'encodage des caractères
  # sinon on a l'erreur   psycopg2.DataError: invalid byte sequence for encoding "UTF8"  //  psycopg2.DataError: ERREUR:  séquence d'octets invalide pour l'encodage « UTF8 »
  pgCursor.execute("set client_encoding to 'UTF8'")

  # sélection des metadonnées
  pgCursor.execute("select uuid, schemaid, istemplate, data from metadata where schemaid = 'iso19139' and istemplate ='n'")
  #pgCursor.execute("select uuid, schemaid, istemplate, data from metadata where uuid='03268497-3416-4326-9119-48744df1a3c2'")
  records = pgCursor.fetchall()

  nbMD = 0
  cptKeywords = 0
  keywordsArray = []

  # on boucle sur les enregistrements
  for record in records:
    nbMD += 1
    uuid = record[0]
    mdXML = record[3]

    # préparation du XML pour le manipuler en xml
    root = etree.XML(mdXML)

    # extraction du titre pour faire joli
    title = xmlGetTextNodes(root, u'/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:title/gco:CharacterString/text()')
    print( "    " + uuid + " | " + title )

    # on va récupérer le tuple qui concerne les mots-clés
    # et boucler sur les n occurences

    cptThesaurus = 0


    for MDkeywords in root.iterfind('.//gmd:MD_Keywords', namespaces=cfg['ns']):
      try:
        # produit une sortie du XML
        #print(etree.tostring(MDkeywords, pretty_print=True))

        # on cherche le nom du thesaurus pour filtrer dessus
        # bon je comprend pas pourquoi on ne pas chercher directement dans MDkeywords alors on reparse le bloc MD_Keywords
        # child.tag ? child.element ?
        Kdoc = etree.XML(etree.tostring(MDkeywords))

        thesaurusName = xmlGetTextNodes(Kdoc, u'/gmd:MD_Keywords/gmd:thesaurusName/gmd:CI_Citation/gmd:title/gco:CharacterString/text()')
        #/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:descriptiveKeywords/gmd:MD_Keywords/gmd:thesaurusName/gmd:CI_Citation/gmd:title/gco:CharacterString
        #print "    thesaurus [" + str(cptKeywords) + "] : " + thesaurusName

        # on ne va lister que les mots-clés du thesaurus qui nous intéresse
        if (thesaurusName == 'RM Services v 1.1'):
          #print "    thesaurus [" + str(cptThesaurus) + "] : " + thesaurusName

          keyword = xmlGetTextNodes(Kdoc, u'/gmd:MD_Keywords/gmd:keyword/gco:CharacterString/text()')
          #print "      " + keyword

          # si on a plusieurs mot-clé, ils reviennent séparer par un pipe |
          # on traite
          list = keyword.split("|")

          for k in list:
            #print k
            #SaveToFile(k,"add")
            # on ajoute à la liste
            keywordsArray.append(k)
            cptKeywords = cptKeywords + 1

        cptThesaurus = cptThesaurus + 1

      except:
        print "erreur"
        traceback.print_exc()
        pass


  # fin de la boucle sur les MD
  print ""

  # on ferme les connexions à la base
  pgCursor.close()
  pgDB.close()

  print( "" + str(nbMD) + " MD traitées")
  print ("" + str(cptKeywords) + " mots-clés trouvés")

  # maintenant on dédoublonne
  uniqueKeywordsArray = set(keywordsArray)
  print ("" + str(uniqueKeywordsArray.__len__() -1) + " mots-clés uniques trouvés")

  # on trie
  a = sorted(uniqueKeywordsArray)

  # et on enregistre dans le fichier
  for k in a:
    if (k != ""): SaveToFile(k,"add")

  pass



def test():
  list=[1,4,2,3,4,5,6,3,2,6]
  list_unique = set(list)
  print list_unique


def main():

  print "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"


  # on teste connexion à la base
  testConnPostgre()

  # on efface le fichier créé en sortie
  #SaveToFile(f_list_keyword,"erase")

  #ListAllKeywords()



if __name__ == '__main__':
  main()

