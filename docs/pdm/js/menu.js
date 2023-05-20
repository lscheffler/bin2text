/*
menu.js: Základní funkce pro menu
Autor:   Martin Jindra, martin.jindra@egservis.cz
Datum:   2004-05-06
Verze:   0.51
*/

/***********************************************************/
/* Dynamicky vytváøené vlastnosti                          */
/*---------------------------------------------------------*/
/*                                                         */
/* objekt Menu:                                            */
/*   Init :  Pøíznak inicializace menu                     */
/*                                                         */
/* objekt popupu:                                          */
/*   Init :  Pøíznak inicializace popupu                   */
/*   iHL:    Index obrázku HighLite (for Opera)            */
/*   Repos:  Pøíznak posunu popupu na pøíslušné místo      */
/*                                                         */
/*                                                         */
/* objekt baru:                                            */
/*   over:   Pøíznak aktivace baru                         */
/*   iMark:  Index obrázku Mark                            */
/*   iPopup: Index obrázku Popup                           */
/*   iIcon:  Index obrázku ikony                           */
/*   iHL:    Index obrázku HighLite (for Opera)            */
/*   _color: Pùvodní barva písma baru                      */
/*                                                         */
/*                                                         */
/* objekt padu:                                            */
/*   over:   Pøíznak aktivace padu                         */
/*   iIcon:  Index obrázku ikony                           */
/*   _color: Pùvodní barva písma padu                      */
/*                                                         */
/***********************************************************/



/***********************************************************/
/* Základní konfiguraèní promìnné                          */
/* - musí existovat -                                      */
/***********************************************************/

/* Systémové promìnné - obsah nemìnit                      */
pipopupActive=0;   // Pøíznak aktivace popupu 1. úrovnì
pcpopupTree  ="";  // Strom aktivovaných popupù
pcLastBar    ="";  // Poslední aktivovaný bar
pcPreLastBar ="";  // Pøedposlední aktivovaný bar
pcLastPad    ="";  // Poslední aktivovaný pad

/* Promìnné ovlivòující vzhled                             */
piDock=0;  // 0 - top, 1 - right, 2 - bottom, 3 - left
piExpandPopup=0;  // 0 - vpravo, 1 - vlevo
piExpandFLPopup=0;  // 0 - po kliku na pad, 1 - vždy

/* Pad                                                     */
piPadBorder=1; // Zda má pad zobrazit rámeèek, je-li aktivní/aktivovaný [0,1]
pcbcPadActive="#808040 #FFFFFF #FFFFFF #808040"; // Aktivní pad    - rámeèek
pcbcPadHover ="#FFFFFF #808040 #808040 #FFFFFF"; // Aktivovaný pad - rámeèek

pcPadHoverbc  =null; //"#FFFFFF";                // Aktivovaný pad - barva pozadí
pcPadHoverc   =null; //"#FFFF00";                // Aktivovaný pad - barva písma
pcPadHoverff  =null; //"Courier New";            // Aktivovaný pad - písmo (font-family)
pcPadHoverfs  =null; //"12pt";                   // Aktivovaný pad - písmo-velikost (font-size)
pcPadHoverfw  =null; //"bold";                   // Aktivovaný pad - písmo-šíøka (font-weight)
pcPadHoverfst =null; //"italic";                 // Aktivovaný pad - písmo-styl  (font-style)
pcPadHovertd  =null; //"underline";              // Aktivovaný pad - text-styl  (font-decoration)
pcPadHoverbi  =null; //'url("pict.gif")';        // Aktivovaný pad - background-image


/* Bar                                                     */
pcBarHoverbc  =null; //"#0080FF";          // Aktivovaný bar - barva pozadí
pcBarHoverc   =null; //"#000000";          // Aktivovaný bar - barva písma
pcBarHoverff  =null; //"Courier New";      // Aktivovaný bar - písmo (font-family)
pcBarHoverfs  =null; //"12pt";             // Aktivovaný bar - písmo-velikost (font-size)
pcBarHoverfw  =null; //"bold";             // Aktivovaný bar - písmo-šíøka (font-weight)
pcBarHoverfst =null; //"italic";           // Aktivovaný bar - písmo-styl  (font-style)
pcBarHovertd  =null; //"line-through";     // Aktivovaný bar - text-styl  (text-decoration)
pcBarHoverbi  =null; //'url("pict.gif")';  // Aktivovaný bar - background-image


