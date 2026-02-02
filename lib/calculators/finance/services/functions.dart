double power(double base, int decimals) {
  if (decimals ==0 ) return 1;
  double result = base;
  for (int i = 1; i < decimals; ++i) {
    result *= base;
  }
  return result;
}