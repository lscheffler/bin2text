/*
menu.js: Z�kladn� funkce pro menu
Autor:   Martin Jindra, martin.jindra@egservis.cz
Datum:   2004-05-06
Verze:   0.51
*/

/***********************************************************/
/* Dynamicky vytv��en� vlastnosti                          */
/*---------------------------------------------------------*/
/*                                                         */
/* objekt Menu:                                            */
/*   Init :  P��znak inicializace menu                     */
/*                                                         */
/* objekt popupu:                                          */
/*   Init :  P��znak inicializace popupu                   */
/*   iHL:    Index obr�zku HighLite (for Opera)            */
/*   Repos:  P��znak posunu popupu na p��slu�n� m�sto      */
/*                                                         */
/*                                                         */
/* objekt baru:                                            */
/*   over:   P��znak aktivace baru                         */
/*   iMark:  Index obr�zku Mark                            */
/*   iPopup: Index obr�zku Popup                           */
/*   iIcon:  Index obr�zku ikony                           */
/*   iHL:    Index obr�zku HighLite (for Opera)            */
/*   _color: P�vodn� barva p�sma baru                      */
/*                                                         */
/*                                                         */
/* objekt padu:                                            */
/*   over:   P��znak aktivace padu                         */
/*   iIcon:  Index obr�zku ikony                           */
/*   _color: P�vodn� barva p�sma padu                      */
/*                                                         */
/***********************************************************/



/***********************************************************/
/* Z�kladn� konfigura�n� prom�nn�                          */
/* - mus� existovat -                                      */
/***********************************************************/

/* Syst�mov� prom�nn� - obsah nem�nit                      */
pipopupActive=0;   // P��znak aktivace popupu 1. �rovn�
pcpopupTree  ="";  // Strom aktivovan�ch popup�
pcLastBar    ="";  // Posledn� aktivovan� bar
pcPreLastBar ="";  // P�edposledn� aktivovan� bar
pcLastPad    ="";  // Posledn� aktivovan� pad

/* Prom�nn� ovliv�uj�c� vzhled                             */
piDock=0;  // 0 - top, 1 - right, 2 - bottom, 3 - left
piExpandPopup=0;  // 0 - vpravo, 1 - vlevo
piExpandFLPopup=0;  // 0 - po kliku na pad, 1 - v�dy

/* Pad                                                     */
piPadBorder=1; // Zda m� pad zobrazit r�me�ek, je-li aktivn�/aktivovan� [0,1]
pcbcPadActive="#808040 #FFFFFF #FFFFFF #808040"; // Aktivn� pad    - r�me�ek
pcbcPadHover ="#FFFFFF #808040 #808040 #FFFFFF"; // Aktivovan� pad - r�me�ek

pcPadHoverbc  =null; //"#FFFFFF";                // Aktivovan� pad - barva pozad�
pcPadHoverc   =null; //"#FFFF00";                // Aktivovan� pad - barva p�sma
pcPadHoverff  =null; //"Courier New";            // Aktivovan� pad - p�smo (font-family)
pcPadHoverfs  =null; //"12pt";                   // Aktivovan� pad - p�smo-velikost (font-size)
pcPadHoverfw  =null; //"bold";                   // Aktivovan� pad - p�smo-���ka (font-weight)
pcPadHoverfst =null; //"italic";                 // Aktivovan� pad - p�smo-styl  (font-style)
pcPadHovertd  =null; //"underline";              // Aktivovan� pad - text-styl  (font-decoration)
pcPadHoverbi  =null; //'url("pict.gif")';        // Aktivovan� pad - background-image


/* Bar                                                     */
pcBarHoverbc  =null; //"#0080FF";          // Aktivovan� bar - barva pozad�
pcBarHoverc   =null; //"#000000";          // Aktivovan� bar - barva p�sma
pcBarHoverff  =null; //"Courier New";      // Aktivovan� bar - p�smo (font-family)
pcBarHoverfs  =null; //"12pt";             // Aktivovan� bar - p�smo-velikost (font-size)
pcBarHoverfw  =null; //"bold";             // Aktivovan� bar - p�smo-���ka (font-weight)
pcBarHoverfst =null; //"italic";           // Aktivovan� bar - p�smo-styl  (font-style)
pcBarHovertd  =null; //"line-through";     // Aktivovan� bar - text-styl  (text-decoration)
pcBarHoverbi  =null; //'url("pict.gif")';  // Aktivovan� bar - background-image