/* Lokální handlery událostí                               */
pconBarClick=null; // Název funkce pro lokální zachycení události onMouseClick na baru
pconBarOver=null;  // Název funkce pro lokální zachycení události onMouseOver  na baru
pconPadClick=null; // Název funkce pro lokální zachycení události onMouseClick na padu
pconPadOver=null;  // Název funkce pro lokální zachycení události onMouseOver  na padu


/* Základní obrázky                                        */
paPopup=["popup.gif","popupl.gif"];   // Obrázek pøíznaku popupu
paMark=["mark.gif","marke.gif"];   // Obrázek pøíznaku oznaèení, ne-oznaèení
paHL=["hlon.gif","hloff.gif","hlds.gif"];  // Obrázek pøíznaku aktivace, ne-aktivace, zakázaný


/* Ostatní promìnné                                        */
piReadOnly=0;          // Pøíznak, že menu je ReadOnly (nelze mìnit pøíznak Mark)
piMenuBorderWidth=1;   // Šíøka okraje menu
piMenuPadding=1;       // Šíøka výplnì menu
piPopupBorderWidth=1;   // Šíøka okraje popupu
piPopupPadding=1;       // Šíøka výplnì popupu


/***********************************************************/
/* Vrátí objekt padu/baru pro události                     */
/***********************************************************/
function GetMasterObj(loRef)
   {
   // loRef - Odkaz na objekt
   while (loRef.tagName!="BODY" && loRef.parentNode && loRef.id=="")
         {
         loRef=loRef.id==""?loRef.parentNode:loRef;
         }
   return loRef;
   }


/***********************************************************/
/* Vrátí absolutní pozici Left objektu                     */
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


/***********************************************************/
/* Vrátí absolutní pozici Top objektu                      */
/***********************************************************/
function GetAbsoluteTop(loRef)
   {
   // loRef - Odkaz na objekt
   var liTop=0;
   while (loRef.offsetParent)
         {
         liTop=liTop+loRef.offsetTop;
         loRef=loRef.offsetParent;
         }
   return liTop;
   }

/***********************************************************/
/* Resetuje menu (ikony, atd...)                          */
/***********************************************************/
function InitMenu(loMenu)
   {
   // loMenu - Objekt pmenu
   if (loMenu.Init) // Menu bylo inicializováno
      return;

   var loImg=loPad=loChild=loChilds=null;
   var lii=liy=0;
   var lcImg="";

   loMenu.Init=1;

   for (lii=0;lii<paPads.length;lii++)
       {
       loPad=document.getElementById(paPads[lii][0]);
       // nutná inicializace
       loPad.iHL=loPad.iIcon=-1;
       loPad.over=0;
       loPad._color=loPad.style.color;

       // Najdi obrázky - HL/Icon
       loChilds=loPad.getElementsByTagName("IMG");
       for (liy=0;liy<loChilds.length;liy++)
           {
           // Ikona
           if (loChilds[liy].name=="Icon")
              {
              loPad.iIcon=liy; // Index obrázku
              loChilds[liy].style.visibility="hidden";
              }

           // Pøíznak HighLite
           if (loChilds[liy].name=="HL")
              {
              loPad.iHL=liy; // Index obrázku
              loChilds[liy].src=paHL[1];
              }
           }
       }

   }


