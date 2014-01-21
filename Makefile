ipxe.iso:
	wget http://boot.ipxe.org/ipxe.iso
	echo "0e3b333950295199d80d9a8a9e84c342  ipxe.iso" | md5sum -c

src:
	mkdir src

src/ipxe.krn: src ipxe.iso
	iso-read -i ipxe.iso -e ipxe.krn -o src/ipxe.krn

src/isolinux.bin: src ipxe.iso
	iso-read -i ipxe.iso -e isolinux.bin -o src/isolinux.bin

src/isolinux.cfg: src isolinux.cfg
	cp isolinux.cfg src/isolinux.cfg

src/script.kpxe: script.kpxe
	cp script.kpxe src/script.kpxe

boot.iso: src/ipxe.krn src/isolinux.cfg src/isolinux.bin src/script.kpxe
	TZ=GMT faketime -f "1970-01-01 00:00:00" genisoimage -b isolinux.bin -c boot.cat \
	-no-emul-boot -boot-load-size 4 -boot-info-table \
	-J -l \
	-o boot.iso src
	echo "c713b1658fb32113804e3a915f848c2d42f93a4ca8210439f0aa44020340a525  boot.iso" | sha256sum -c

clean:
	rm -rf *.iso src || true

all: boot.iso
