function go_class_m(lcFrame,lcID)
   {
   // lcFrame - C�lov� frame
   // lcID - Anchor t��dy i s HTML souborem
   var loRef=document.getElementById(lcID);
   var loLoc=((parent.frames.length>0)?eval("parent."+lcFrame+".location"):parent.location);
   loLoc.href = loRef.value;
   }

function go_class(lcFrame,lcFile,lcID)
   {
   // lcFrame - C�lov� frame
   // lcFile  - C�lov� HTML soubor
   // lcID    - Anchor t��dy
   var loRef=document.getElementById(lcID);
   var loLoc=((parent.frames.length>0)?eval("parent."+lcFrame+".location"):parent.location);
   loLoc.href = lcFile+"#" + loRef.value;
   }


function go_proc(lcFrame,lcFile,lcID)
   {
   // lcFrame - C�lov� frame
   // lcFile  - C�lov� HTML soubor
   // lcID    - Anchor t��dy
   var loRef=document.getElementById(lcID);
   var loLoc=((parent.frames.length>0)?eval("parent."+lcFrame+".location"):parent.location);
   loLoc.href = loRef.value;
   }

function LostFocus()
   {
   window.focus();
   }

function ExpandSC(lcID,liType)
   {
   // lcID   - Posledn� ��st ID element� <TX> a <IMG>  pro zobrazen� v�razu
   // liType - P��znak, zda se to m� zobrazit �i skr�t
   //          -1 - automaticky
   //           1 - zobrazit
   //           0 - skr�t
   var loTX=document.getElementById("TX_"+lcID);
   var loIMG=document.getElementById("IMG_"+lcID);

   if (loTX.style.display=="none" && liType==-1 || liType==1)
      {
      loTX.style.display="";
      loIMG.src=loTX.Dir+"uptab.gif";
      }
   else
      {
      if (loTX.style.display=="" && liType==-1 || liType==0)
         {
         loTX.style.display="none";
         loIMG.src=loTX.Dir+"dotab.gif";
         }
      }
   }

function LoadForm(lcID)
   {
   // lcID - ID elementu <SELECT> pro v�b�r t��dy/objektu

   var lcBrowser=GetBrowser();
   var loRef=document.getElementById(lcID);
   var lc= lcBrowser=="OPERA"?"...................................................................................................":"                                                                                                   ";
   var lii=0;
   var liy=lcBrowser=="OPERA"?loRef.length:loRef.options.length;

   for (lii=0; lii< liy; lii++)
       {
       var lcc=loRef.options.item(lii).text;

       loRef.options.item(lii).text=lc.substring(0,lcc.substring(0,2))+lcc.substring(2);
       }

   // for Mozilla
   if (lcBrowser=="MOZILLA")
      {
      loRef.options.selectedIndex=1;
      loRef.options.selectedIndex=0;
      }

   }

function ExpandVal(lcID,liType)
   {
   // lcID   - Posledn� ��st ID element� <TX> a <IMG>  pro zobrazen� v�razu
   // liType - P��znak, zda se to m� zobrazit �i skr�t
   //          -1 - automaticky
   //           1 - zobrazit
   //           0 - skr�t
   var loTX=document.getElementById("TX_"+lcID);
   var loIMG=document.getElementById("IMG_"+lcID);

   if (loTX.style.display=="none" && liType==-1 || liType==1)
      {
      loTX.style.display="";
      loIMG.src=loTX.Dir+"uptab.gif";
      }
   else
      {
      if (loTX.style.display=="" && liType==-1 || liType==0)
         {
         loTX.style.display="none";
         loIMG.src=loTX.Dir+"dotab.gif";
         }
      }
   }

function HighLite(lcID,liVS)
   {
   // lcID - Posledn� ��st ID elementu <HR> highlite objektu
   // liVS - P��znak, zda se highlite objekt m� zobrazit �i skr�t
   //        1 - zobrazit
   //        0 - skr�t
   var loHL=document.getElementById("HL_"+lcID);
   if (liVS==1) // zobraz se
      {
      if (loHL.style.visibility!="visible")
         loHL.style.visibility="visible";
      }
   else
      {
      if (loHL.style.visibility!="hidden")
         loHL.style.visibility="hidden";
      }
   }

function HighLiteII()
   {
   var lcHash=document.location.hash;
   (lcHash!="")?HighLite(lcHash.substring(4),1):false;
   }