/* Lok�ln� handlery ud�lost�                               */
pconBarClick=null; // N�zev funkce pro lok�ln� zachycen� ud�losti onMouseClick na baru
pconBarOver=null;  // N�zev funkce pro lok�ln� zachycen� ud�losti onMouseOver  na baru
pconPadClick=null; // N�zev funkce pro lok�ln� zachycen� ud�losti onMouseClick na padu
pconPadOver=null;  // N�zev funkce pro lok�ln� zachycen� ud�losti onMouseOver  na padu


/* Z�kladn� obr�zky                                        */
paPopup=["popup.gif","popupl.gif"];   // Obr�zek p��znaku popupu
paMark=["mark.gif","marke.gif"];   // Obr�zek p��znaku ozna�en�, ne-ozna�en�
paHL=["hlon.gif","hloff.gif","hlds.gif"];  // Obr�zek p��znaku aktivace, ne-aktivace, zak�zan�


/* Ostatn� prom�nn�                                        */
piReadOnly=0;          // P��znak, �e menu je ReadOnly (nelze m�nit p��znak Mark)
piMenuBorderWidth=1;   // ���ka okraje menu
piMenuPadding=1;       // ���ka v�pln� menu
piPopupBorderWidth=1;   // ���ka okraje popupu
piPopupPadding=1;       // ���ka v�pln� popupu


/***********************************************************/
/* Vr�t� objekt padu/baru pro ud�losti                     */
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


/***********************************************************/
/* Vr�t� absolutn� pozici Top objektu                      */
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
   if (loMenu.Init) // Menu bylo inicializov�no
      return;

   var loImg=loPad=loChild=loChilds=null;
   var lii=liy=0;
   var lcImg="";

   loMenu.Init=1;

   for (lii=0;lii<paPads.length;lii++)
       {
       loPad=document.getElementById(paPads[lii][0]);
       // nutn� inicializace
       loPad.iHL=loPad.iIcon=-1;
       loPad.over=0;
       loPad._color=loPad.style.color;

       // Najdi obr�zky - HL/Icon
       loChilds=loPad.getElementsByTagName("IMG");
       for (liy=0;liy<loChilds.length;liy++)
           {
           // Ikona
           if (loChilds[liy].name=="Icon")
              {
              loPad.iIcon=liy; // Index obr�zku
              loChilds[liy].style.visibility="hidden";
              }

           // P��znak HighLite
           if (loChilds[liy].name=="HL")
              {
              loPad.iHL=liy; // Index obr�zku
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
   if (loPopup.Init) // Popup byl inicializov�n
      return;

   var loImg=loBar=loBars=loChilds=null;
   var lii=liy=0;
   var lcImg="";
   var lcUserA=navigator.userAgent;

   loPopup.Init=1;
   loPopup.Repos=0;

   // Bary najdu pomoc� getElementsByTagName    
   loBars=loPopup.getElementsByTagName("DIV");
   for (lii=0;lii<loBars.length;lii++)
       {
       loBar=loBars[lii];

       // nutn� inicializace
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
              loBar.iMark=liy; // Index obr�zku
              _SetMarkBar(loBar,GetMarkBar(loBar.id)==1?1:0)
              continue;
              }

           // Ikona
           if (loChilds[liy].name=="Icon")
              {
              loBar.iIcon=liy; // Index obr�zku
              lcImg=GetIconBar(loBar.id);
              if (lcImg!="")
                 loChilds[liy].src=lcImg;
              else
                 loChilds[liy].style.visibility="hidden";

              continue;
              }


           // P��znak n�sledn�ho popupu
           if (loChilds[liy].name=="Popup")
              {
              loBar.iPopup=liy; // Index obr�zku
              if (GetSubPopup(loBar.id)!="")
                 {
                 if (piExpandPopup==0 && ((pcBarHoverff) || (pcBarHoverfs) || (pcBarHoverfw) || (pcBarHoverfst)))
                    loChilds[liy].style.left=loPopup.offsetWidth-loChilds[liy].offsetLeft-loChilds[liy].offsetWidth-piPopupBorderWidth-piPopupPadding+"px";

                 loChilds[liy].src=(piExpandPopup==0)?paPopup[0]:paPopup[1];
                 }
              else
                 loChilds[liy].style.visibility="hidden";
              }

           // P��znak HighLite
           if (loChilds[liy].name=="HL")
              {
              loBar.iHL=liy; // Index obr�zku
              loChilds[liy].src=paHL[1];
              }
           }
       }
   }



