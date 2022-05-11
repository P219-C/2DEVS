function [t_esquina_e,flag_esferico, flag_plano] = D_FO_Esferico(ct0, ct1, ct2, h, cs0, cs1, cs2, cs3)



xs_desp = -ones(4,1);
resultados = -ones(8,4);
t_final = -ones(8,1);
seleccion = ones(8,1);
%redondeo=11;
c_s = (cs0 + cs1 + cs2 + cs3) / 4;

xs_desp(1,1) = -(ct0^2*ct1^2 - 2*ct0^2*ct2^2 + ct1^2*ct2^2 + ct0*((ct0 - ct1 + h*c_s)*(ct1 - ct0 + h*c_s)*(ct0 - ct2 + h*c_s)*(ct2 - ct0 + h*c_s)*(2*h^2*c_s^2 - ct1^2 + 2*ct1*ct2 - ct2^2))^(1/2) - ct1*((ct0 - ct1 + h*c_s)*(ct1 - ct0 + h*c_s)*(ct0 - ct2 + h*c_s)*(ct2 - ct0 + h*c_s)*(2*h^2*c_s^2 - ct1^2 + 2*ct1*ct2 - ct2^2))^(1/2) - ct0^3*ct1 + ct0*ct2^3 + ct0^3*ct2 - ct1*ct2^3 + h^4*c_s^4 + ct0*ct1*ct2^2 - 2*ct0*ct1^2*ct2 + ct0^2*ct1*ct2 - h^2*c_s^2*ct0^2 - h^2*c_s^2*ct1^2 - h^2*c_s^2*ct2^2 + h^2*c_s^2*ct0*ct1 + h^2*c_s^2*ct0*ct2 + h^2*c_s^2*ct1*ct2)/(2*h*c_s^2*(h^2*c_s^2 - 2*ct0^2 + 2*ct0*ct1 + 2*ct0*ct2 - ct1^2 - ct2^2));
xs_desp(2,1) = -(ct0^2*ct1^2 - 2*ct0^2*ct2^2 + ct1^2*ct2^2 - ct0*((ct0 - ct1 + h*c_s)*(ct1 - ct0 + h*c_s)*(ct0 - ct2 + h*c_s)*(ct2 - ct0 + h*c_s)*(2*h^2*c_s^2 - ct1^2 + 2*ct1*ct2 - ct2^2))^(1/2) + ct1*((ct0 - ct1 + h*c_s)*(ct1 - ct0 + h*c_s)*(ct0 - ct2 + h*c_s)*(ct2 - ct0 + h*c_s)*(2*h^2*c_s^2 - ct1^2 + 2*ct1*ct2 - ct2^2))^(1/2) - ct0^3*ct1 + ct0*ct2^3 + ct0^3*ct2 - ct1*ct2^3 + h^4*c_s^4 + ct0*ct1*ct2^2 - 2*ct0*ct1^2*ct2 + ct0^2*ct1*ct2 - h^2*c_s^2*ct0^2 - h^2*c_s^2*ct1^2 - h^2*c_s^2*ct2^2 + h^2*c_s^2*ct0*ct1 + h^2*c_s^2*ct0*ct2 + h^2*c_s^2*ct1*ct2)/(2*h*c_s^2*(h^2*c_s^2 - 2*ct0^2 + 2*ct0*ct1 + 2*ct0*ct2 - ct1^2 - ct2^2));
xs_desp(3,1) = -(ct0^2*ct1^2 + 4*ct0^2*ct2^2 + ct1^2*ct2^2 + ct0*(-(ct0 - ct1 + h*c_s)*(ct1 - ct0 + h*c_s)*(ct0 - ct2 + h*c_s)*(ct2 - ct0 + h*c_s)*(- 2*h^2*c_s^2 + 4*ct0^2 - 4*ct0*ct1 - 4*ct0*ct2 + ct1^2 + 2*ct1*ct2 + ct2^2))^(1/2) - ct1*(-(ct0 - ct1 + h*c_s)*(ct1 - ct0 + h*c_s)*(ct0 - ct2 + h*c_s)*(ct2 - ct0 + h*c_s)*(- 2*h^2*c_s^2 + 4*ct0^2 - 4*ct0*ct1 - 4*ct0*ct2 + ct1^2 + 2*ct1*ct2 + ct2^2))^(1/2) - 3*ct0^3*ct1 - ct0*ct2^3 - 5*ct0^3*ct2 + ct1*ct2^3 + 2*ct0^4 + h^4*c_s^4 - 5*ct0*ct1*ct2^2 - 2*ct0*ct1^2*ct2 + 7*ct0^2*ct1*ct2 - 3*h^2*c_s^2*ct0^2 - h^2*c_s^2*ct1^2 - h^2*c_s^2*ct2^2 + 3*h^2*c_s^2*ct0*ct1 + 3*h^2*c_s^2*ct0*ct2 - h^2*c_s^2*ct1*ct2)/(2*h*c_s^2*(h^2*c_s^2 - 2*ct0^2 + 2*ct0*ct1 + 2*ct0*ct2 - ct1^2 - ct2^2));
xs_desp(4,1) = -(ct0^2*ct1^2 + 4*ct0^2*ct2^2 + ct1^2*ct2^2 - ct0*(-(ct0 - ct1 + h*c_s)*(ct1 - ct0 + h*c_s)*(ct0 - ct2 + h*c_s)*(ct2 - ct0 + h*c_s)*(- 2*h^2*c_s^2 + 4*ct0^2 - 4*ct0*ct1 - 4*ct0*ct2 + ct1^2 + 2*ct1*ct2 + ct2^2))^(1/2) + ct1*(-(ct0 - ct1 + h*c_s)*(ct1 - ct0 + h*c_s)*(ct0 - ct2 + h*c_s)*(ct2 - ct0 + h*c_s)*(- 2*h^2*c_s^2 + 4*ct0^2 - 4*ct0*ct1 - 4*ct0*ct2 + ct1^2 + 2*ct1*ct2 + ct2^2))^(1/2) - 3*ct0^3*ct1 - ct0*ct2^3 - 5*ct0^3*ct2 + ct1*ct2^3 + 2*ct0^4 + h^4*c_s^4 - 5*ct0*ct1*ct2^2 - 2*ct0*ct1^2*ct2 + 7*ct0^2*ct1*ct2 - 3*h^2*c_s^2*ct0^2 - h^2*c_s^2*ct1^2 - h^2*c_s^2*ct2^2 + 3*h^2*c_s^2*ct0*ct1 + 3*h^2*c_s^2*ct0*ct2 - h^2*c_s^2*ct1*ct2)/(2*h*c_s^2*(h^2*c_s^2 - 2*ct0^2 + 2*ct0*ct1 + 2*ct0*ct2 - ct1^2 - ct2^2));
%--------------->>>
%xs_desp=round(real(xs_desp),redondeo) + (round(imag(xs_desp),redondeo))*1i;
%-------------->>>>

