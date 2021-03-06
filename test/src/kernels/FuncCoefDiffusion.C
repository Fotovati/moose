#include "FuncCoefDiffusion.h"

template<>
InputParameters validParams<FuncCoefDiffusion>()
{
  InputParameters params = validParams<Kernel>();
  params.addParam<FunctionName>("coef", "0.5*x+0.5*y", "The function for conductivity");
  return params;
}

FuncCoefDiffusion::FuncCoefDiffusion(const std::string & name, InputParameters parameters) :
    Kernel(name, parameters),
    _function(getFunction("coef"))
{
}

Real
FuncCoefDiffusion::computeQpResidual()
{
  Real k = _function.value(_t, _qp);
  return k*_grad_test[_i][_qp]*_grad_u[_qp];
}

Real
FuncCoefDiffusion::computeQpJacobian()
{
  Real k = _function.value(_t, _qp);
  return k*_grad_test[_i][_qp]*_grad_phi[_j][_qp];
}
