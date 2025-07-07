float Quake_Raiz_Quadrada_Inversa(float numero)
{
    long i;
    float x2, y;
    const float tres_meios = 1.5F;

    x2 = numero * 0.5F;
    y  = numero;
    i  = * ( long * ) &y;                           // coisa do capeta
    i  = 0x5f3759df - ( i >> 1 );                   // mistério
    y  = * ( float * ) &i;
    y  = y * ( tres_meios - ( x2 * y * y ) );       // primeira iteração
    // y  = y * ( tres_meios - ( x2 * y * y ) );    // segunda iteração opcional

    return y;
}
