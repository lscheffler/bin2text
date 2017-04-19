function BodyClick()
   {
   if (pcLNK!="")
      {
      ShowLNKTab(pcLNK);
      pcLNK="";
      return;
      }

   if (pcLastLNK!="")
      {
      HideLNKTab(pcLastLNK);
      }
   }

function ShowLNKTab(lcID)
   {
   // lcID   - ID tabulky odkazù

   var loRef=null;
   var loSpan=document.getElementById("SPN_"+lcID);


   if (pcLastLNK!="")
      {
      HideLNKTab(pcLastLNK);
      }

   pcLastLNK="LNK_"+lcID;
   loRef=document.getElementById(pcLastLNK);
   loRef.style.visibility='visible';
   loRef.style.left=loSpan.offsetLeft+'px'
   }

function HideLNKTab(lcID)
   {
   var loRef=document.getElementById(lcID);
   loRef.style.visibility="hidden"
   pcLastLNK="";
   }
