#!/bin/sh

chmod +r xinclude/*.jar xinclude/lib/*.jar

if test ! -f schema
then
  ln -s Schema schema
fi

echo
echo "Generating attribute tables..."
cd attributes
./gen.sh
cd ..


echo
echo "Generating SCXMLNotation.xml..."
java -cp xinclude/xincluder.jar:xinclude/lib/xml-apis.jar:xinclude/lib/xercesImpl.jar  com.elharo.xml.xinclude.DOMXIncluder SCXMLNotation-Master.xml > SCXMLNotation.xml

#exit

echo
echo "Generating SCXMLNotation.html..."
cd xmlspec
java  -cp ../xinclude/xalan.jar:../xinclude/serializer.jar org.apache.xalan.xslt.Process -IN ../SCXMLNotation.xml -XSL diffspec_my.xsl -param show.diff.markup 0 > ../SCXMLNotation.html
cd ..

#exit

echo
echo "Cleaning up temporary files of attribute tables..."
rm -rf attributes/*.xml.html

#exit

echo "Tidy..."
tidy -utf8 -mc -asxml SCXMLNotation.html || echo "Tidy fixed HTML"

echo
echo "Removing extra \"xml:base\" attributes..."
cp SCXMLNotation.html tmp
./cleanup.pl < tmp > SCXMLNotation.html

#exit

#echo
#echo "Adding id's to headings which don't have id's..."
#cp SCXMLNotation.html tmp
#./add_anchor.pl < tmp > SCXMLNotation.html

#exit

echo
echo "Tidy again..."
tidy -utf8 -mc -asxml SCXMLNotation.html || echo "Tidy fixed HTML"


