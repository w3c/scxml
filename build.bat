
cd attributes
call gen.bat
cd ..

java -cp xinclude\xincluder.jar;xinclude\lib\xml-apis.jar;xinclude\lib\xercesImpl.jar  com.elharo.xml.xinclude.DOMXIncluder SCXMLNotation-Master.xml > SCXMLNotation.xml

cd xmlspec
java  -cp ..\xinclude\xalan.jar;..\xinclude\serializer.jar org.apache.xalan.xslt.Process -IN ..\SCXMLNotation.xml -XSL diffspec_my.xsl -param show.diff.markup 0 > ..\SCXMLNotation.html
cd ..

copy SCXMLNotation.html tmp
perl.exe cleanup.pl < tmp > SCXMLNotation.html

pause