/***********************************************************/
/* Resetuje popup (ikony, atd...)                          */
/***********************************************************/
function InitPopup(loPopup)
   {
   // loPopup - Objekt popupu
   if (loPopup.Init) // Popup byl inicializován
      return;

   var loImg=loBar=loBars=loChilds=null;
   var lii=liy=0;
   var lcImg="";
   var lcUserA=navigator.userAgent;

   loPopup.Init=1;
   loPopup.Repos=0;

   // Bary najdu pomocí getElementsByTagName    
   loBars=loPopup.getElementsByTagName("DIV");
   for (lii=0;lii<loBars.length;lii++)
       {
       loBar=loBars[lii];

       // nutná inicializace
       loBar.iHL=loBar.iMark=loBar.iPopup=loBar.iIcon=-1;
       loBar.over=0;
       loBar._color=loBar.style.color;

       if (loBar.name=="Sep" && (lcUserA.search(" Opera ")>-1 || lcUserA.search("Opera")>-1))
          {
          loBar.style.width=loPopup.offsetWidth;
          continue;
          }

       loChilds=loBar.getElementsByTagName("IMG");
       for (liy=0;liy<loChilds.length;liy++)
           {
           // Mark
           if (loChilds[liy].name=="Mark")
              {
              loBar.iMark=liy; // Index obrázku
              _SetMarkBar(loBar,GetMarkBar(loBar.id)==1?1:0)
              continue;
              }

           // Ikona
           if (loChilds[liy].name=="Icon")
              {
              loBar.iIcon=liy; // Index obrázku
              lcImg=GetIconBar(loBar.id);
              if (lcImg!="")
                 loChilds[liy].src=lcImg;
              else
                 loChilds[liy].style.visibility="hidden";

              continue;
              }


           // Pøíznak následného popupu
           if (loChilds[liy].name=="Popup")
              {
              loBar.iPopup=liy; // Index obrázku
              if (GetSubPopup(loBar.id)!="")
                 {
                 if (piExpandPopup==0 && ((pcBarHoverff) || (pcBarHoverfs) || (pcBarHoverfw) || (pcBarHoverfst)))
                    loChilds[liy].style.left=loPopup.offsetWidth-loChilds[liy].offsetLeft-loChilds[liy].offsetWidth-piPopupBorderWidth-piPopupPadding+"px";

                 loChilds[liy].src=(piExpandPopup==0)?paPopup[0]:paPopup[1];
                 }
              else
                 loChilds[liy].style.visibility="hidden";
              }

           // Pøíznak HighLite
           if (loChilds[liy].name=="HL")
              {
              loBar.iHL=liy; // Index obrázku
              loChilds[liy].src=paHL[1];
              }
           }
       }
   }



/***********************************************************/
/* Vrátí ikonu baru                                        */
/***********************************************************/
function RepositionPopup(loPopup,loRef)
   {
   // loPopup - Objekt popupu
   // loRef   - Objekt vùèi kterému je popupu vyvolán
   if (loPopup.Repos==1)
      return;

   var loParent=loRef.parentNode;


   // Top|Bottom
   if (piDock==0 || piDock==2)
      {
      // Popup byl aktivován z padu
      if (loRef.id.substr(0,3)=="Pad")
         {
         loPopup.style.left=GetAbsoluteLeft(loRef)+((piExpandPopup==0)?0:loRef.offsetWidth-loPopup.offsetWidth)+"px";
         loPopup.style.top=GetAbsoluteTop(loParent)+((piDock==0)?loParent.offsetHeight:-loPopup.offsetHeight)+"px";
         }

      // Popup byl aktivován z baru
      if (loRef.id.substr(0,3)=="Bar")
         {
         loPopup.style.left=GetAbsoluteLeft(loParent)+((piExpandPopup==0)?loParent.offsetWidth:-loPopup.offsetWidth)+"px";
         loPopup.style.top=GetAbsoluteTop(loParent)+loRef.offsetTop+((piDock==0)?0:loRef.offsetHeight-loPopup.offsetHeight)+"px";
         }
      }

   // Left|Right
   if (piDock==3 || piDock==1)
      {
      // Popup byl aktivován z padu
      if (loRef.id.substr(0,3)=="Pad")
         {
         loPopup.style.left=GetAbsoluteLeft(loParent)+((piExpandPopup==0)?loParent.offsetWidth:-loPopup.offsetWidth)+"px";
         loPopup.style.top=GetAbsoluteTop(loRef)+"px";
         }

      // Popup byl aktivován z baru
      if (loRef.id.substr(0,3)=="Bar")
         {
         loPopup.style.left=GetAbsoluteLeft(loParent)+((piExpandPopup==0)?loParent.offsetWidth:-loPopup.offsetWidth)+"px";
         loPopup.style.top=GetAbsoluteTop(loRef)+"px";
         }
      }

   loPopup.Repos=1; // Nastaví pøíznak, že byl popup umístìn na správnou pozici
   }


