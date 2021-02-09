all:
	python3 main.py sockttos/boot.sockttscript
	python3 main.py sockttos/kernel.sockttscript
	nasm -f bin sockttos/boot.asm -o sockttos/boot.bin
	nasm -f bin sockttos/kernel.asm -o sockttos/kernel.bin
	dd if=sockttos/boot.bin of=sockttos/os.iso
