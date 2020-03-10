install:
	nix-env -f . -i

update:
	nix-env -f . -u

list:
	@nix-env -q

gen:
	@nix-env --list-generations
