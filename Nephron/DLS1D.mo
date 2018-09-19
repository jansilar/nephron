within Nephron;

record DLS1D
  Real x0(unit = "m") = 0.0;
  Real L(unit = "m") = 5.0;
  Real dx(unit= "m") = L/(N-1);
  Real[N] x(each unit = "m") = {x0 + dx*i for i in 0:N-1};
  constant Integer N(unit = "1") = 101;
end DLS1D;