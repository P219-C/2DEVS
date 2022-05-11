function [t_esquina_p] = D_FO_Plano(ct0, ct1, ct2, h, cs0, cs1, cs2, cs3)

cs = (cs0 + cs1 + cs2 + cs3) / 4;

t3 = ct0 + sqrt(2*(h*cs)^2 - (ct2 - ct1)^2);

t_esquina_p = t3;

end