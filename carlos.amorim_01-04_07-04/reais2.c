#include <stdio.h>

int main(void){
    float massa_kg = 1.0E3; //mil
    double massa_g = 1.0e6;  //milhao
    float massa_ton = 1;

    printf("\nIntroduza a Massa em TONELADAS: ");
    scanf("%f", &massa_ton);
    
    //massa_kg = massa_ton * massa_kg;
    //massa_g = massa_ton * massa_g;
        
    printf("\nMassa em kg = %.6e\n", massa_ton * massa_kg);
    printf("Massa em g = %.6e\n\n", massa_ton * massa_g);

    printf("\nMassa em kg = %f\n", massa_ton * massa_kg);
    printf("Massa em g = %f\n\n", massa_ton * massa_g);
    
}