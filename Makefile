install:
	nix-env -f . -i

install-asdf:
	git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.8.0
	mkdir -p ~/.config/fish/completions
	cp ~/.asdf/completions/asdf.fish ~/.config/fish/completions

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
	cp -R ~/.dots/config/broot ~/.config/

slurp-state:
	cp ~/.config/kitty/kitty.conf config/kitty/
