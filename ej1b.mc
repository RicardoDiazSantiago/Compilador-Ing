entero i;
entero k=i;
flotante pi=3.1416;
entero f factorial;

entero factorial(entero i)
{
   si(i<=1)
     regresa 1;
   otro
      regresa i*factorial(i-1);
}

flotante areaC(flotante radio)
{
	regresa 3.1416*radio*radio;

}

principal(){
	entero f=factorial(5);
	despliega("El factorial de 5\t\t es\012\015 y...\
             adios\n");
	despliega(f);

	despliega("El área de un círculo de radio r=5.3 es:");
	despliega(areaC(5.3));

}


