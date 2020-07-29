clear all
clc

global NE NN NDOFN NNODE NUMGEN BLOC ND BEleInf GAUSS Guass_Mass
ElementInformation
GAUSS=3;
Guass_Mass=5;
global LM 
LM=LMF;
LM_ANCF=LMF;%方便日后一起画图

global Init_curvature Init_J0 Init_Green
q0=CI;
[Init_curvature Init_J0 Init_Green]=Init_Vaule(q0);


global Mass Gravity
[Mass Gravity]=MassF(q0);
global VE1 VE2 VA VC VO VSx VSxx
Cons;