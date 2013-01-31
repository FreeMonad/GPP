GPP
===

An extensible and customizable interpreter for PARI/GP, written in Perl.

Example Session
===============
    (gp)? 2+2                                                                                                                                                                                                                                                                      
      %1 = 4                                                                                                                                                                                                                                                                        
    (gp)? %*9                                                                                                                                                                                                                                                                      
      %2 = 36
    (gp)? polgalois(x^3-2)                                                                                                                                                                                                                                                         
      %3 = [6, -1, 1, "S3"]                                                                                                                                                                                                                                              
    (gp)? help(taylor)                                                                                                                                                                                                                                                             
      %3 = taylor(x,t,{d=seriesprecision}): taylor expansion of x with respect to t, adding O(t^d) to all components of x.                                                                                                                                                          
    (gp)? taylor(sin(x),x)                                                                                                                                                                                                                                                         
      %4 = x - 1/6*x^3 + 1/120*x^5 - 1/5040*x^7 + 1/362880*x^9 - 1/39916800*x^11 + 1/6227020800*x^13 - 1/1307674368000*x^15 + O(x^16)                                                                                                                                               
    (gp)? quit()                                                                                                                                                                                                                                                                   
     bye!

Notes
====

Depends on libpari 2.6.0 or later being installed on the system - preferably compiled from source.