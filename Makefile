install:
	nix-env -f . -i

update:
	nix-channel --update
	nix-env -f . -u

list:
	@nix-env -q

gen:
	@nix-env --list-generations

setup:
	ln -s ~/.dots/zshrc ~/.zshrc
	cp -R ~/.dots/config/alacritty ~/.config/
	cp -R ~/.dots/config/kitty ~/.config/

slurp-state:
	cp ~/.config/kitty/kitty.conf config/kitty/
