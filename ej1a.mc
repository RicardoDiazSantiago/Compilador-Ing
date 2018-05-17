int i;
int k=i;
float pi=3.1416;
int f factorial;

int factorial(int i)
{
   if(i<=1)
     return 1;
   else
      return i*factorial(i-1);
}

float areaC(float radio)
{
	return 3.1416*radio*radio;

}

main(){
	int f=factorial(5);
	print("El factorial de 5\t\t es\012\015 y...\
             adios\n");
	print(f);

	print("El área de un círculo de radio r=5.3 es:");
	print(areaC(5.3));

}


