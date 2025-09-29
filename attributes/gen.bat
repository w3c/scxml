
FOR %%i IN (*.xml) DO @java  -cp ..\xinclude\xalan.jar org.apache.xalan.xslt.Process -IN %%i -XSL specxml.xslt > %%i.html

