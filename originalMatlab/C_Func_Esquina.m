function [t_esquina,flag_esferico, flag_plano] = C_Func_Esquina(ct0, ct1, ct2, h, cs0, cs1, cs2, cs3, aproximacion)

if aproximacion == 1;   %La extrapolacion a la cuarta esquina se realizara asumiendo un FRENTE DE ONDA PLANO.
    
    t_esquina = D_FO_Plano(ct0, ct1, ct2, h, cs0, cs1, cs2, cs3);
    flag_esferico = 0;
    flag_plano = 1;
    
elseif aproximacion == 0;   %La extrapolacion a la cuarta esquina se realizara asumiendo un FRENTE DE ONDA ESFERICO (metodo rapido).
    
    [t_esquina, flag_esferico, flag_plano] = D_FO_Esferico(ct0, ct1, ct2, h, cs0, cs1, cs2, cs3);
    
elseif aproximacion == 2;   %La extrapolacion a la cuarta esquina se realizara asumiendo un FRENTE DE ONDA ESFERICO (metodo lento - syms).
    
    [t_esquina,flag_esferico, flag_plano] = D_FO_Esferico_syms(ct0, ct1, ct2, h, cs0, cs1, cs2, cs3);
    
end
    
end