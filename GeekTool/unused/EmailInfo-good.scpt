FasdUAS 1.101.10   ��   ��    k             l     ��  ��     !/usr/bin/osascript     � 	 	 & ! / u s r / b i n / o s a s c r i p t   
  
 l     ����  r         I    ������
�� .misccurdldt    ��� null��  ��    o      ���� 0 timenow timeNow��  ��        l    ����  r        I   �� ��
�� .sysontocTEXT       shor  m    	���� ��    o      ���� 0 esc  ��  ��        l    ����  r        m       �      o      ���� 0 	finaltext 	finalText��  ��        l     ��������  ��  ��        l   8  ����   O    8 ! " ! k    7 # #  $ % $ r    * & ' & l   ( (���� ( I   (�� )��
�� .corecnte****       **** ) l   $ *���� * 6   $ + , + 2   ��
�� 
pcap , l   # -���� - =   # . / . 1    ��
�� 
pnam / m     " 0 0 � 1 1  M a i l��  ��  ��  ��  ��  ��  ��   ' o      ���� 0 
powercheck 
powerCheck %  2�� 2 Z   + 7 3 4���� 3 =   + . 5 6 5 o   + ,���� 0 
powercheck 
powerCheck 6 m   , -����   4 L   1 3 7 7 m   1 2 8 8 � 9 9  ��  ��  ��   " m     : :�                                                                                  sevs  alis    t  Man                        ɧ2�H+     jSystem Events.app                                               ;l�J��        ����  	                CoreServices    ɧ�O      �K$b       j   &   %  1Man:System:Library:CoreServices:System Events.app   $  S y s t e m   E v e n t s . a p p    M a n  -System/Library/CoreServices/System Events.app   / ��  ��  ��     ; < ; l     ��������  ��  ��   <  = > = l  9 ?���� ? O   9 @ A @ k   E B B  C D C r   E S E F E l  E O G���� G e   E O H H n   E O I J I 1   J N��
�� 
mbuc J 1   E J��
�� 
inmb��  ��   F o      ���� 0 unreadcount unreadCount D  K L K Z   TL M N���� M ?   T Y O P O o   T W���� 0 unreadcount unreadCount P m   W X����   N k   \H Q Q  R S R r   \ t T U T l  \ p V���� V 6  \ p W X W n   \ e Y Z Y 2  a e��
�� 
mssg Z 1   \ a��
�� 
inmb X =  f o [ \ [ 1   g k��
�� 
isrd \ m   l n��
�� boovfals��  ��   U o      ���� 0 themessages theMessages S  ] ^ ] Z   u � _ `�� a _ ?   u | b c b o   u x���� 0 unreadcount unreadCount c m   x {���� 
 ` r    � d e d m    ����� 
 e o      ���� 0 unreadloopval unreadLoopVal��   a r   � � f g f o   � ����� 0 unreadcount unreadCount g o      ���� 0 unreadloopval unreadLoopVal ^  h i h l   � ��� j k��   j u o				-- Display all unread messgages with this method		repeat with i from 1 to number of items in theMessages    k � l l � 	 	  	 	 - -   D i s p l a y   a l l   u n r e a d   m e s s g a g e s   w i t h   t h i s   m e t h o d  	 	 r e p e a t   w i t h   i   f r o m   1   t o   n u m b e r   o f   i t e m s   i n   t h e M e s s a g e s  i  m n m l  � ��� o p��   o H B Display the latest unread messages as specified by the loop value    p � q q �   D i s p l a y   t h e   l a t e s t   u n r e a d   m e s s a g e s   a s   s p e c i f i e d   b y   t h e   l o o p   v a l u e n  r�� r Y   �H s�� t u�� s k   �C v v  w x w r   � � y z y n   � � { | { 4   � ��� }
�� 
cobj } o   � ����� 0 i   | o   � ����� 0 themessages theMessages z o      ���� 0 thismessage thisMessage x  ~  ~ Z   � � � ��� � � =  � � � � � n   � � � � � 1   � ���
�� 
isfl � o   � ����� 0 thismessage thisMessage � m   � ���
�� boovtrue � r   � � � � � b   � � � � � b   � � � � � b   � � � � � o   � ����� 0 esc   � m   � � � � � � �  [ 3 1 m "   � o   � ����� 0 esc   � m   � � � � � � �  [ 0 m � o      ���� 
0 bullet  ��   � r   � � � � � m   � � � � � � �  �   � o      ���� 
0 bullet     � � � r   � � � � � b   � � � � � b   � � � � � b   � � � � � b   � � � � � o   � ����� 0 esc   � m   � � � � � � �  [ 3 3 m � l  � � ����� � I  � ��� ���
�� .emaleafnutf8        utf8 � n   � � � � � 1   � ���
�� 
sndr � o   � ����� 0 thismessage thisMessage��  ��  ��   � o   � ����� 0 esc   � m   � � � � � � �  [ 0 m � o      ���� 0 frommsg fromMsg �  � � � r   � � � � � n   � � � � � 1   � ���
�� 
rdrc � o   � ����� 0 thismessage thisMessage � o      ���� 0 msgdate msgDate �  � � � r   � � � � n   � � � � � 1   � ���
�� 
tstr � o   � ����� 0 msgdate msgDate � o      ���� 0 recmsg recMsg �  � � � r   � � � b   � � � b   � � � b   � � � b  	 � � � o  ���� 0 esc   � m   � � � � �  [ 3 6 m � l 	 ����� � c  	 � � � n  	 � � � 1  ��
�� 
subj � o  	���� 0 thismessage thisMessage � m  ��
�� 
TEXT��  ��   � o  ���� 0 esc   � m   � � � � �  [ 0 m � o      ���� 0 subjmsg subjMsg �  ��� � r   C � � � b   A � � � b   = � � � b   9 � � � b   5 � � � b   1 � � � b   - � � � b   ) � � � b   % � � � o   !���� 0 	finaltext 	finalText � o  !$���� 
0 bullet   � o  %(���� 0 frommsg fromMsg � 1  ),��
�� 
tab  � o  -0���� 0 recmsg recMsg � 1  14��
�� 
lnfd � 1  58��
�� 
tab  � o  9<���� 0 subjmsg subjMsg � 1  =@��
�� 
lnfd � o      ���� 0 	finaltext 	finalText��  �� 0 i   t m   � �����  u o   � ����� 0 unreadloopval unreadLoopVal��  ��  ��  ��   L  ��� � Z  M � ����� � A  MT � � � o  MP���� 0 unreadloopval unreadLoopVal � m  PS���� 
 � k  W � �  � � � r  Wb � � � \  W^ � � � m  WZ���� 
 � o  Z]���� 0 unreadloopval unreadLoopVal � o      ���� 0 readloopval readLoopVal �  � � � r  c{ � � � l cw ���� � 6 cw � � � n  cl � � � 2 hl�~
�~ 
mssg � 1  ch�}
�} 
inmb � = mv � � � 1  nr�|
�| 
isrd � m  su�{
�{ boovtrue��  �   � o      �z�z 0 allmessages allMessages �  � � � l ||�y�x�w�y  �x  �w   �  ��v � Y  | ��u � � � � k  � � �  � � � r  ��   n  �� 4  ���t
�t 
cobj o  ���s�s 0 ii   o  ���r�r 0 allmessages allMessages o      �q�q 0 thismessage thisMessage �  l ���p�p   - ' display messages from the last 8 hours    �		 N   d i s p l a y   m e s s a g e s   f r o m   t h e   l a s t   8   h o u r s 
�o
 Z  ��n�m ? �� n  �� 1  ���l
�l 
rdrc o  ���k�k 0 thismessage thisMessage \  �� o  ���j�j 0 timenow timeNow l ���i�h ]  �� m  ���g�g  1  ���f
�f 
hour�i  �h   k  �
  Z  ���e = �� n  �� 1  ���d
�d 
isfl o  ���c�c 0 thismessage thisMessage m  ���b
�b boovtrue r  �� !  b  ��"#" b  ��$%$ b  ��&'& o  ���a�a 0 esc  ' m  ��(( �))  [ 3 1 m "  % o  ���`�` 0 esc  # m  ��** �++  [ 0 m! o      �_�_ 
0 bullet  �e   r  ��,-, m  ��.. �//  �  - o      �^�^ 
0 bullet   010 r  ��232 l ��4�]�\4 I ���[5�Z
�[ .emaleafnutf8        utf85 n  ��676 1  ���Y
�Y 
sndr7 o  ���X�X 0 thismessage thisMessage�Z  �]  �\  3 o      �W�W 0 frommsg fromMsg1 898 r  ��:;: l ��<�V�U< c  ��=>= n  ��?@? 1  ���T
�T 
subj@ o  ���S�S 0 thismessage thisMessage> m  ���R
�R 
TEXT�V  �U  ; o      �Q�Q 0 subjmsg subjMsg9 A�PA r  �
BCB b  �DED b  �FGF b  � HIH b  ��JKJ b  ��LML b  ��NON o  ���O�O 0 	finaltext 	finalTextO o  ���N�N 
0 bullet  M o  ���M�M 0 frommsg fromMsgK 1  ���L
�L 
lnfdI 1  ���K
�K 
tab G o   �J�J 0 subjmsg subjMsgE 1  �I
�I 
lnfdC o      �H�H 0 	finaltext 	finalText�P  �n  �m  �o  �u 0 ii   � o  ��G�G 0 readloopval readLoopVal � m  ���F�F  � m  ���E�E���v  ��  ��  ��   A 5   9 B�DP�C
�D 
cappP m   ; >QQ �RR  c o m . a p p l e . m a i l
�C kfrmID  ��  ��   > STS l     �B�A�@�B  �A  �@  T U�?U l V�>�=V o  �<�< 0 	finaltext 	finalText�>  �=  �?       �;WX�;  W �:
�: .aevtoappnull  �   � ****X �9Y�8�7Z[�6
�9 .aevtoappnull  �   � ****Y k    \\  
]]  ^^  __  ``  =aa U�5�5  �8  �7  Z �4�3�4 0 i  �3 0 ii  [ 8�2�1�0�/�. �- :�,b�+ 0�*�) 8�(Q�'�&�%�$�#�"�!� ���� � �� � ��� ������ ��� ��������(*.
�2 .misccurdldt    ��� null�1 0 timenow timeNow�0 
�/ .sysontocTEXT       shor�. 0 esc  �- 0 	finaltext 	finalText
�, 
pcapb  
�+ 
pnam
�* .corecnte****       ****�) 0 
powercheck 
powerCheck
�( 
capp
�' kfrmID  
�& 
inmb
�% 
mbuc�$ 0 unreadcount unreadCount
�# 
mssg
�" 
isrd�! 0 themessages theMessages�  
� 0 unreadloopval unreadLoopVal
� 
cobj� 0 thismessage thisMessage
� 
isfl� 
0 bullet  
� 
sndr
� .emaleafnutf8        utf8� 0 frommsg fromMsg
� 
rdrc� 0 msgdate msgDate
� 
tstr� 0 recmsg recMsg
� 
subj
� 
TEXT� 0 subjmsg subjMsg
� 
tab 
� 
lnfd� 0 readloopval readLoopVal� 0 allmessages allMessages� 
� 
hour�6*j  E�O�j E�O�E�O� !*�-�[�,\Z�81j E�O�j  �Y hUO)�a a 0�*a ,a ,EE` O_ j �*a ,a -�[a ,\Zf81E` O_ a  a E` Y 	_ E` O �k_ kh  _ a �/E` O_ a ,e  �a %�%a %E` Y 	a  E` O�a !%_ a ",j #%�%a $%E` %O_ a &,E` 'O_ 'a (,E` )O�a *%_ a +,a ,&%�%a -%E` .O�_ %_ %%_ /%_ )%_ 0%_ /%_ .%_ 0%E�[OY�TY hO_ a  �a _ E` 1O*a ,a -�[a ,\Ze81E` 2O �_ 1kih _ 2a �/E` O_ a &,�a 3_ 4  f_ a ,e  �a 5%�%a 6%E` Y 	a 7E` O_ a ",j #E` %O_ a +,a ,&E` .O�_ %_ %%_ 0%_ /%_ .%_ 0%E�Y h[OY�tY hUO� ascr  ��ޭ