// Copyright (c) 2017, paulsen. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:html';
import 'package:intl/intl.dart';
import 'package:webgen/webgen.dart';
import 'dart:convert';
var generator = null;
var validator = null;
var nrtable = null;
var nrlist;
var baustein = null;
var htmlm = null;
// String host = '';
String host="http://localhost:8080";
// String host="http://localhost";
String ext='';
String dbsynonym ='test';
String tabellenname = 'bausteine';
Storage localStorage;
bool accepted = false;
String aktoption = '';

bool debug = true;
 Map<String, String> data = null;


 void main() {
 localStorage = window.localStorage;

  print("------> main");
  var htmlx = document.querySelector('#main');
   htmlm = document.querySelector('#tablediv');
  if (validator == null) {
    validator = new NodeValidatorBuilder()
      // ..allowCustomElement('A',attributes: ['href','data-target', 'data-toggle'])
      ..allowHtml5()
      ..allowSvg()
   ..allowNavigation(new MyUriPolicy())
       ..allowElement('object', attributes: ['data', 'style'])
      ..allowElement('img', attributes: ['src'])
      ..allowElement('button', attributes: ['data-tooltip'])
      // ..allowElement('a', attributes: ['href', 'data-target', 'data-toggle'])
      ..allowElement('input', attributes: [
        'pattern',
        'opt',
        'data-tooltip',
        'readonly',
        'disabled'
      ]);

  }
  generator = new UIGenerator();
  document.body.onClick.listen((e) {
    var clickedElem = e.target;
    var attr = clickedElem.attributes;
    attr.forEach((k, v) => print("clickelemattr ${k} ${v}"));
    String sid = clickedElem.id.toString();
    print('You clicked the ${clickedElem.id}- Element');
    if (clickedElem.id != null && sid.length > 0)
      populateAllClicks(e, clickedElem.id);
    else
      populateSvgClicks(e, clickedElem.text);
  });
}

void populateSvgClicks(Event e, String text) {
  print("SVG-TEXT:" + text);
}

void populateAllClicks(Event e, id) {
  String sid = id.toString();
  var expandid;
  if (sid == "btn_login") {
    checkAnmeldung();

  } else
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




    e.preventDefault();
    // tab_refresh();
  }
  else if (sid == "form1_insert") {
    var sts = sid.split('_');
    var nrid = sts[1];
    expandid = nrid;
    form1_insert();
    e.preventDefault();
  }
  else   if (sid == "form1_update") {
    var sts = sid.split('_');
    var nrid = sts[1];
    expandid = nrid;
    form1_update();
    e.preventDefault();
  }
   else   if (sid == "form1_clear") {
    var sts = sid.split('_');
    var nrid = sts[1];
    expandid = nrid;
    loescheMaske();
  }
  else if (sid.startsWith("form1_")){
    print("Wo wir wollen: ${sid}");
    var sts = sid.split('_');
    var nrid = sts[1];
    expandid = nrid;
    print("form1_btn ${nrid}");
    getBaustein(nrid);
    e.preventDefault();

  }
}
 form1_insert(){
                  print("INSERT");
                  String elements = 'inp=form1_bsname,inp=form1_bstyp,ta=form1_description,ta=form1_params,inp=form1_bereich,ta=form1_package';
                            var vmap;
                            vmap = generator.getMaskenWertebyFieldId(elements,'hex');
                            print(vmap);
                            vmap['tablename']=tabellenname;
                            vmap['synonym']=dbsynonym;
                            vmap['dbsynonym']=dbsynonym;
                            vmap = generator.addConstWerte('insertbs',localStorage,host,ext,vmap);
                            print(" Die VMAP: ${vmap}");
                            String uedata = encodeMap(vmap);
                            var req = new HttpRequest();
                            req.open('post','${host}/service', async: false);
                            //  req.setRequestHeader('Content-type', 'application/x-form-urlencoded');
                            req.send(uedata);
                            generator.setMessage('<h2>UEBERTRAGEN</h2>','#footer');
                            }