/***********************************************************/
/* Pøesune ikonu indikující popup                          */
/***********************************************************/
function RepositionPopupIcon(loPopup)
   {
   // loPopup - Odkaz na popup
   var lii=liy=0;
   var loBar=loChilds=null;
   var lcUserA=navigator.userAgent;

   // Bary najdu pomocí getElementsByTagName    
   loBars=loPopup.getElementsByTagName("DIV");
   for (lii=0;lii<loBars.length;lii++)
       {
       loBar=loBars[lii];

       if (loBar.name=="Sep" && (lcUserA.search(" Opera ")>-1 || lcUserA.search("Opera")>-1))
          {
          loBar.style.width=loPopup.offsetWidth;
          continue;
          }
       
       if (loBar.iPopup==-1 || piExpandPopup==1 || ((pcBarHoverff) && (pcBarHoverfs) && (pcBarHoverfw) && (pcBarHoverfst)))
          continue;

       liy=loBar.iPopup;
       loChilds=loBar.getElementsByTagName("IMG");
       loChilds[liy].style.left="0px";
       loChilds[liy].style.left=loPopup.offsetWidth-loChilds[liy].offsetLeft-loChilds[liy].offsetWidth-piPopupBorderWidth-piPopupPadding+"px";
       }
   }


/***********************************************************/
/* Vrátí ikonu baru                                        */
/***********************************************************/
function GetIconBar(lcID)
   {
   // lcID - ID baru
   var lii=0;
   for (lii=0;lii<paBarsI.length;lii++)
       {
       if (paBarsI[lii][0]==lcID)
          return paBarsI[lii][1];
       }
   return "";
   }

/***********************************************************/
/* Vrátí pøíznak, zda je bar oznaèen                       */
/***********************************************************/
function GetMarkBar(lcID)
   {
   // lcID - ID baru
   var lii=0;
   for (lii=0;lii<paBarsM.length;lii++)
       {
       if (paBarsM[lii][0]==lcID)
          return paBarsM[lii][1];
       }
   return -1;
   }


/*************************************************************/
/* Interní funkce pro nastavení pøíznaku, zda je bar oznaèen */
/*************************************************************/
function _SetMarkBar(loBar,liMark)
   {
   // loBar  - Objekt baru
   // liMark - 0 - odznaè bar, 1 - oznaè bar
   var loChilds=null;

   // Bary najdu pomocí getElementsByTagName    
   loChilds=loBar.getElementsByTagName("IMG");
   loChilds[loBar.iMark].src=(liMark==0)?paMark[1]:paMark[0];
   }


/***********************************************************/
/* Nastaví pøíznak, zda je bar oznaèen                     */
/***********************************************************/
function SetMarkBar(lcID,liMark)
   {
   // lcID - ID baru
   // liMark - 0 - odznaè bar, 1 - oznaè bar
   var lii=0;
   for (lii=0;lii<paBarsM.length;lii++)
       {
       if (paBarsM[lii][0]==lcID)
          {
          paBarsM[lii][1]=liMark;
          _SetMarkBar(document.getElementById(lcID),paBarsM[lii][1]);
          break;
          }
       }
   }


/***********************************************************/
/* Vrátí zda objekt dle ID je pad                          */
/***********************************************************/
function IsPad(lcID)
   {
   // lcID - ID padu
   var lii=0;
   for (lii=0;lii<paPads.length;lii++)
       {
       if (paPads[lii][0]==lcID)
          return 1;
       }
   return 0;
   }

/***********************************************************/
/* Vrátí ID popupu poslednì aktivovaného                   */
/***********************************************************/
function GetLastPopup()
   {
   var lii=pcpopupTree.lastIndexOf(",",pcpopupTree.length);
   return (lii>=0)?pcpopupTree.substring(lii+1):"";
   }


/***********************************************************/
/* Vrátí ID popupu, které se má aktivovat z baru daného ID */
/***********************************************************/
function GetSubPopup(lcID)
   {
   // lcID - ID baru
   var lii=0;
   for (lii=0;lii<paBarsP.length;lii++)
       {
       if (paBarsP[lii][0]==lcID)
          return paBarsP[lii][1];
       }
   return "";
   }

/***********************************************************/
/* Vrátí ID baru, který aktivuje popup daného ID           */
/***********************************************************/
function GetSubBar(lcID)
   {
   // lcID - ID Popupu
   var lii=0;
   for (lii=0;lii<paBarsP.length;lii++)
       {
       if (paBarsP[lii][1]==lcID)
          return paBarsP[lii][0];
       }
   return "";
   }

/***********************************************************/
/* Vrátí ID popupu, které se má aktivovat z padu daného ID */
/***********************************************************/
function GetFirstPopup(lcID)
   {
   // lcID - ID padu
   var lii=0;
   for (lii=0;lii<paPads.length;lii++)
       {
       if (paPads[lii][0]==lcID)
          return paPads[lii][1];
       }
   return "";
   }


