# BausteinEditor  

This a small example original build with my BootstrapDSL and DART. It uses a Rest-based Framework GLLVRunner, which I developed for me and the LKV NRW. The editor is used for documentation of glkvrunner-moduls.

The DSL which produced the templates for the DART-app and the HTML-File is here
```
include "false"
def button="button"
start "id:main"
dartoutput "true"
htmlfile "bootstraptemplate1.html"
tagnamefile "/team/home/test/dsl4bootstrap/tagnames.txt"
classfile "/team/home/test/dsl4bootstrap/classes.txt"
linkfile "link.txt"
title "BausteinDokuEditor"
description """GLKVRUNNERDS Bausteine editieren
"""
keywords "glkvrunner,baustein,bootstrapdsl"
body "class:yyy"

begin ("row", "class:xyz")
begin ("col12", "class:xxx")
tag ("h3","id:Editor;content:Bausteineditor")
end "col"
end "row"
begin ("row", "class:xyz")
begin ("col2", "class:xxx")
table "id:bausteine;class:extended"
trth "Bausteinname;Typ;Bereich"
tablecontent "test;form1_bsname;bsname;select bsname,bstyp,bereich from bausteine"
end "table"
tag ("button","content:REFRESH;id:test_refresh")
end "col"
begin ("col10","class:xyz")
begin ("form","id:form1;class:form");
formgroup ()
label ("for:form1_bsname;content:Bausteinname")
in_text("id:form1_bsname;placeholder:Baustein");
label ("for:form1_typ;content:Typ")
tag ("input","id:form1_bstyp;list:typen;name:typen");
begin ("datalist","id:typen");
tag ("option","value:DOBS");
tag ("option","value:BUBS");
tag ("option","value:ETBS");
tag ("option","value:STATBS");
end "datalist"
label ("for:form1_description;content:Description")
textarea("id:form1_description;rows:10");
label ("for:form1_params;content:Parameter")
textarea("id:form1_params;rows:4");
label ("for:form1_bereich;content:Bereich")
in_text("id:form1_bereich;placeholder:Bereich");
label ("for:form1_package;content:Package")
textarea("id:form1_package;rows:2");
tag ("button","content:INSERT;id:form1_insert")
tag ("button","id:form1_update;content:UPDATE")
end "formgroup"
end "form"
end "col8"
end "row"
footer1 "Von hier aus in die Welt<>home,twitter,despora,googleradtouren,mitmachcafe;class:test"
end "body"
```
**
The DSL File for updating the tablecontent is
**
```
include "true"
def button="button"
start "id:tablediv"
dartoutput "false"
htmlfile "bootstraptemplate1.html"
tagnamefile "/team/home/test/dsl4bootstrap/tagnames.txt"
classfile "/team/home/test/dsl4bootstrap/classes.txt"
linkfile "link.txt"
table "id:bausteine;class:extended"
trth "Bausteinname;Typ;Bereich"
tablecontent "test;form1_bsname;bsname;select bsname,bstyp,bereich from bausteine"
end "table"
```
This DSL is used to refresh the Tablecontent on the server with a GLKVRUNNERSCRIPT:

Here a dart snippet for simple communication between the server and client:

```

if (sid == "test_refresh") {
    var sts = sid.split('_');
    var nrid = sts[1];
    expandid = nrid;

   var httpsb = new StringBuffer();
   httpsb.write('${host}${ext}/service/bootstrapdsl/blogname/bausteine/dslfile/!tblbausteine');
   print(httpsb.toString());
   HttpRequest.getString(httpsb.toString()).then((String results ){
   print("result1:"+results);


   htmlm.setInnerHtml(results, validator: validator);

   });
```


This app is LGPL2 