/***********************************************************/
/* Vr�t� ikonu baru                                        */
/***********************************************************/
function RepositionPopup(loPopup,loRef)
   {
   // loPopup - Objekt popupu
   // loRef   - Objekt v��i kter�mu je popupu vyvol�n
   if (loPopup.Repos==1)
      return;

   var loParent=loRef.parentNode;


   // Top|Bottom
   if (piDock==0 || piDock==2)
      {
      // Popup byl aktivov�n z padu
      if (loRef.id.substr(0,3)=="Pad")
         {
         loPopup.style.left=GetAbsoluteLeft(loRef)+((piExpandPopup==0)?0:loRef.offsetWidth-loPopup.offsetWidth)+"px";
         loPopup.style.top=GetAbsoluteTop(loParent)+((piDock==0)?loParent.offsetHeight:-loPopup.offsetHeight)+"px";
         }

      // Popup byl aktivov�n z baru
      if (loRef.id.substr(0,3)=="Bar")
         {
         loPopup.style.left=GetAbsoluteLeft(loParent)+((piExpandPopup==0)?loParent.offsetWidth:-loPopup.offsetWidth)+"px";
         loPopup.style.top=GetAbsoluteTop(loParent)+loRef.offsetTop+((piDock==0)?0:loRef.offsetHeight-loPopup.offsetHeight)+"px";
         }
      }

   // Left|Right
   if (piDock==3 || piDock==1)
      {
      // Popup byl aktivov�n z padu
      if (loRef.id.substr(0,3)=="Pad")
         {
         loPopup.style.left=GetAbsoluteLeft(loParent)+((piExpandPopup==0)?loParent.offsetWidth:-loPopup.offsetWidth)+"px";
         loPopup.style.top=GetAbsoluteTop(loRef)+"px";
         }

      // Popup byl aktivov�n z baru
      if (loRef.id.substr(0,3)=="Bar")
         {
         loPopup.style.left=GetAbsoluteLeft(loParent)+((piExpandPopup==0)?loParent.offsetWidth:-loPopup.offsetWidth)+"px";
         loPopup.style.top=GetAbsoluteTop(loRef)+"px";
         }
      }

   loPopup.Repos=1; // Nastav� p��znak, �e byl popup um�st�n na spr�vnou pozici
   }