/***********************************************************/
/* Zobrazí nebo skryje popup                               */
/* pøi první inicalizaci, posune popup na správné místo    */
/***********************************************************/
function ShowPopup(loRef,loPopup,liShow)
   {
   // loRef   - Objekt Padu/baru
   // loPopup - Objekt Popupu
   // liShow  - 1 - zobrazit, 0 - skrýt
   var lii=liy=0;
   var lcPID=GetLastPopup(); // Poslednì aktiovaný popup
   var loBars=null;

   // Zobrazit?
   if (liShow==1)
      {
      InitPopup(loPopup);
      RepositionPopup(loPopup,loRef);
      RepositionPopupIcon(loPopup);

      loPopup.style.visibility="visible";
      // Pøidej ID poppupu do seznamu
      if (lcPID!=loPopup.id)
         pcpopupTree=pcpopupTree+","+loPopup.id;
      }

   // Skrýt?
   if (liShow==0)
      {
      if (lcPID==loPopup.id)
         {
         // Odstraò id popupu ze seznamu
         lii=pcpopupTree.lastIndexOf(",");
         if (lii>=0)
            pcpopupTree=pcpopupTree.substr(0,lii);
         }
      loPopup.style.visibility="hidden"; // Skryj popup

      if (loPopup.Init)
         {
         loBars=loPopup.getElementsByTagName("DIV");
         for (liy=0;liy<loBars.length;liy++)
             {
             HLBar(loBars[liy].id.substring(4),0);
             }
         }
      }
   }

/***********************************************************/
/* Skryje všechny popupy                                   */
/***********************************************************/
function HideAllPopup()
   {
   // Nyní shoï všechny popupy
   var lii=0;
   var loRef=null;

   if (pcLastBar!="")
      {
      HLBar(pcLastBar.substring(4),0);
      pcLastBar="";
      }

   pcPreLastBar=pcpopupTree=""; // Resetuj strom aktivovaných popupù

   if (paPopups[0]==0)
       return;

   for (lii=0;lii<paPopups.length;lii++)
       {
       loRef=document.getElementById(paPopups[lii]);
       ShowPopup(null,loRef,0);
       }
   }


/***********************************************************/
/* Resetuje pøíznak posunutí všech popupù                  */
/***********************************************************/
function ResetAllPopup()
   {
   // Nyní shoï všechny popupy
   var lii=0;
   var loRef=null;

   if (paPopups[0]==0)
       return;

   for (lii=0;lii<paPopups.length;lii++)
       {
       loRef=document.getElementById(paPopups[lii]);
       loRef.Repos=0;
       }
   }

/***********************************************************/
/* Deaktivuje všechny pady                                 */
/***********************************************************/
function HideAllPad()
   {
   var lii=0;
   var loRef=null;

   pcLastPad="";
   for (lii=0;lii<paPads.length;lii++)
       {
       _HLPad(document.getElementById(paPads[lii][0]),0,0)
       }
   }