cont = 1;
for ii=1:4
   
    zs_desp = -ones(2,1);
    zs_desp(1,1) = -((ct0 - ct1 + h*c_s)*(ct1 - ct0 + h*c_s)*(ct0 - ct1 + h*c_s + 2*c_s*xs_desp(ii,1))*(ct1 - ct0 + h*c_s + 2*c_s*xs_desp(ii,1)))^(1/2)/(2*(c_s*ct0 - c_s*ct1));
    zs_desp(2,1) = ((ct0 - ct1 + h*c_s)*(ct1 - ct0 + h*c_s)*(ct0 - ct1 + h*c_s + 2*c_s*xs_desp(ii,1))*(ct1 - ct0 + h*c_s + 2*c_s*xs_desp(ii,1)))^(1/2)/(2*(c_s*ct0 - c_s*ct1));
    %-------->>>
    %zs_desp=round(real(zs_desp),redondeo) + (round(imag(zs_desp),redondeo))*1i;
    %-------->>>
    
    for jj=1:2
        
        ts_desp = ct0 - c_s*(xs_desp(ii,1)^2 + zs_desp(jj,1)^2)^(1/2);        
        %------------>>>>
        %ts_desp = round(real(ts_desp),redondeo) + (round(imag(ts_desp),redondeo))*1i;
        %------------>>>>
        
        t_final(cont,1) = ts_desp + (c_s * sqrt((xs_desp(ii,1)+h)^2 + (zs_desp(jj,1)+h)^2));
        
        resultados(cont,:) = [xs_desp(ii,1) zs_desp(jj,1) ts_desp t_final(cont,1)];
        cont = cont+1;
        
    end
    
end

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
    
    
    %0;
    flag_plano = 1;
    flag_esferico = 0;
    
else
    
    t_esquina_e =max(t_final);
    %1
    flag_plano = 0;
    flag_esferico = 1;
    
end


end