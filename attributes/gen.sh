#!/bin/sh

for i in *.xml
do
	echo "Running $i"
	java -cp ../xinclude/xalan.jar org.apache.xalan.xslt.Process -IN $i -XSL specxml.xslt > $i.html
done