/***********************************************************/
/* Aktivuje/deaktivuje bar                                 */
/* Má-li bar aktivovat další popup, aktivuje jej           */
/***********************************************************/
function HLBar(lcID,liType)
   {
   // lcID   - Poslední èást ID baru
   // liType - Pøíznak, zda se to má zobrazit èi skrýt
   //           1 - zobrazit
   //           0 - skrýt

   var loBar=document.getElementById("Bar_"+lcID) // bar
   var lcPID=GetSubPopup(loBar.id); // ID navazujícího popupu
   var lcLPID=lcLBar=""; // ID posledního aktivního popupu
   var loStyle=loBar.style;
   var loChilds=loPopup=null;

   // Aktivovat bar
   if (loStyle.backgroundColor=="" && liType==-1 || liType==1) 
      {
      if (loBar.over==1)
         return;

      if (pcBarHoverbc)
         loStyle.backgroundColor=pcBarHoverbc;

      if (pcBarHoverc)
         loStyle.color=pcBarHoverc;

      if (pcBarHoverff)
         loStyle.fontFamily=pcBarHoverff;

      if (pcBarHoverfs)
         loStyle.fontSize=pcBarHoverfs;

      if (pcBarHoverfw)
         loStyle.fontWeight=pcBarHoverfw;

      if (pcBarHoverfst)
         loStyle.fontStyle=pcBarHoverfst;

      if (pcBarHovertd)
         loStyle.textDecoration=pcBarHovertd;

      if (pcBarHoverbi)
         loStyle.backgroundImage=pcBarHoverbi;

      if (loBar.iHL!=-1)
         {
         loChilds=loBar.getElementsByTagName("IMG");
         loChilds[loBar.iHL].src=paHL[0];
         }

      // Zjisti ID poslednì ativovaného popupu
      lcLPID=GetLastPopup();

      // Skryj popup a všechny v hierarchii
      // a taky shoï aktvní bary, které tyto popupy vyvolaly
      if (lcLPID!="" && lcLPID!=loBar.parentNode.id)
         {
         while (lcLPID!=loBar.parentNode.id)
            {
            loPopup=document.getElementById(lcLPID);
            ShowPopup(null,loPopup,0); // Skryj popup
            lcLBar=GetSubBar(lcLPID);
            HLBar(lcLBar.substring(4),0);
            lcLPID=GetLastPopup();
            }
         }

      // Pokud má aktivovat popup
      (lcPID!="")?ShowPopup(loBar,document.getElementById(lcPID),1):false;
      
      loBar.over=1;
      pcPreLastBar=pcLastBar;
      pcLastBar=loBar.id;

      RepositionPopupIcon(loBar.parentNode);

      // Pokud je definována promìnná
      (pconBarOver)?eval(pconBarOver+"(loBar)"):false;
      }
   else
      {
      if (loStyle.backgroundColor==pcBarHoverbc && liType==-1 || liType==0)
         {
         if (pcBarHoverbc)
            loStyle.backgroundColor="";

         if (pcBarHoverc)
            loStyle.color=loBar._color;

         if (pcBarHoverff)
            loStyle.fontFamily="";

         if (pcBarHoverfs)
            loStyle.fontSize="";

         if (pcBarHoverfw)
            loStyle.fontWeight="";

         if (pcBarHoverfst)
            loStyle.fontStyle="";

         if (pcBarHovertd)
            loStyle.textDecoration="";

         if (pcBarHoverbi)
            loStyle.backgroundImage=pcBarHoverbi;

         if (loBar.iHL!=-1)
            {
            loChilds=loBar.getElementsByTagName("IMG");
            loChilds[loBar.iHL].src=paHL[1];
            }

 
         if (pcBarHoverbi)
            loStyle.backgroundImage='url("")';

         loBar.over=0;
         }
      }

   }

/***********************************************************/
/* Interní funkce pro aktivaci/deaktivaci padu             */
/***********************************************************/
function _HLPad(loPad,liType,liPA)
   {
   // loPad  - Odkaz na objekt Padu
   // liType - Typ aktivace (1- zobrazit, 0 - skrýt)
   // liPA   - Podtyp aktivace (1 - inset, 0 - outset)

   var loStyle=loPad.style;
   var loChilds=null;

   // Má aktivovat pad?
   if (liType==1)
      {
      if (piPadBorder==1)
         {
         if (liPA==1)
            {
            // Aktivovaný pad
            loStyle.borderStyle="inset";
            loStyle.borderColor=pcbcPadActive;
            }
         else
            {
            // Aktivní pad
            loStyle.borderStyle="outset";
            loStyle.borderColor=pcbcPadHover;
            }

         loStyle.paddingRight=loStyle.paddingLeft="4px";
         loStyle.paddingTop=loStyle.paddingBottom="1px";
         }

      if (pcPadHoverbc)
         loStyle.backgroundColor=pcPadHoverbc;

      if (pcPadHoverc)
         loStyle.color=pcPadHoverc;

      if (pcPadHoverff)
         loStyle.fontFamily=pcPadHoverff;

      if (pcPadHoverfs)
         loStyle.fontSize=pcPadHoverfs;

      if (pcPadHoverfw)
         loStyle.fontWeight=pcPadHoverfw;

      if (pcPadHoverfst)
         loStyle.fontStyle=pcPadHoverfst;

      if (pcPadHovertd)
         loStyle.textDecoration=pcPadHovertd;

      if (pcPadHoverbi)
         loStyle.backgroundImage=pcPadHoverbi;

      if (loPad.iHL!=-1)
         {
         loChilds=loPad.getElementsByTagName("IMG");
         loChilds[loPad.iHL].src=paHL[0];
         }

      }   
   else
      {
      // Deaktivuj pad 
      if (piPadBorder==1)
         {
         loStyle.borderStyle="none";
         loStyle.paddingRight=loStyle.paddingLeft="5px";
         loStyle.paddingTop=loStyle.paddingBottom="0px";
         }

      if (pcPadHoverbc)
         loStyle.backgroundColor='transparent';

      if (pcPadHoverc)
         loStyle.color=loPad._color;

      if (pcPadHoverff)
         loStyle.fontFamily="";

      if (pcPadHoverfs)
         loStyle.fontSize="";

      if (pcPadHoverfw)
         loStyle.fontWeight="";

      if (pcPadHoverfst)
         loStyle.fontStyle="";

      if (pcPadHovertd)
         loStyle.textDecoration="";

      if (pcPadHoverbi)
         loStyle.backgroundImage="";


      if (loPad.iHL!=-1)
         {
         loChilds=loPad.getElementsByTagName("IMG");
         loChilds[loPad.iHL].src=paHL[1];
         }
      }   

   }

