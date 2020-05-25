app.exe:
	gcc -o $@ main.c

run:
	./app.exe

disnasm:
	objdump -d app.exe > app_disnasm.txt

disintel:
	objdump -Mintel -d app.exe > app_disintel.txt

clean:
	rm -f *.o *.exe *.txt