function ExpandTab(lcID,liType)
   {
   // lcID   - Posledn� ��st ID element� <TX> a <IMG>  pro zobrazen� dopl�uj�c�ch vlastnost�
   // liType - P��znak, zda se to m� zobrazit �i skr�t
   //          -1 - automaticky
   //           1 - zobrazit
   //           0 - skr�t

   var loTR=document.getElementById("TX_"+lcID);
   var loTAB=document.getElementById("TAB_"+lcID);
   var loIMG=document.getElementById("IMG_"+lcID);

   if (loTR.style.display=="none" && liType==-1 || liType==1)
      {
      loTR.style.display="";
      loIMG.src=loTAB.Dir+"uptab.gif";
      }
   else
      {
      if (loTR.style.display=="" && liType==-1 || liType==0)
         {
         loTR.style.display="none";
         loIMG.src=loTAB.Dir+"dotab.gif";
         }
      }
   }

function ExpandAllObjects(lcID,liObj)
   {
   // lcID  - ��ste�n� ID objektu (t�la tabulky)
   // liObj - Typ objekt� je� se t�k� akce
   //         -1 - v�echny objekty
   //          1 - v�echny tabulky
   //          2 - v�echny v�razy
   //          3 - v�echny zdrojov� k�dy

   var lii=0;
   var lc="";

   // Je definov�n konkr�tn� hlavn� objekt
   if (lcID!='')
      _ExpandAllObjects(lcID,liObj)
   else
      {
      // Pokud nen� definov�n hlavn� objekt, pak najdi v�echny hlavn� objekty
      // Z�skej v�echny tabulky v tomto elementu
      var locon=document.getElementsByTagName("DIV");
      for (lii=0;lii<locon.length;lii++)
          {
          if (locon.item(lii).XType=="Main")
             {
             lc=locon.item(lii).id;
             _ExpandAllObjects(lc.substring(6));
             }
          }
      }
   }

function _ExpandAllObjects(lcID,liObj)
   {
   var loTAB=document.getElementById("TBODY_"+lcID);
   var loIMG=document.getElementById("IMGX_"+lcID);
   var lc="";
   var lii=liy=0;
   var liType=loTAB.Expanded==true?0:1;
   loIMG.src =loTAB.Dir+(loTAB.Expanded==true?"dotab.gif":"uptab.gif");
   loTAB.Expanded=loTAB.Expanded==true?false:true;

   // Z�skej v�echny tabulky v tomto elementu
   var locon=loTAB.getElementsByTagName("table");
   for (lii=0;lii<locon.length;lii++)
       {
       lc=locon.item(lii).id;

       // tabulka vlastnost�
       if (locon.item(lii).XType=="Property" && (liObj==-1 || liObj==1))
          ExpandTab(lc.substring(4),liType);

       // tabulka s v�razem
       if (locon.item(lii).XType=="Expression" && (liObj==-1 || liObj==2))
          ExpandVal(lc.substring(3),liType);

       // tabulka se zdrojov�m k�dem
       if (locon.item(lii).XType=="SourceCode" && (liObj==-1 || liObj==3))
          {
          alert("Warning - Obsolete code - 'Source code'");
          ExpandSC(lc.substring(4),liType);
          }

       }
   }

function GetBrowser()
   {
   var lcUserA=navigator.userAgent;
   var lcBrowser="";

   if (lcUserA.search(" Opera ")>-1 || lcUserA.search("Opera")>-1)
      lcBrowser="OPERA";
   else
      if (lcUserA.search("Mozilla")>-1 && lcUserA.search("Gecko")>-1)
         lcBrowser="MOZILLA";
      else
         if (lcUserA.search("Mozilla")>-1 && lcUserA.search("MSIE")>-1)
            lcBrowser="MSIE";
         else
            lcBrowser="OTHER";

   return lcBrowser;
   }