/***********************************************************/
/* Aktivace/deaktivace padu                                */
/***********************************************************/
function HLPad(lcID,liType)
   {
   // lcID   - Poslední èást ID baru
   // liType - Pøíznak, zda se to má zobrazit èi skrýt
   //           1 - zobrazit
   //           0 - skrýt

   var loPad=document.getElementById("Pad_"+lcID);
   var lii=0;
   var loStyle=loPad.style;
   var lcPID =GetFirstPopup(loPad.id);

   if ((loStyle.borderStyle=="none") && liType==-1 || liType==1)
      {

      _HLPad(loPad,1,(pipopupActive==1 || piExpandFLPopup==1?1:pipopupActive)); // Aktivuj pad
      HideAllPopup(); // Skryj všechny popupy
      // Má se aktivovat navazující popup?
      (pipopupActive==1 || piExpandFLPopup==1 && lcPID!="")?ShowPopup(loPad,document.getElementById(lcPID),1):false;
      pcLastPad=loPad.id;
      loPad.over=1;
      // Pokud je definována promìnná
      (pconPadOver)?eval(pconPadOver+"(loPad)"):false;
      }
   else
      {
      if ((loStyle.borderStyle=="outset" || loStyle.borderStyle=="inset") && liType==-1 || liType==0)
         {
         _HLPad(loPad,0,pipopupActive);
         loPad.over=0;
         }

      }
   }


/***********************************************************/
/* událost kliknutí na pad                                 */
/***********************************************************/
function ClPad(lcID)
   {
   // lcID   - Poslední èást ID padu
   var loPad=document.getElementById("Pad_"+lcID);
   var lcPID =GetFirstPopup(loPad.id);
   var loPopup=document.getElementById(lcPID);

   if (piExpandFLPopup==0)
      {
      if (pipopupActive==1)
         {
         // Popup 1. úrovnì byl aktivován
         pipopupActive=0; // Zruš pøíznak aktivace popupu 1. úrovnì
         _HLPad(loPad,1,pipopupActive); // Nastav styl padu na "Hover"
         HideAllPopup(); // Skryj všechny popupy
         }
      else
         {
         pipopupActive=1; // Nastav pøíznak aktivace popupu 1. úrovnì
         _HLPad(loPad,1,pipopupActive); // Nastav styl padu na "Active"
         (loPopup)?ShowPopup(loPad,loPopup,1):false // Zobraz popup 
         }
      }

   // Pokud je definována promìnná
   (pconPadClick)?eval(pconPadClick+"(loPad)"):false;
   }


/***********************************************************/
/* událost kliknutí na bar                                 */
/***********************************************************/
function ClBar(lcID)
   {
   // lcID - Poslední èást ID baru
   var loBar=document.getElementById("Bar_"+lcID);
   var lii=GetMarkBar(loBar.id);

   // Zjisti, zda je bar v seznamu barù, které lze oznaèit/odznaèit
   if (piReadOnly==0)
      lii!=-1?SetMarkBar(loBar.id,lii==0?1:0):false;

   // Pokud je definována promìnná
   (pconBarClick)?eval(pconBarClick+"(loBar)"):false;

   HideAllPopup();  // Skryj všechny popupy
   HideAllPad();    // Deaktivuj všechny pady
   pipopupActive=0; // Zruš pøíznak aktivace popupu 1. úrovnì
   }

