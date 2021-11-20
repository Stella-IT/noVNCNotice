# noVNC Notice
## Purpose
A tiny bootloader for placeholder VM that says selected machine doesn't support noVNC Remote Console.

## Usage
> $ nasm notice.S -f bin -o notice.bin
>
> $ qemu-img convert -O vpc notice.bin notice.vhd
>
> $ qemu-system-i386 -m 128 -hda notice.vhd

## License
[Unlicense](./UNLICENSE).

## Disclaimers
* Stella IT is a trademark of Stella IT Inc.
* 'Sans' from UNDERTALE is a trademark of Toby Fox.
* Arch or Arch Linux is a trademark of Arch Linux.