function [t_esquina_e,flag_esferico, flag_plano] = D_FO_Esferico_syms(ct0, ct1, ct2, h, cs0, cs1, cs2, cs3)

syms t0 t1 t2 ts xs zs s_s h_h

t3= ts + (s_s * sqrt((xs+h_h)^2 + (zs+h_h)^2));

Eq1=ts-t0+s_s*sqrt(xs^2+zs^2);    %ts-t0+s*sqrt(xs^2+zs^2)=0      (Ver papel. Ecuación 1.)

ts_desp=solve(Eq1==0,ts);    %Despejando ts de la ecuación 1

Eq2_1=ts_desp-t1+s_s*sqrt((xs+h_h)^2+zs^2);   %Ecuación 2.1 y 3.1 hacen referencia a la ecuación 2 y ecuación 3 después de
Eq3_1=ts_desp-t2+s_s*sqrt(xs^2+(zs+h_h)^2);   %   haber sustituido ts. Ver papel.

zs_desp=solve(Eq2_1==0,zs);  %Despejando zs de la ecuación 2.1. Realizar esta acción nos dará dos posibles raíces de zs

Eq3_1=subs(Eq3_1,zs,zs_desp);   %Sustituyendo los dos despejes de zs en la ecuación 3.1.

xs_desp=solve(Eq3_1==0,xs);     %Despejando xs de la ecuación 3.1. Realizar esta acción nos da 4 posibles resultados/raices para xs.

%Ecuaciones a evaluar:
%   xs_evaluada=vpa(subs(xs_desp,[t0,t1,t2,h_h,s_s],[ct0,ct1,ct2,h,cs]))   %Debido a que xs queda en términos de variables conocidas, en este paso
                                                                    %       sustituimos todas esas variables para obtener 4 posibles resultados.
                                                                    
%   zs_evaluada=subs(zs_desp,[t0,t1,t2,h_h,s_s,xs],[ct0,ct1,ct2,h,cs,xs_C])    %Como ya conocemos el valor 'correcto' de xs, zs quedan en términos de variables
                                                                        %   conocidas, en este paso sustituimos todas esas variables (t0, t1, t2, h, s, xs)
                                                                        %   y obtenemos 2 posibles resultados
                                                                        
%   ts_evaluada=subs(ts_desp,[t0,s_s,xs,zs],[ct0,cs,xs_C,zs_C])                %Como ya conocemos el valor 'correcto' de xs y zx, ts queda en términos de variables conocidas,
                                                                          %    en este paso sustituimos todas esas variables (t0, s, xs, zs) y obtenemos el
                                                                          %    resultado 'correcto' para ts.      
                                                                          
%   t3=ts+s_s*sqrt((xs+h_h)^2+(zs+h_h)^2);
%   t3_esq=subs(t3,[h_h,s_s,ts,xs,zs],[h,cs,ts_C,xs_C,zs_C]) 

clear t0 t1 t2 ts xs zs s_s h_h Eq1 Eq2_1 Eq3_1

syms t0 t1 t2 ts xs zs s_s h_h

cs = (cs0 + cs1 + cs2 + cs3) / 4;

xs_evaluada=subs(xs_desp,[t0,t1,t2,h_h,s_s],[ct0,ct1,ct2,h,cs]);   %Debido a que xs queda en términos de variables conocidas, en este paso
                                                                    %       sustituimos todas esas variables para obtener 4 posibles resultados.
t_final=zeros(8,1);
resultados=zeros(8,4);
cont=1;

for ii=1:4                                                                     
    
    zs_evaluada=subs(zs_desp,[t0,t1,t2,h_h,s_s,xs],[ct0,ct1,ct2,h,cs,xs_evaluada(ii,1)]);    %Como ya conocemos el valor 'correcto' de xs, zs quedan en términos de variables
                                                                        %   conocidas, en este paso sustituimos todas esas variables (t0, t1, t2, h, s, xs)
                                                                       %   y obtenemos 2 posibles resultados
    for jj=1:2
        
        ts_evaluada=subs(ts_desp,[t0,s_s,xs,zs],[ct0,cs,xs_evaluada(ii,1),zs_evaluada(jj,1)]);                %Como ya conocemos el valor 'correcto' de xs y zx, ts queda en términos de variables conocidas,
                                                                          %    en este paso sustituimos todas esas variables (t0, s, xs, zs) y obtenemos el
                                                                          %    resultado 'correcto' para ts.      

        t_final(cont,1)=subs(t3,[h_h,s_s,ts,xs,zs],[h,cs,ts_evaluada,xs_evaluada(ii,1),zs_evaluada(jj,1)]);
        
        resultados(cont,:)=[xs_evaluada(ii,1) zs_evaluada(jj,1) ts_evaluada t_final(cont,1)];
        
        cont=cont+1;
               
    end
    
end

%Proceso de condicionales para eliminar resultados
seleccion=ones(8,1);
for ii=1:8

    if ne(imag(t_final(ii,1)),0) %Si la parte imaginaria de t_final(ii,1) es distinta de cero
        
        resultados(ii,:)=0;
        t_final(ii,1)=0;  
        seleccion(ii)=0;
        
    end
    
    if isnan(t_final(ii,1)) == 1
       
        resultados(ii,:)=0;
        t_final(ii,1)=0;  
        seleccion(ii)=0;
        
    end
    
end

tot_sel=sum(seleccion);

if (tot_sel == 0)
    
    t_esquina_e = D_FO_Plano(ct0, ct1, ct2, h, cs0, cs1, cs2, cs3);
    
    flag_plano = 1;
    flag_esferico = 0;
    
else
    
    t_esquina_e =max(resultados(:,4));
    flag_plano = 0;
    flag_esferico = 1;
end

clear t0 t1 t2 ts xs zs s_s h_h

end