/***********************************************************/
/* Globální handler události MouseDown                     */
/***********************************************************/
function GMouseDown(loev)
   {
   // loev for Mozilla
   var loObj=null;
   var lcID="";
   var liHide=0;

   // Detekuj objekt na kterém došlo k události
   loev=((loev)?loev:event);
   if (loev.target)
      loObj=((loev.target.nodeName && loev.target.nodeName=="#text")?loev.target.parentNode:loev.target);
   else
      if (loev.srcElement)
         loObj=loev.srcElement;
      else
         liHide=1;

   // Pozor - je nad body
   if (liHide==1 || loObj.tagName=="HTML" || loObj.tagName=="BODY" || loObj.className=="menu")
      liHide=1;

   if (liHide==0)
      {
      loObj=GetMasterObj(loObj);
      lcID=loObj.id.substr(0,3);
      if (lcID=="Pad")
         ClPad(loObj.id.substring(4));
      else
         if (lcID=="Bar")
            ClBar(loObj.id.substring(4));
         else
            liHide=1;
      }

   if (liHide==1)
      {
      HideAllPopup();  // Skryj všechny popupy
      HideAllPad();    // Deaktivuj všechny pady
      pipopupActive=0; // Zruš pøíznak aktivace popupu 1. úrovnì
      }
   }

/***********************************************************/
/* Globální handler události MouseOver                     */
/***********************************************************/
function GMouseOver(loev)
   {
   // loev for Mozilla
   var loObj=loLBar=null;
   var lcID="";
   

   // Detekuj objekt na kterém došlo k události
   loev=((loev)?loev:event);
   if (loev.target)
      loObj=((loev.target.nodeName && loev.target.nodeName=="#text")?loev.target.parentNode:loev.target);
   else
      if (loev.srcElement)
         loObj=loev.srcElement;
      else
         return;

   // Pozor - je nad body
   if (loObj.tagName=="HTML" || loObj.tagName=="BODY")
      return;

   loObj=GetMasterObj(loObj);
   lcID=loObj.id.substr(0,3);

   if (lcID=="Pad") // Pad
      {
      HideAllPad();
      HLPad(loObj.id.substring(4),1);
      }
   else
      if (lcID=="Bar") // Bar
         {
         if (pcLastBar!="")
            {
            loLBar=document.getElementById(pcLastBar);
            (loObj.parentNode.id==loLBar.parentNode.id && loObj.over==0)?HLBar(pcLastBar.substring(4),0):false;
            }
         HLBar(loObj.id.substring(4),1);
         }
   }

/***********************************************************/
/* Globální handler události MouseOut                      */
/***********************************************************/
function GMouseOut(loev)
   {
   // loev for Mozilla
   var loObj=null;
   var lcID="";

   // Detekuj objekt na kterém došlo k události
   loev=((loev)?loev:event);
   if (loev.target)
      loObj=((loev.target.nodeName && loev.target.nodeName=="#text")?loev.target.parentNode:loev.target);
   else
      if (loev.srcElement)
         loObj=loev.srcElement;
      else
         return;

   // Pozor - je nad body
   if (loObj.tagName=="HTML" || loObj.tagName=="BODY")
      {
      (pipopupActive==0 && piExpandFLPopup==0)?HideAllPad():false;
      return;
      }

   loObj=GetMasterObj(loObj);
   lcID=loObj.id.substr(0,3);

   // Pad
   if (lcID=="Pad" && pipopupActive==0 && piExpandFLPopup==0)
      HLPad(loObj.id.substring(4),0);
   else
      // Menu
      if (lcID=="Men" && pipopupActive==0 && piExpandFLPopup==0)
         HideAllPad();

   }


/***********************************************************/
/* Globální handler události MouseMove                     */
/***********************************************************/
function GMouseMove(loev)
   {
   // loev for Mozilla
   var loObj=null;
   var liHide=0;

   // Detekuj objekt na kterém došlo k události
   loev=((loev)?loev:event);
   if (loev.target)
      loObj=((loev.target.nodeName && loev.target.nodeName=="#text")?loev.target.parentNode:loev.target);
   else
      if (loev.srcElement)
         loObj=loev.srcElement;
      else
         liHide=1;

   // Pozor - je nad body
   if ((liHide==1 || loObj.tagName=="HTML" || loObj.tagName=="BODY") && pipopupActive==0 && piExpandFLPopup==0)
      HideAllPad(); // Deaktivuj všechny pady

   }