/***********************************************************/
/* P�esune ikonu indikuj�c� popup                          */
/***********************************************************/
function RepositionPopupIcon(loPopup)
   {
   // loPopup - Odkaz na popup
   var lii=liy=0;
   var loBar=loChilds=null;
   var lcUserA=navigator.userAgent;

   // Bary najdu pomoc� getElementsByTagName    
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
/* Vr�t� ikonu baru                                        */
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
/* Vr�t� p��znak, zda je bar ozna�en                       */
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
/* Intern� funkce pro nastaven� p��znaku, zda je bar ozna�en */
/*************************************************************/
function _SetMarkBar(loBar,liMark)
   {
   // loBar  - Objekt baru
   // liMark - 0 - odzna� bar, 1 - ozna� bar
   var loChilds=null;

   // Bary najdu pomoc� getElementsByTagName    
   loChilds=loBar.getElementsByTagName("IMG");
   loChilds[loBar.iMark].src=(liMark==0)?paMark[1]:paMark[0];
   }


/***********************************************************/
/* Nastav� p��znak, zda je bar ozna�en                     */
/***********************************************************/
function SetMarkBar(lcID,liMark)
   {
   // lcID - ID baru
   // liMark - 0 - odzna� bar, 1 - ozna� bar
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
/* Vr�t� zda objekt dle ID je pad                          */
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
/* Vr�t� ID popupu posledn� aktivovan�ho                   */
/***********************************************************/
function GetLastPopup()
   {
   var lii=pcpopupTree.lastIndexOf(",",pcpopupTree.length);
   return (lii>=0)?pcpopupTree.substring(lii+1):"";
   }


/***********************************************************/
/* Vr�t� ID popupu, kter� se m� aktivovat z baru dan�ho ID */
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
/* Vr�t� ID baru, kter� aktivuje popup dan�ho ID           */
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
/* Vr�t� ID popupu, kter� se m� aktivovat z padu dan�ho ID */
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
/* Zobraz� nebo skryje popup                               */
/* p�i prvn� inicalizaci, posune popup na spr�vn� m�sto    */
/***********************************************************/
function ShowPopup(loRef,loPopup,liShow)
   {
   // loRef   - Objekt Padu/baru
   // loPopup - Objekt Popupu
   // liShow  - 1 - zobrazit, 0 - skr�t
   var lii=liy=0;
   var lcPID=GetLastPopup(); // Posledn� aktiovan� popup
   var loBars=null;

   // Zobrazit?
   if (liShow==1)
      {
      InitPopup(loPopup);
      RepositionPopup(loPopup,loRef);
      RepositionPopupIcon(loPopup);

      loPopup.style.visibility="visible";
      // P�idej ID poppupu do seznamu
      if (lcPID!=loPopup.id)
         pcpopupTree=pcpopupTree+","+loPopup.id;
      }

   // Skr�t?
   if (liShow==0)
      {
      if (lcPID==loPopup.id)
         {
         // Odstra� id popupu ze seznamu
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
/* Skryje v�echny popupy                                   */
/***********************************************************/
function HideAllPopup()
   {
   // Nyn� sho� v�echny popupy
   var lii=0;
   var loRef=null;

   if (pcLastBar!="")
      {
      HLBar(pcLastBar.substring(4),0);
      pcLastBar="";
      }

   pcPreLastBar=pcpopupTree=""; // Resetuj strom aktivovan�ch popup�

   if (paPopups[0]==0)
       return;

   for (lii=0;lii<paPopups.length;lii++)
       {
       loRef=document.getElementById(paPopups[lii]);
       ShowPopup(null,loRef,0);
       }
   }


/***********************************************************/
/* Resetuje p��znak posunut� v�ech popup�                  */
/***********************************************************/
function ResetAllPopup()
   {
   // Nyn� sho� v�echny popupy
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
/* Deaktivuje v�echny pady                                 */
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
/* M�-li bar aktivovat dal�� popup, aktivuje jej           */
/***********************************************************/
function HLBar(lcID,liType)
   {
   // lcID   - Posledn� ��st ID baru
   // liType - P��znak, zda se to m� zobrazit �i skr�t
   //           1 - zobrazit
   //           0 - skr�t

   var loBar=document.getElementById("Bar_"+lcID) // bar
   var lcPID=GetSubPopup(loBar.id); // ID navazuj�c�ho popupu
   var lcLPID=lcLBar=""; // ID posledn�ho aktivn�ho popupu
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

      // Zjisti ID posledn� ativovan�ho popupu
      lcLPID=GetLastPopup();

      // Skryj popup a v�echny v hierarchii
      // a taky sho� aktvn� bary, kter� tyto popupy vyvolaly
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

      // Pokud m� aktivovat popup
      (lcPID!="")?ShowPopup(loBar,document.getElementById(lcPID),1):false;
      
      loBar.over=1;
      pcPreLastBar=pcLastBar;
      pcLastBar=loBar.id;

      RepositionPopupIcon(loBar.parentNode);

      // Pokud je definov�na prom�nn�
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
/* Intern� funkce pro aktivaci/deaktivaci padu             */
/***********************************************************/
function _HLPad(loPad,liType,liPA)
   {
   // loPad  - Odkaz na objekt Padu
   // liType - Typ aktivace (1- zobrazit, 0 - skr�t)
   // liPA   - Podtyp aktivace (1 - inset, 0 - outset)

   var loStyle=loPad.style;
   var loChilds=null;

   // M� aktivovat pad?
   if (liType==1)
      {
      if (piPadBorder==1)
         {
         if (liPA==1)
            {
            // Aktivovan� pad
            loStyle.borderStyle="inset";
            loStyle.borderColor=pcbcPadActive;
            }
         else
            {
            // Aktivn� pad
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
   // lcID   - Posledn� ��st ID baru
   // liType - P��znak, zda se to m� zobrazit �i skr�t
   //           1 - zobrazit
   //           0 - skr�t

   var loPad=document.getElementById("Pad_"+lcID);
   var lii=0;
   var loStyle=loPad.style;
   var lcPID =GetFirstPopup(loPad.id);

   if ((loStyle.borderStyle=="none") && liType==-1 || liType==1)
      {

      _HLPad(loPad,1,(pipopupActive==1 || piExpandFLPopup==1?1:pipopupActive)); // Aktivuj pad
      HideAllPopup(); // Skryj v�echny popupy
      // M� se aktivovat navazuj�c� popup?
      (pipopupActive==1 || piExpandFLPopup==1 && lcPID!="")?ShowPopup(loPad,document.getElementById(lcPID),1):false;
      pcLastPad=loPad.id;
      loPad.over=1;
      // Pokud je definov�na prom�nn�
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
/* ud�lost kliknut� na pad                                 */
/***********************************************************/
function ClPad(lcID)
   {
   // lcID   - Posledn� ��st ID padu
   var loPad=document.getElementById("Pad_"+lcID);
   var lcPID =GetFirstPopup(loPad.id);
   var loPopup=document.getElementById(lcPID);

   if (piExpandFLPopup==0)
      {
      if (pipopupActive==1)
         {
         // Popup 1. �rovn� byl aktivov�n
         pipopupActive=0; // Zru� p��znak aktivace popupu 1. �rovn�
         _HLPad(loPad,1,pipopupActive); // Nastav styl padu na "Hover"
         HideAllPopup(); // Skryj v�echny popupy
         }
      else
         {
         pipopupActive=1; // Nastav p��znak aktivace popupu 1. �rovn�
         _HLPad(loPad,1,pipopupActive); // Nastav styl padu na "Active"
         (loPopup)?ShowPopup(loPad,loPopup,1):false // Zobraz popup 
         }
      }

   // Pokud je definov�na prom�nn�
   (pconPadClick)?eval(pconPadClick+"(loPad)"):false;
   }


/***********************************************************/
/* ud�lost kliknut� na bar                                 */
/***********************************************************/
function ClBar(lcID)
   {
   // lcID - Posledn� ��st ID baru
   var loBar=document.getElementById("Bar_"+lcID);
   var lii=GetMarkBar(loBar.id);

   // Zjisti, zda je bar v seznamu bar�, kter� lze ozna�it/odzna�it
   if (piReadOnly==0)
      lii!=-1?SetMarkBar(loBar.id,lii==0?1:0):false;

   // Pokud je definov�na prom�nn�
   (pconBarClick)?eval(pconBarClick+"(loBar)"):false;

   HideAllPopup();  // Skryj v�echny popupy
   HideAllPad();    // Deaktivuj v�echny pady
   pipopupActive=0; // Zru� p��znak aktivace popupu 1. �rovn�
   }

/***********************************************************/
/* Glob�ln� handler ud�losti MouseDown                     */
/***********************************************************/
function GMouseDown(loev)
   {
   // loev for Mozilla
   var loObj=null;
   var lcID="";
   var liHide=0;

   // Detekuj objekt na kter�m do�lo k ud�losti
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
      HideAllPopup();  // Skryj v�echny popupy
      HideAllPad();    // Deaktivuj v�echny pady
      pipopupActive=0; // Zru� p��znak aktivace popupu 1. �rovn�
      }
   }

/***********************************************************/
/* Glob�ln� handler ud�losti MouseOver                     */
/***********************************************************/
function GMouseOver(loev)
   {
   // loev for Mozilla
   var loObj=loLBar=null;
   var lcID="";
   

   // Detekuj objekt na kter�m do�lo k ud�losti
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
/* Glob�ln� handler ud�losti MouseOut                      */
/***********************************************************/
function GMouseOut(loev)
   {
   // loev for Mozilla
   var loObj=null;
   var lcID="";

   // Detekuj objekt na kter�m do�lo k ud�losti
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
/* Glob�ln� handler ud�losti MouseMove                     */
/***********************************************************/
function GMouseMove(loev)
   {
   // loev for Mozilla
   var loObj=null;
   var liHide=0;

   // Detekuj objekt na kter�m do�lo k ud�losti
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
      HideAllPad(); // Deaktivuj v�echny pady

   }