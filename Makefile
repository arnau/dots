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
	ln -s ~/.dots/inputrc ~/.inputrc
