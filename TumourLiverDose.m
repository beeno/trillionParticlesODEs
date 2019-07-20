function dNPdt = TumourLiverDose(t,y,flag,kT,k_T,kL,kI,k_L,kO,k_O,k_I,L0,T0,O0,I0)
    dNPdt = [-kT*y(1)*(T0-y(3)) - kL*y(1)*(L0-y(2)) - kO*y(1)*(O0-y(4)) - kI*y(1)*(I0-y(5));
             + kL*y(1)*(L0-y(2));
             + kT*y(1)*(T0-y(3));
             + kO*y(1)*(O0-y(4));
             + kI*y(1)*(I0-y(5))];
end