function MouseMove(loev)
   {
   // Parameter loev is for MOZILLA

   var liLeft=liTop =0;

   var lcBrowser=GetBrowser();

   if (lcBrowser!="MOZILLA")
      loev=event;

   var loHp=document.getElementById("Hp");
   var loVp=document.getElementById("Vp");
   var loBody=document.body;

   if (lcBrowser=="OPERA")
      {
      liLeft=loev.clientX-30;
      liTop =loev.clientY-30;
      }
   else
      if (lcBrowser=="MOZILLA")
         {
         liLeft=loev.clientX-30+loBody.scrollLeft;
         liTop=loev.clientY-30+loBody.scrollTop;
         }
      else
         {
//         liLeft=loev.clientX-30+loBody.scrollLeft-loBody.clientLeft;
//         liTop=loev.clientY-30+loBody.scrollTop-loBody.clientTop;
         liLeft=loev.srcElement.style.pixelLeft+loev.offsetX-30;
         liTop=loev.srcElement.style.pixelTop+loev.offsetY-30;
         }
   
   liLeft=liLeft<0?0:(liLeft>window.MaxLeft?window.MaxLeft:liLeft);
   liTop=liTop<0?0:(liTop>window.MaxTop?window.MaxTop:liTop);

   window.status="Top: "+liTop+"px Left: "+liLeft+"px";

   if (loVp)
      loVp.style.top=liTop+30-(lcBrowser!="MOZILLA"?0:8)+"px";

   if (loHp)
      loHp.style.left=liLeft+30+"px";
   }

function onExpandTab(lcID)
   {
   ExpandTab(lcID,-1);
   window.E_Tab='';
   }

function Go_Band(lcFrame,lcFile,lcID)
   {
   // lcFrame - C�lov� frame
   // lcFile  - C�lov� HTML soubor
   // lcID - Anchor bandu
   var loLoc=((parent.frames.length>0)?eval("parent."+lcFrame+".location"):parent.location);
   loLoc.href = lcFile+"#" + lcID;
   }

function Go_Object(lcFrame,lcFile,lcID)
   {
   // lcFrame - C�lov� frame
   // lcFile  - C�lov� HTML soubor
   // lcID - Anchor objektu
   var loLoc=((parent.frames.length>0)?eval("parent."+lcFrame+".location"):parent.location);
   loLoc.href = lcFile+"#" + lcID;
   }

function QuickViewIMG(liVisible,lcURL)
   {
   // liVisible - P��znak, zda se m� obr�zek zobrazit
   // lcURL       - URL obr�zku v repozit��i

   lo=GetRoot(window);
   if (!lo.F1)
      return;
      
   lo=lo.F1.document.getElementById("IMG_QUICKVIEW");
   if (liVisible==1)
      {
      lo.src=lcURL;
      if (lo.width>100)
         {
         lo.style.width="100px";
         lo.style.left="4px";
         }
      else
         {
         lo.style.left=(100-lo.width)/2+"px";
         }
      lo.style.visibility="visible";
      }
   else
      {
      lo.style.visibility="hidden";
      }
   }

function GetRoot(loWin)
   {
   // loWin - Odkaz na objekt okna

   loCObj=loWin.parent;
   while (!loCObj.name=="")
         loCObj=loCObj.parent;

   return loCObj;
   }

function ExpandTreeRow(lcID,liType)
   {
   // lcID   - Posledn� ��st ID element� <TX> a <IMG>  pro zobrazen� dopl�uj�c�ch vlastnost�
   // liType - P��znak, zda se to m� zobrazit �i skr�t
   //          -1 - automaticky
   //           1 - zobrazit
   //           0 - skr�t

   var loDIV=document.getElementById("TX_"+lcID);
   var loIMG=document.getElementById("IMG_"+lcID);

   if (loDIV.style.display=="none" && liType==-1 || liType==1)
      {
      loDIV.style.display="";
      loIMG.src=loDIV.Dir+"uptab.gif";
      }
   else
      {
      if (loDIV.style.display=="" && liType==-1 || liType==0)
         {
         loDIV.style.display="none";
         loIMG.src=loDIV.Dir+"dotab.gif";
         }
      }
   }

function onExpandTreeRow(lcID)
   {
   ExpandTreeRow(lcID,-1);
   window.E_Tab='';
   }

function ExpandAllDIV(lcID,liObj)
   {
   // lcID  - ��ste�n� ID objektu (t�la tabulky)
   // liObj - Typ objekt� je� se t�k� akce
   //         -1 - v�echny objekty
   //          1 - v�echny tabulky
   //          2 - v�echny v�razy
   //          3 - v�echny zdrojov� k�dy

   var lii=0;
   var lc="";

   // Je definov�n konkr�tn� hlavn� objekt
   if (lcID!='')
      _ExpandAllDIV(lcID,liObj)

   else
      {
      // Pokud nen� definov�n hlavn� objekt, pak najdi v�echny hlavn� objekty
      // Z�skej v�echny divy v tomto elementu
      var locon=document.getElementsByTagName("DIV");
      for (lii=0;lii<locon.length;lii++)
          {
          if (locon.item(lii).XType=="Main")
             {
             lc=locon.item(lii).id;
             _ExpandAllDIV(lc.substring(5));
             }
          }
      }
   }

