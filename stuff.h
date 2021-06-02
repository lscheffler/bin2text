#IF VERSION(5)<800 THEN
 #DEFINE dnVersion7_Prog					'YES'								&& Ist älter als Version  8.00
#ENDIF &&VERSION(5)<800
#IF VERSION(5)<900 THEN
 #DEFINE dnVersion8_Prog					'YES'								&& Ist älter als Version  9.00
#ENDIF &&VERSION(5)<900
#IF VERSION(5)<1000 THEN
 #DEFINE dnVersion9_Prog					'YES'								&& Ist älter als Version 10.00
 #IF RIGHT(VERSION(4),4)='7423' THEN
*SP2 KB968409
  #DEFINE dcV9SP							'7423'
 #ELSE &&RIGHT(VERSION(4),4)='7423'
  #IF RIGHT(VERSION(4),4)='5815' THEN
*SP2
   #DEFINE dcV9SP							'5815'
  #ELSE &&RIGHT(VERSION(4),4)='5815'
   #IF RIGHT(VERSION(4),4)='3504' THEN
    #DEFINE dcV9SP							'3504'
   #ELSE &&RIGHT(VERSION(4),4)='3504'
*VFP9 vanilla
    #DEFINE dcV9SP							'2412'
   #ENDIF &&RIGHT(VERSION(4),4)='3504'
  #ENDIF &&RIGHT(VERSION(4),4)='5815'
 #ENDIF &&RIGHT(VERSION(4),4)='7423'
#ENDIF &&VERSION(5)<1000

#DEFINE True								.T.
#DEFINE False								.F.
#DEFINE NIL									.NULL.
#DEFINE dcB2T_Verno							"1.1.4"

#DEFINE dcFB2P_Verno_Min					"1.19.57"