String encodeMap(Map data) {
                                return data.keys.map((k) {
                                     return '${Uri.encodeComponent(k)}=' +  '${Uri.encodeComponent(data[k])}';
                                 }).join('&');
}
form1_update(){
                  print("UPDATE");
                  String elements = 'inp=form1_bsname,inp=form1_bstyp,ta=form1_description,ta=form1_params,inp=form1_bereich,ta=form1_package';
                            var vmap;
                            vmap = generator.getMaskenWertebyFieldId(elements,'hex');
                            print(vmap);
                            vmap['tablename']=tabellenname;
                            vmap['synonym']=dbsynonym;
                            vmap['dbsynonym']=dbsynonym;
                            vmap = generator.addConstWerte('updatebs',localStorage,host,ext,vmap);
                            print(" Die VMAP: ${vmap}");
                            String uedata = encodeMap(vmap);
                            var req = new HttpRequest();
                            req.open('post','${host}/service', async: false);
                            //  req.setRequestHeader('Content-type', 'application/x-form-urlencoded');
                            req.send(uedata);
                            generator.setMessage('<h2>UEBERTRAGEN</h2>','#footer');
}
void checkAnmeldung() {
 // InputElement input = querySelector('#fbenutzer');
 //  if (input == null || input.value==null) return;

  var vmap = new Map<String, String>();
  generator.getValueFromInputField(vmap,'benutzer','login_username');
  generator.getValueFromInputField(vmap,'passwort','login_password');
    String password = vmap['passwort'].trim();
  String benutzer = vmap['benutzer'].trim();
  if (debug)  print("Das Passwort :"+password);
  var hal =  generator.getHashCode(password);
  print("HashCode:"+hal);
  localStorage['passwort'] = hal;
  localStorage['benutzer'] = benutzer;
   var httpsb = new StringBuffer();
   httpsb.write('${host}${ext}/service/getsid/dbsynonym/verein/typ/default/sidbenutzer/${localStorage['benutzer']}');
   print(httpsb.toString());
   HttpRequest.getString(httpsb.toString()).then((String results ){
   print("result1:"+results);
   try{
    var anmeldung = JSON.decode(results);
    localStorage['sid'] = anmeldung['sid'];
    anmeldungVerarbeiten(anmeldung);
    } catch(e) {
      print(e);
    }
   });
}
void anmeldungVerarbeiten(anmeldung) {
  // print("AV:");
if (localStorage['sid'] != null) {
    accepted = true;


    generator.setMessage(
        '<h3 class="good">Die Anmeldung war erfolgreich! Jetzt editieren</h3>','#footer');
  } else {
    generator.setMessage(
        '<h3 class="bad">Sie konnten sich nicht anmelden Überprüfen Sie Ihre Daten</h3>','#footer');
  }
   if (accepted){
    data =  new Map<String,String>();

    var now = new DateTime.now();
    var formatter = new DateFormat('yyyy-MM-dd');
    String formatted = formatter.format(now);



  }
}

 getBaustein(bsname) {
       generator.setMessage(
        '<h3 class="good">Baustein holen</h3>','#footer');
      String srequest = generator.getConstServiceStr(
          "getbaustein", localStorage, host, ext);
      srequest += "/dbsynonym/" + dbsynonym + "/bsname/"+bsname;
      print(srequest);
      HttpRequest.getString(srequest).then((String results) {
               print ("getbaustein");
               print('Baustein RESULT:'+results);
              var  nrlist = JSON.decode(results);

               if (results == null || results.length<3){
                 nrlist = new List();
               } else
               try {
                 nrlist = JSON.decode(results);
                  nrlist.forEach((m){
                  var wert = m['description'];
                  var bytesback = hexToBytes(wert.toString());
                  String ergebnismd = UTF8.decode(bytesback);
                  m['description']=ergebnismd;
                  print(m);
                  baustein = m;
                  fuelleMaske();
            });
               } catch (e) {
                 print(e);
               }
          });
  }
fuelleMaske(){
TextInputElement inp = querySelector('#form1_bsname');
inp.value = baustein['bsname'];
inp = querySelector('#form1_bstyp');
inp.value = baustein['bstyp'];
TextAreaElement tainp = querySelector('#form1_description');
tainp.value = baustein['description'];
tainp = querySelector('#form1_params');
tainp.value = baustein['params'];
inp = querySelector('#form1_bereich');
inp.value = baustein['bereich'];
tainp = querySelector('#form1_package');
tainp.value = baustein['package'];

}
loescheMaske(){
TextInputElement inp = querySelector('#form1_bsname');
inp.value = '';
inp = querySelector('#form1_bstyp');
inp.value = '';
TextAreaElement tainp = querySelector('#form1_description');
tainp.value = '';
tainp = querySelector('#form1_params');
tainp.value = "x1=man;x2=opt;";
inp = querySelector('#form1_bereich');
inp.value = '';
tainp = querySelector('#form1_package');
tainp.value = '';

}
List<int> hexToBytes(String hex){
  hex = hex.toLowerCase();
  final reqex = new RegExp('[0-9a-f]{2}');
  return reqex.allMatches(hex.toLowerCase()).map((Match match)
      => int.parse(match.group(0), radix: 16)).toList();
}
class MyUriPolicy implements UriPolicy {
  bool allowsUri(uri) => true;
}