function _ExpandAllDIV(lcID,liObj)
   {
   var loDIV=document.getElementById("DIVX_"+lcID);
   var loIMG=document.getElementById("IMGX_"+lcID);
   var lc="";
   var lii=liy=liz=0;
   var liType=loDIV.Expanded==true?0:1;
   loIMG.src =loDIV.Dir+(loDIV.Expanded==true?"dotab.gif":"uptab.gif");
   loDIV.Expanded=loDIV.Expanded==true?false:true;

   for (liz=0;liz<2;liz++)
       {
       // Z�skej v�echny divy v tomto elementu
       var locon=loDIV.getElementsByTagName(liz==0?"DIV":"TABLE");
   
       for (lii=0;lii<locon.length;lii++)
           {
           lc=locon.item(lii).id;

           // strom
           if (locon.item(lii).XType=="Tree" && (liObj==-1 || liObj==4))
              ExpandTreeRow(lc.substring(3),liType);

           // tabulka vlastnost�
           if (locon.item(lii).XType=="Property" && (liObj==-1 || liObj==1))
              ExpandTab(lc.substring(4),liType);


           //  DIV s v�razem
           if (locon.item(lii).XType=="Expression" && (liObj==-1 || liObj==2))
              ExpandVal(lc.substring(3),liType);

           // DIV se zdrojov�m k�dem
           if (locon.item(lii).XType=="SourceCode" && (liObj==-1 || liObj==3))
              ExpandSC(lc.substring(3),liType);

           }
       }
   }

function HighLiteOver(loev)
   {
   // loev for Mozilla
   var loObj=null;

   loev=((loev)?loev:event);
   if (loev.target)
      loObj=((loev.target.nodeName && loev.target.nodeName=="#text")?loev.target.parentNode:loev.target);
   else
      if (loev.srcElement)
         loObj=loev.srcElement;
      else
         return;

   // Pozor - je nad body
   if (loObj.tagName=="HTML")
      return;

   (loObj.id.substr(0,3)=="ID_")?HighLite(loObj.id.substring(3),1):false;

   }

function HighLiteOut(loev)
   {
   // loev for Mozilla
   var loObj=null;

   loev=((loev)?loev:event);
   if (loev.target)
      loObj=((loev.target.nodeName && loev.target.nodeName=="#text")?loev.target.parentNode:loev.target);
   else
      if (loev.srcElement)
         loObj=loev.srcElement;
      else
         return;

   // Pozor - je nad body
   if (loObj.tagName=="HTML")
      return;

   (loObj.id.substr(0,3)=="ID_")?HighLite(loObj.id.substring(3),0):false;

   }

function LNK_BodyClick()
   {
   if (pcLNK!="")
      {
      LNK_ShowTab(pcLNK);
      pcLNK="";
      return;
      }

   if (pcLastLNK!="")
      {
      var loRef=document.getElementById(pcLastLNK);
      loRef.style.visibility="hidden"
      pcLastLNK="";
      }
   }

function LNK_ShowTab(lcID)
   {
   // lcID   - ID tabulky odkaz�

   var loRef=null;
   var loSpan=document.getElementById("SPN_"+lcID);

   pcLastLNK="LNK_"+lcID;
   loRef=document.getElementById(pcLastLNK);
   loRef.style.visibility='visible';
   if (!loRef.Inited)
      {
      loRef.style.left=GetAbsoluteLeft(loSpan)+'px';
      loRef.Inited=true;
      }
   }

/***********************************************************/
/* Vr�t� absolutn� pozici Left objektu                     */
/***********************************************************/
function GetAbsoluteLeft(loRef)
   {
   // loRef - Odkaz na objekt
   var liLeft=0;
   while (loRef.offsetParent)
         {
         liLeft=liLeft+loRef.offsetLeft;
         loRef=loRef.offsetParent;
         }
   return liLeft;
   }

